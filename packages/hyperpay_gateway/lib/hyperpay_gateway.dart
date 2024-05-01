library hyperpay_gateway;

import 'package:flutter/material.dart';
import 'package:hyperpay_plugin/flutter_hyperpay.dart';
import 'package:hyperpay_plugin/model/ready_ui.dart';
import 'package:payment_base/payment_base.dart';

import 'services/hyperpay_services.dart';
import 'utils/locale.dart';
import 'dart:io';

class HyperpayGateway implements PaymentBase {
  /// Payment method key
  ///
  static const keyHyperPay = "hyperpay";

  @override
  String get libraryName => "hyperpay_gateway";

  @override
  String get logoPath => "assets/images/hyperpay_logo.png";
  final String shopperResultUrl;
  HyperpayGateway({
    required this.shopperResultUrl,
  });

  @override
  Future<void> initialized({
    required BuildContext context,
    required RouteTransitionsBuilder slideTransition,
    required Future Function(List p1) checkout,
    required Function(dynamic data) callback,
    required String amount,
    required String currency,
    required Map<String, dynamic> billing,
    required Map<String, dynamic> settings,
    required Future Function({String? cartKey, required Map<String, dynamic> data}) progressServer,
    required String cartId,
    required Widget Function(String url, BuildContext context, {String Function(String url)? customHandle})
        webViewGateway,
  }) async {
    await hyperPayUI(
      hyperPayKey: keyHyperPay,
      shopperResultUrl: shopperResultUrl,
      checkout: checkout,
      callback: callback,
      amount: amount,
      currency: currency,
      settings: settings,
      cartId: cartId,
      progressServer: progressServer,
    );
  }

  @override
  String getErrorMessage(Map<String, dynamic>? error) {
    if (error == null) {
      return 'Something wrong in checkout!';
    }

    if (error['message'] != null) {
      return error['message'];
    }

    return 'Error!';
  }
}

class HyperpaySTCPayGateway implements PaymentBase {
  /// Payment method key
  ///
  static const keyStcPay = "hyperpay_stcpay";

  @override
  String get libraryName => "hyperpay_gateway";

  @override
  String get logoPath => "assets/images/hyper_pay_stc.png";

  final String shopperResultUrl;
  HyperpaySTCPayGateway({
    required this.shopperResultUrl,
  });
  @override
  Future<void> initialized({
    required BuildContext context,
    required RouteTransitionsBuilder slideTransition,
    required Future Function(List p1) checkout,
    required Function(dynamic data) callback,
    required String amount,
    required String currency,
    required Map<String, dynamic> billing,
    required Map<String, dynamic> settings,
    required Future Function({String? cartKey, required Map<String, dynamic> data}) progressServer,
    required String cartId,
    required Widget Function(String url, BuildContext context, {String Function(String url)? customHandle})
        webViewGateway,
  }) async {
    await hyperPayUI(
      hyperPayKey: keyStcPay,
      shopperResultUrl: shopperResultUrl,
      checkout: checkout,
      callback: callback,
      amount: amount,
      currency: currency,
      settings: settings,
      cartId: cartId,
      progressServer: progressServer,
    );
  }

  @override
  String getErrorMessage(Map<String, dynamic>? error) {
    if (error == null) {
      return 'Something wrong in checkout!';
    }

    if (error['message'] != null) {
      return error['message'];
    }

    return 'Error!';
  }
}

class HyperpayMadaGateway implements PaymentBase {
  /// Payment method key
  ///
  static const keyMada = "hyperpay_mada";

  @override
  String get libraryName => "hyperpay_gateway";

  @override
  String get logoPath => "assets/images/hyper_pay_mada.png";

  final String shopperResultUrl;
  HyperpayMadaGateway({
    required this.shopperResultUrl,
  });
  @override
  Future<void> initialized({
    required BuildContext context,
    required RouteTransitionsBuilder slideTransition,
    required Future Function(List p1) checkout,
    required Function(dynamic data) callback,
    required String amount,
    required String currency,
    required Map<String, dynamic> billing,
    required Map<String, dynamic> settings,
    required Future Function({String? cartKey, required Map<String, dynamic> data}) progressServer,
    required String cartId,
    required Widget Function(String url, BuildContext context, {String Function(String url)? customHandle})
        webViewGateway,
  }) async {
    await hyperPayUI(
      hyperPayKey: keyMada,
      shopperResultUrl: shopperResultUrl,
      checkout: checkout,
      callback: callback,
      amount: amount,
      currency: currency,
      settings: settings,
      cartId: cartId,
      progressServer: progressServer,
    );
  }

  @override
  String getErrorMessage(Map<String, dynamic>? error) {
    if (error == null) {
      return 'Something wrong in checkout!';
    }

    if (error['message'] != null) {
      return error['message'];
    }

    return 'Error!';
  }
}

class HyperpayApplePayGateway implements PaymentBase {
  /// Payment method key
  ///
  static const keyApplePay = "hyperpay_applepay";

  @override
  String get libraryName => "hyperpay_gateway";

  @override
  String get logoPath => "assets/images/hyper_pay_apple.png";

  final String shopperResultUrl;
  final String? countryCodeApplePayIOS;
  final String merchantIdApplePayIOS;
  final String companyNameApplePayIOS;
  HyperpayApplePayGateway({
    required this.shopperResultUrl,
    this.countryCodeApplePayIOS,
    this.merchantIdApplePayIOS = "",
    this.companyNameApplePayIOS = "Test",
  });
  @override
  Future<void> initialized({
    required BuildContext context,
    required RouteTransitionsBuilder slideTransition,
    required Future Function(List p1) checkout,
    required Function(dynamic data) callback,
    required String amount,
    required String currency,
    required Map<String, dynamic> billing,
    required Map<String, dynamic> settings,
    required Future Function({String? cartKey, required Map<String, dynamic> data}) progressServer,
    required String cartId,
    required Widget Function(String url, BuildContext context, {String Function(String url)? customHandle})
        webViewGateway,
  }) async {
    await hyperPayUI(
      hyperPayKey: keyApplePay,
      shopperResultUrl: shopperResultUrl,
      countryCodeApplePayIOS: countryCodeApplePayIOS,
      checkout: checkout,
      callback: callback,
      amount: amount,
      currency: currency,
      settings: settings,
      cartId: cartId,
      progressServer: progressServer,
      merchantIdApplePayIOS: merchantIdApplePayIOS,
      companyNameApplePayIOS: companyNameApplePayIOS,
    );
  }

  @override
  String getErrorMessage(Map<String, dynamic>? error) {
    if (error == null) {
      return 'Something wrong in checkout!';
    }

    if (error['message'] != null) {
      return error['message'];
    }
    return 'Error!';
  }
}

Future<void> hyperPayUI({
  required String hyperPayKey,
  required Future Function(List p1) checkout,
  required Function(dynamic data) callback,
  required String amount,
  required String currency,
  required Map<String, dynamic> settings,
  required String cartId,
  required Future Function({String? cartKey, required Map<String, dynamic> data}) progressServer,
  String shopperResultUrl = "",
  String? countryCodeApplePayIOS,
  String merchantIdApplePayIOS = "",
  String companyNameApplePayIOS = "Test",
}) async {
  String? checkoutId;
  dynamic checkoutData;
  final String lang = Platform.localeName;

  String? country = countryCodeApplePayIOS ?? stringToLocale(lang).countryCode ?? "";

  bool testMode = "${settings['testmode']['value']}" == "1";

  FlutterHyperPay flutterHyperPay = FlutterHyperPay(
    shopperResultUrl: shopperResultUrl,
    paymentMode: testMode ? PaymentMode.test : PaymentMode.live,
    lang: lang,
  );
  try {
    checkoutData = await checkout([]);
  } catch (e) {
    callback(e);
    return;
  }
  try {
    Map<String, dynamic> data = await HyperpayServices().postCheckoutId(
      testMode: testMode,
      amount: amount,
      currency: currency,
      settings: settings,
      checkoutData: checkoutData,
    );
    checkoutId = data['id'];
  } catch (e) {
    callback(PaymentException(error: "Error:$e"));
  }
  int orderId = checkoutData["order_id"];

  List<String> brandsName = [];

  // The hyperpay Gateway payment method offers a list value
  if ('hyperpay' == hyperPayKey) {
    List hyperpayList = settings['hyper_pay_brands']['value'];
    for (var value in hyperpayList) {
      // hyperpay_plugin library does not support "AMEX" payment gateway
      if (value != "AMEX") {
        brandsName.add("$value");
      }
    }
  } else {
    // Other payment methods provide a string value
    brandsName.add(settings['hyper_pay_brands']['value']);
  }
  
  if (checkoutId != null) {
    PaymentResultData paymentResultData;
      paymentResultData = await flutterHyperPay.readyUICards(
        readyUI: ReadyUI(
          brandsName: brandsName,
          checkoutId: checkoutId,
          merchantIdApplePayIOS: merchantIdApplePayIOS,
          countryCodeApplePayIOS: country, // applepay
        companyNameApplePayIOS: companyNameApplePayIOS, // applepay
          ),
      );
      if (paymentResultData.paymentResult == PaymentResult.success ||
        paymentResultData.paymentResult == PaymentResult.sync) {
      try {
        dynamic confirmServer = await progressServer(
          data: {
            'gateway': hyperPayKey,
            'cart_key': cartId,
            'order_id': orderId,
            'checkout_id': checkoutId,
          },
          cartKey: cartId,
        );
        callback({
          'redirect': confirmServer['redirect'],
          'order_received_url': confirmServer['order_received_url'],
        });
        } catch (e) {
        callback(e);
      }
    } else {
      callback(PaymentException(error: "Cancel Payment"));
    }
  }
}
