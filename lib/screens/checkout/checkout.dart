import 'package:cirilla/constants/constants.dart';
import 'package:cirilla/mixins/loading_mixin.dart';
import 'package:cirilla/mixins/snack_mixin.dart';
import 'package:cirilla/mixins/transition_mixin.dart';
import 'package:cirilla/models/cart/gateway.dart';
import 'package:cirilla/models/models.dart';
import 'package:cirilla/screens/checkout/view/checkout_view_shipping_methods.dart';
import 'package:cirilla/store/store.dart';
import 'package:cirilla/themes/default/checkout/payment_method.dart';
import 'package:cirilla/themes/default/default.dart';
import 'package:cirilla/types/types.dart';
import 'package:cirilla/utils/address.dart';
import 'package:cirilla/utils/gateway_error.dart';
import 'package:cirilla/utils/utils.dart';
import 'package:dio/dio.dart';
import 'package:feather_icons/feather_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:payment_base/payment_base.dart';
import 'package:cirilla/payment_methods.dart';
import 'package:provider/provider.dart';

import '../../utils/webview_gateway.dart';
import 'view/checkout_view_additional.dart';
import 'view/checkout_view_cart_totals.dart';
import 'view/checkout_view_billing_address.dart';
import 'view/checkout_view_shipping_address.dart';
import 'view/checkout_view_ship_to_different_address.dart';

List<IconData> _tabIcons = [FeatherIcons.mapPin, FeatherIcons.pocket, FeatherIcons.check];

class Checkout extends StatefulWidget {
  static const routeName = '/checkout';

  final Customer? customer;
  final String? titleButtonSuccess;
  final void Function()? onClickButtonSuccess;
  final void Function()? onSuccess;

  const Checkout({
    Key? key,
    this.customer,
    this.titleButtonSuccess,
    this.onClickButtonSuccess,
    this.onSuccess,
  }) : super(key: key);

  @override
  State<Checkout> createState() => _CheckoutState();
}

class _CheckoutState extends State<Checkout> with TickerProviderStateMixin, TransitionMixin, SnackMixin, LoadingMixin {
  late TabController _tabController;
  late AuthStore _authStore;
  int visit = 0;
  int? success;

  /// order received url
  String orderReceivedUrl = '';

  late CartStore _cartStore;
  Map<String, dynamic> additional = const {};

  /// checkout address
  final _formAddressKey = GlobalKey<FormState>();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _authStore = Provider.of<AuthStore>(context);
    _cartStore = _authStore.cartStore;

    if (_cartStore.paymentStore.loading == false && _cartStore.paymentStore.gateways.isEmpty) {
      _cartStore.paymentStore.getGateways();
    }
  }

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _tabIcons.length, vsync: this);
    _tabController.addListener(() {
      if (visit != _tabController.index) {
        setState(() {
          visit = _tabController.index;
        });
      }
    });
  }

  void onGoPage(int visit, [int? visitSuccess, String? url]) {
    if (visit == 2) {
      _cartStore.checkoutStore.updateAddress();
      widget.onSuccess?.call();
    }
    setState(() {
      success = visitSuccess;
      if (url?.isNotEmpty == true) {
        orderReceivedUrl = url!;
      }
    });
    _tabController.animateTo(visit);
  }

  void _handleCallBack(dynamic data, PaymentBase payment) {
    if (data is DioException) {
      if (GatewayError.mapErrorMessage(data.response?.data) != null) {
        showError(context, GatewayError.mapErrorMessage(data.response?.data));
      } else {
        showError(context, payment.getErrorMessage(data.response?.data));
      }
    } else if (data is PaymentException) {
      showError(context, data.error);
    } else if (data is Map<String, dynamic>) {
      if (data['redirect'] == 'order') {
        onGoPage(2, 2, data['order_received_url']);
      }
    } else {
      onGoPage(2, 2);
    }
  }

  Future<void> _progressCheckout(BuildContext context) async {
    if (methods[_cartStore.paymentStore.method] == null) {
      avoidPrint('Then payment method ${_cartStore.paymentStore.method} not implement in app yet.');
      return;
    }

    PaymentBase payment = methods[_cartStore.paymentStore.method] as PaymentBase;
    Map<String, dynamic> settings = _cartStore.paymentStore.gateways[_cartStore.paymentStore.active].settings;

    if (mounted) {
      Map<String, dynamic> billing = {
        ...?_cartStore.cartData?.billingAddress,
        ..._cartStore.checkoutStore.billingAddress,
      };
      debugPrint(billing.toString());
      await payment.initialized(
        context: context,
        slideTransition: slideTransition,
        checkout: (
          List<dynamic> paymentData, {
          Map<String, dynamic>? billingOptions,
          Map<String, dynamic>? options,
          Map<String, dynamic>? shippingOptions,
        }) =>
            _cartStore.checkoutStore.checkout(
          paymentData,
          billingOptions: billingOptions,
          options: options,
          shippingOptions: shippingOptions,
          additional: additional,
        ),
        callback: (dynamic data) => _handleCallBack(data, payment),
        amount: convertCurrencyFromUnit(
            price: _cartStore.cartData?.totals?["total_price"] ?? "0",
            unit: _cartStore.cartData?.totals?["currency_minor_unit"]),
        currency: _cartStore.cartData?.totals?["currency_code"] ?? "USD",
        billing: billing,
        settings: settings,
        progressServer: _cartStore.checkoutStore.progressServer,
        cartId: '${_authStore.isLogin ? _authStore.user?.id : _cartStore.cartKey}',
        webViewGateway: buildCirillaWebViewGateway,
      );
    }
  }

  List<Gateway> _getGateways() {
    // Check if user is not logged in then hide wallet payment method
    if (!_authStore.isLogin) {
      _cartStore.paymentStore.gateways.removeWhere((e) => e.id == 'wallet');
    }
    return _cartStore.paymentStore.gateways;
  }

  void _updateAddressCustomer() {
    Map<String, dynamic> data = getBillingCustomer(widget.customer);
    _cartStore.checkoutStore.changeAddress(
      billing: data,
      shipping: _cartStore.checkoutStore.shipToDifferentAddress ? null : data,
    );
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    TranslateType translate = AppLocalizations.of(context)!.translate;
    MediaQueryData mediaQuery = MediaQuery.of(context);
    double padTop = mediaQuery.padding.top > 0 ? mediaQuery.padding.top : 30;
    return Scaffold(
      body: Stack(
        children: [
          Column(
            children: [
              TabbarView(
                icons: _tabIcons,
                visit: visit,
                isVisitSuccess: success == visit,
                padding: paddingHorizontal.add(EdgeInsets.only(top: padTop)),
              ),
              Expanded(
                child: TabBarView(
                  key: Key(orderReceivedUrl),
                  controller: _tabController,
                  physics: const NeverScrollableScrollPhysics(),
                  children: <Widget>[
                    Form(
                      key: _formAddressKey,
                      child: StepAddress(
                        totals: CheckoutViewCartTotals(cartStore: _cartStore),
                        shippingMethods: _cartStore.cartData?.needsShipping == true
                            ? CheckoutViewShippingMethods(cartStore: _cartStore)
                            : Container(),
                        address: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (widget.customer != null) ...[
                              Row(
                                children: [
                                  Expanded(
                                    child: RichText(
                                      text: TextSpan(
                                        text: translate("checkout_customer"),
                                        children: [
                                          const TextSpan(text: " "),
                                          TextSpan(
                                              text: widget.customer?.getName() ?? "",
                                              style: theme.textTheme.titleSmall),
                                        ],
                                        style: theme.textTheme.bodyMedium,
                                      ),
                                    ),
                                  ),
                                  ElevatedButton(
                                    onPressed: _updateAddressCustomer,
                                    child: Row(
                                      children: [
                                        const Icon(FeatherIcons.copy, size: 20),
                                        const SizedBox(width: itemPadding),
                                        Text(translate("checkout_copy_address"))
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 16),
                            ],
                            CheckoutViewBillingAddress(cartStore: _cartStore),
                            if (_cartStore.cartData?.needsShipping == true) ...[
                              CheckoutViewShipToDifferentAddress(
                                checkoutStore: _cartStore.checkoutStore,
                              ),
                              CheckoutViewShippingAddress(
                                cartStore: _cartStore,
                              ),
                            ],
                            CheckoutViewAdditional(
                              data: additional,
                              onChange: (value) => setState(() {
                                additional = value;
                              }),
                            ),
                          ],
                        ),
                        padding: paddingVerticalLarge,
                        bottomWidget: buildBottom(
                          start: buildButton(
                            title: translate('checkout_back'),
                            secondary: true,
                            theme: theme,
                            onPressed: () {
                              FocusManager.instance.primaryFocus?.unfocus();
                              Navigator.pop(context);
                            },
                          ),
                          end: buildButton(
                            title: translate('checkout_payment'),
                            theme: theme,
                            onPressed: () {
                              final isValid = _formAddressKey.currentState!.validate();
                              FocusManager.instance.primaryFocus?.unfocus();
                              if (!isValid) {
                                return;
                              }
                              onGoPage(1, 0);
                            },
                          ),
                          theme: theme,
                        ),
                      ),
                    ),
                    success == 1
                        ? StepFormPayment(onPayment: () => onGoPage(2, 2))
                        : StepPayment(
                            paymentMethod: Observer(
                              builder: (_) => PaymentMethod(
                                padHorizontal: layoutPadding,
                                gateways: _getGateways(),
                                active: _cartStore.paymentStore.active,
                                select: _cartStore.paymentStore.select,
                              ),
                            ),
                            padding: paddingVerticalLarge,
                            bottomWidget: buildBottom(
                              start: buildButton(
                                title: translate('checkout_back'),
                                secondary: true,
                                theme: theme,
                                onPressed: () => onGoPage(0, null),
                              ),
                              end: buildButton(
                                title: translate('checkout_payment'),
                                theme: theme,
                                onPressed: () => _progressCheckout(context),
                              ),
                              theme: theme,
                            ),
                          ),
                    StepSuccess(
                      url: orderReceivedUrl,
                      titleButton: widget.titleButtonSuccess,
                      onClickButton: widget.onClickButtonSuccess,
                    ),
                  ],
                ),
              ),
            ],
          ),
          Observer(
            builder: (_) => _cartStore.checkoutStore.loading || _cartStore.checkoutStore.loadingPayment
                ? Align(
                    alignment: FractionalOffset.center,
                    child: buildLoadingOverlay(context),
                  )
                : const SizedBox(),
          )
        ],
      ),
    );
  }

  Widget buildBottom({
    required Widget start,
    required Widget end,
    required ThemeData theme,
  }) {
    return Container(
      padding: paddingVerticalMedium.add(paddingHorizontal),
      decoration: BoxDecoration(
        color: theme.cardColor,
        boxShadow: initBoxShadow,
      ),
      child: Row(
        children: [
          Expanded(child: start),
          const SizedBox(width: itemPaddingMedium),
          Expanded(child: end),
        ],
      ),
    );
  }

  Widget buildButton({
    required String title,
    bool secondary = false,
    VoidCallback? onPressed,
    required ThemeData theme,
    bool isLoading = false,
  }) {
    return SizedBox(
      height: 48,
      child: ElevatedButton(
        onPressed: isLoading ? () => {} : onPressed,
        style: secondary
            ? ElevatedButton.styleFrom(
                foregroundColor: theme.textTheme.titleMedium?.color,
                backgroundColor: theme.colorScheme.surface,
              )
            : null,
        child: isLoading ? entryLoading(context, color: Theme.of(context).colorScheme.onPrimary) : Text(title),
      ),
    );
  }
}
