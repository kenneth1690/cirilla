import 'package:flutter/material.dart';

class ExpressApplePayButton extends StatefulWidget {
  final String merchantIdentifier;
  final String countryCode;
  final String displayName;
  final String currencyCode;
  final Future<Map<String, dynamic>?> Function() addToCart;
  final void Function(Map<String, dynamic> paymentResult) progressCheckout;

  const ExpressApplePayButton({
    super.key,
    required this.merchantIdentifier,
    required this.countryCode,
    required this.displayName,
    required this.currencyCode,
    required this.addToCart,
    required this.progressCheckout,
  });

  @override
  State<ExpressApplePayButton> createState() => _ExpressApplePayButtonState();
}

class _ExpressApplePayButtonState extends State<ExpressApplePayButton> {
  @override
  Widget build(BuildContext context) {
    return const SizedBox(height: 48, child: ElevatedButton(onPressed: null, child: Text('Apple Pay')));
  }
}

class ExpressGooglePayButton extends StatefulWidget {
  final String environment;
  final String merchantId;
  final String merchantName;
  final Map<String, String> gatewayParams;
  final String countryCode;
  final String currencyCode;
  final Future<Map<String, dynamic>?> Function() addToCart;
  final void Function(Map<String, dynamic> paymentResult) progressCheckout;

  const ExpressGooglePayButton({
    super.key,
    required this.environment,
    required this.merchantId,
    required this.merchantName,
    required this.gatewayParams,
    required this.countryCode,
    required this.currencyCode,
    required this.addToCart,
    required this.progressCheckout,
  });

  @override
  State<ExpressGooglePayButton> createState() => _ExpressGooglePayButtonState();
}

class _ExpressGooglePayButtonState extends State<ExpressGooglePayButton> {
  @override
  Widget build(BuildContext context) {
    return const SizedBox(height: 48, child: ElevatedButton(onPressed: null, child: Text('Google Pay')));
  }
}

