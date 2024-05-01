import 'dart:convert';
import 'dart:io' show Platform;

import 'package:cirilla/mixins/mixins.dart';
import 'package:cirilla/store/auth/auth_store.dart';
import 'package:cirilla/store/cart/cart_store.dart';
import 'package:cirilla/themes/default/checkout/step_success.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cirilla/express_checkout.dart';

class CirillaExpressCheckout extends StatefulWidget {
  final Function? addToCart;
  // If the widget located in the cart page, needAddToCart is false
  final bool? needAddToCart;

  final bool? isFull;

  const CirillaExpressCheckout({super.key, this.addToCart, this.needAddToCart = true, this.isFull = false});

  @override
  State<CirillaExpressCheckout> createState() => _CirillaExpressCheckoutState();
}

class _CirillaExpressCheckoutState extends State<CirillaExpressCheckout> with LoadingMixin, SnackMixin {
  late CartStore _cartStore;
  bool loading = false;

  @override
  void didChangeDependencies() {
    _cartStore = Provider.of<AuthStore>(context).cartStore;
    super.didChangeDependencies();
  }

  Future<Map<String, dynamic>?> addToCart() async {
    if (widget.addToCart == null) return null;
    return await widget.addToCart!(false, false, false, true);
  }

  String isEmpty(value, String defaultValue) {
    if (value == null || value.isEmpty || value == '') {
      return defaultValue;
    }
    return value;
  }

  List<dynamic> getDataPayment(String system, String method, String token) {
    // Payment title
    String textTitle = system == "apple_pay" ? "Apple Pay" : "Google Pay";
    String textMethod = method == "hyperpay_applepay" ? "Hyperpay" : "Stripe";

    return [
      {"key": "psp", "value": method == "hyperpay_applepay" ? "hyperpay" : "stripe"},
      {"key": "token", "value": token},
      {"key": "payment_system", "value": system},
      {"key": "payment_title", "value": "$textMethod - $textTitle"}
    ];
  }

  Future<void> onApplePayResult(Map<String, dynamic> paymentResult) async {
    if (paymentResult['status'] == 'error') {
      setState(() {
        loading = false;
      });
      return;
    }

    String shippingFirstName = paymentResult['shippingContact']?['name']?['givenName'] ?? '';
    String shippingLastName = paymentResult['shippingContact']?['name']?['familyName'] ?? '';
    String shippingEmail = paymentResult['shippingContact']?['emailAddress'] ?? '';
    String shippingPhone = paymentResult['shippingContact']?['phoneNumber'] ?? '';

    String billingFirstName = paymentResult['billingContact']?['name']?['givenName'] ?? '';
    String billingLastName = paymentResult['billingContact']?['name']?['familyName'] ?? '';
    String billingEmail = paymentResult['billingContact']?['emailAddress'] ?? '';
    String billingPhone = paymentResult['billingContact']?['phoneNumber'] ?? '';

    // Country
    // String country = paymentResult['shippingContact']?['postalAddress']?['country'] ?? '';
    String isoCountryCode = paymentResult['shippingContact']?['postalAddress']?['isoCountryCode'] ?? '';
    String postalCode = paymentResult['shippingContact']?['postalAddress']?['postalCode'] ?? '';
    String city = paymentResult['shippingContact']?['postalAddress']?['city'] ?? '';
    String street = paymentResult['shippingContact']?['postalAddress']?['street'] ?? '';
    String state = paymentResult['shippingContact']?['postalAddress']?['state'] ?? '';

    Map<String, dynamic> checkoutData = {
      'billing_address': {
        'first_name': isEmpty(billingFirstName, shippingFirstName),
        'last_name': isEmpty(billingLastName, shippingLastName),
        'email': isEmpty(billingEmail, shippingEmail),
        'phone': isEmpty(billingPhone, shippingPhone),
        'country': isoCountryCode,
        'address_1': street,
        'city': city,
        'state': state,
        'postcode': postalCode,
      },
      'shipping_address': {
        'first_name': isEmpty(shippingFirstName, billingFirstName),
        'last_name': isEmpty(shippingLastName, billingLastName),
        'email': isEmpty(shippingEmail, billingEmail),
        'phone': isEmpty(shippingPhone, billingPhone),
        'country': isoCountryCode,
        'address_1': street,
        'city': city,
        'state': state,
        'postcode': postalCode,
      }
    };

    List<dynamic> paymentData = [];

    dynamic paymentMethod = get(paymentResult, ["paymentMethod"]);
    String token = get(paymentResult, ["token"]) ?? "{}";

    paymentData = getDataPayment(
      "apple_pay",
      ApplePayConfig.paymentMethod,
      jsonEncode({
        "paymentData": jsonDecode(token),
        "paymentMethod": paymentMethod,
      }),
    );

    try {
      await _cartStore.checkoutStore.checkout(
        paymentData,
        billingOptions: checkoutData['billing_address'],
        shippingOptions: checkoutData['shipping_address'],
        options: {"payment_method": "speedypay"},
      );
      setState(() {
        loading = false;
      });
      if (mounted) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const Success()),
        );
      }
    } catch (e) {
      setState(() {
        loading = false;
      });
      if (mounted) showError(context, e);
    }
    return;
  }

  Future<void> onGooglePayResult(Map<String, dynamic> paymentResult) async {
    if (paymentResult['status'] == 'error') {
      setState(() {
        loading = false;
      });
      return;
    }
    // Get shipping address and billing address in Google

    String email = paymentResult['email'] ?? '';

    // Extra billing and shipping
    String shippingName = paymentResult['shippingAddress']?['name'] ?? '';
    List<String> listShippingName = shippingName.split(" ");
    String shippingLastName = listShippingName.last;
    listShippingName.removeLast();
    String shippingFirstName = listShippingName.join(" ");

    String shippingPhone = paymentResult['shippingAddress']?['phoneNumber'] ?? '';

    String billingName = paymentResult['paymentMethodData']?['info']?['billingAddress']?['name'] ?? '';
    List<String> listBillingName = billingName.split(" ");
    String billingLastName = listBillingName.last;
    listBillingName.removeLast();
    String billingFirstName = listBillingName.join(" ");

    String billingPhone = paymentResult['paymentMethodData']?['info']?['billingAddress']?['phoneNumber'] ?? '';

    // Country
    String isoCountryCode = paymentResult['shippingAddress']?['countryCode'] ?? '';
    String postalCode = paymentResult['shippingAddress']?['postalCode'] ?? '';
    String city = paymentResult['shippingAddress']?['locality'] ?? '';
    String street = paymentResult['shippingAddress']?['address1'] ?? '';
    String state = paymentResult['shippingAddress']?['administrativeArea'] ?? '';

    Map<String, dynamic> checkoutData = {
      'billing_address': {
        'first_name': isEmpty(billingFirstName, shippingFirstName),
        'last_name': isEmpty(billingLastName, shippingLastName),
        'email': email,
        'phone': isEmpty(billingPhone, shippingPhone),
        'country': isoCountryCode,
        'address_1': street,
        'city': city,
        'state': state,
        'postcode': postalCode,
      },
      'shipping_address': {
        'first_name': isEmpty(shippingFirstName, billingFirstName),
        'last_name': isEmpty(shippingLastName, billingLastName),
        'email': email,
        'phone': isEmpty(shippingPhone, billingPhone),
        'country': isoCountryCode,
        'address_1': street,
        'city': city,
        'state': state,
        'postcode': postalCode,
      }
    };

    List<dynamic> paymentData = [];

    String dataToken = get(paymentResult, ["paymentMethodData", "tokenizationData", "token"], "{}");

    paymentData = getDataPayment("google_pay", GooglePayConfig.gateway, jsonEncode(jsonDecode(dataToken)));

    try {
      await _cartStore.checkoutStore.checkout(
        paymentData,
        billingOptions: checkoutData['billing_address'],
        shippingOptions: checkoutData['shipping_address'],
        options: {
          'payment_method': "speedypay",
        },
      );
      setState(() {
        loading = false;
      });
      if (mounted) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const Success()),
        );
      }
    } catch (e) {
      setState(() {
        loading = false;
      });
      if (mounted) showError(context, e);
    }
    return;
  }

  Future<Map<String, dynamic>?> getCart() async {
    setState(() {
      loading = true;
    });

    Map<String, dynamic>? totals = _cartStore.cartData?.totals;

    if (totals == null) return null;

    return _cartStore.cartData?.toJson();
  }

  Future<Map<String, dynamic>?> addCart() async {
    setState(() {
      loading = true;
    });
    if (widget.addToCart == null) return null;
    return await widget.addToCart!(false, false, false, true);
  }

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      SizedBox(
        height: 48,
        width: widget.isFull == true ? double.infinity : null,
        child: _buildButton(),
      ),
      if (loading)
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          bottom: 0,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.5),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Center(
              child: iOSLoading(context, color: Colors.white, size: 12),
            ),
          ),
        ),
    ]);
  }

  Widget _buildButton() {
    if (!kIsWeb && Platform.isIOS) {
      return ExpressApplePayButton(
        countryCode: ApplePayConfig.countryCode,
        currencyCode: ApplePayConfig.currencyCode,
        displayName: ApplePayConfig.displayName,
        merchantIdentifier: ApplePayConfig.merchantIdentifier,
        addToCart: widget.needAddToCart == true ? addCart : getCart,
        progressCheckout: onApplePayResult,
      );
    }
    if (!kIsWeb && Platform.isAndroid) {
      return ExpressGooglePayButton(
        countryCode: GooglePayConfig.countryCode,
        currencyCode: GooglePayConfig.currencyCode,
        environment: GooglePayConfig.environment,
        merchantId: GooglePayConfig.merchantId,
        merchantName: GooglePayConfig.merchantName,
        gatewayParams: GooglePayConfig.gatewayParams,
        addToCart: widget.needAddToCart == true ? addCart : getCart,
        progressCheckout: onGooglePayResult,
      );
    }
    return Container();
  }
}

class Success extends StatelessWidget with AppBarMixin {
  const Success({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: baseStyleAppBar(context, title: ''), body: const StepSuccess());
  }
}
