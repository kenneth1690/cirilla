import 'package:flutter/material.dart';

class TabbyCheckout extends StatefulWidget {
  final String url;
  final Widget Function(String url, BuildContext context, {String Function(String url)? customHandle}) webViewGateway;
  const TabbyCheckout({
    Key? key,
    required this.url,
    required this.webViewGateway,
  }) : super(key: key);

  @override
  State<TabbyCheckout> createState() => _TabbyCheckoutState();
}

class _TabbyCheckoutState extends State<TabbyCheckout> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: InkWell(
          onTap: () => Navigator.of(context).pop(),
          child: const Icon(Icons.chevron_left_rounded, size: 30),
        ),
        title: const Text('Tabby Checkout'),
        centerTitle: true,
        elevation: 0,
      ),
      body: widget.webViewGateway(widget.url, context),
    );
  }
}
