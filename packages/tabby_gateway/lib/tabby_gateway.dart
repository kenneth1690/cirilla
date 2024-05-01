library tabby_gateway;

import 'package:flutter/material.dart';
import 'package:payment_base/payment_base.dart';
import 'package:tabby_gateway/utils/helper.dart';
import 'widgets/tabby_screen.dart';

class TabbyGateway implements PaymentBase {
  /// Payment method key
  ///
  static const key = "tabby_installments";

  @override
  String get libraryName => "tabby_gateway";

  @override
  String get logoPath => "assets/images/tabby_logo.png";

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
    String country = getData(billing, ['country'], "");

    String countries() {
      if (country == "BH") {
        if (currency == "BHD") {
          return "BHD";
        } else {
          return "error";
        }
      } else if (country == "KW") {
        if (currency == "KWD") {
          return "KW";
        } else {
          return "error";
        }
      } else {
        switch (country) {
          case "AE":
            return "AE";
          case "SA":
            return "SA";
          case "QA":
            return "QA";
          default:
            return "";
        }
      }
    }

    String? currencies() {
      switch (currency) {
        case 'SAR':
          return countries();
        case 'AED':
          return countries();
        case 'QAR':
          return countries();
        case 'KWD':
          return countries();
        case 'BHD':
          return countries();
        default:
          return "";
      }
    }

    if (context.mounted && currencies() != "" && countries() != "" && countries() != "error") {
      final result = await Navigator.push(
        context,
        PageRouteBuilder(
          pageBuilder: (context, _, __) => TabbyScreen(
            billing: billing,
            checkout: checkout,
            amount: amount,
            currency: currency,
            callback: callback,
            webViewGateway: webViewGateway,
          ),
          transitionsBuilder: slideTransition,
        ),
      );
      if (result is Map<String, dynamic> && result['order_received_url'] != null) {
        await progressServer(
          data: {
            'cart_key': cartId,
            'action': 'clean',
          },
          cartKey: cartId,
        );
        callback([]);
      }
    } else {
      if (countries() == "") {
        callback(PaymentException(
            error: 'Currently, we do not support country with country code "$country" Please check the guide again'));
      } else if (countries() == "error") {
        callback(PaymentException(
            error:
                'Currently, we do not support currency with currency code "$currency" in country with country code "$country" Please check the guide again'));
      } else if (currencies() == "") {
        callback(PaymentException(
            error:
                'Currently, we do not support currency with currency code "$currency" Please check the guide again'));
      }
    }
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
