library wallet_gateway;

import 'package:flutter/material.dart';
import 'package:payment_base/payment_base.dart';
import 'package:wallet_gateway/widgets/wallet_native_screen.dart';

class WalletGateway implements PaymentBase {
  /// Payment method key
  ///
  static const key = "wallet";

  @override
  String get libraryName => "wallet_gateway";

  @override
  String get logoPath => "assets/images/wallet_logo.png";

  final String restUrl;
  final String consumerKey;
  final String consumerSecret;
  final Function(BuildContext context, {String? price, String? currency, String? symbol, String? pattern})
      formatCurrency;

  WalletGateway({
    this.restUrl = '',
    this.consumerKey = '',
    this.consumerSecret = '',
    required this.formatCurrency,
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
    await Navigator.push(
        context,
        PageRouteBuilder(
          pageBuilder: (context, _, __) => WalletNativeScreen(
            amount: amount,
            restUrl: restUrl,
            consumerKey: consumerKey,
            consumerSecret: consumerSecret,
            userId: cartId,
            formatCurrency: formatCurrency,
            checkout: checkout,
            callback: callback,
          ),
          transitionsBuilder: slideTransition,
        ),
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
