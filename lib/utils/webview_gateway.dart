import 'package:flutter/material.dart';
import 'package:cirilla/webview_flutter.dart';
import 'package:cirilla/widgets/cirilla_webview.dart';

Widget buildCirillaWebViewGateway(String url, BuildContext context, {String Function(String url)? customHandle}) {
  if (url.contains("https://cirrilla-stripe-form.web.app")) {
    return CirillaWebView(
      uri: Uri.parse(url),
      javaScriptName: "Flutter_Cirilla",
      onJavaScriptMessageReceived: (JavaScriptMessage message) {
        Navigator.pop(context, message.message);
      },
      isLoading: false,
    );
  }
  return CirillaWebView(
    uri: Uri.parse(url),
    onNavigationRequest: (NavigationRequest request) {
      if (customHandle != null) {
        String value = customHandle(request.url);
        switch (value) {
          case "prevent":
            return NavigationDecision.prevent;
          default:
            return NavigationDecision.navigate;
        }
      }
      if (request.url.contains('/order-received/')) {
        Navigator.of(context).pop({'order_received_url': request.url});
        return NavigationDecision.prevent;
      }
      return NavigationDecision.navigate;
    },
    isLoading: false,
  );
}
