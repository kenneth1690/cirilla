import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:webview_flutter/webview_flutter.dart';

CustomRender iframeRender({NavigationDelegate? navigationDelegate}) => CustomRender.widget(
  widget: (context, buildChildren) {
    final sandboxMode = context.tree.element?.attributes["sandbox"];
    final UniqueKey key = UniqueKey();
    final givenWidth = double.tryParse(context.tree.element?.attributes['width'] ?? "");
    final givenHeight = double.tryParse(context.tree.element?.attributes['height'] ?? "");

    final width = givenWidth ?? (givenHeight ?? 150) * 2;
    final height = givenHeight ?? (givenWidth ?? 300) / 2;

    String src = context.tree.element?.attributes['src'] ?? "";
    String url = src.length > 2 && src.substring(0, 2) == "//" ? "https:$src" : src;

    final WebViewController controller = WebViewController()
      ..setJavaScriptMode(
        sandboxMode == null || sandboxMode == "allow-scripts"
            ? JavaScriptMode.unrestricted
            : JavaScriptMode.disabled,
      )
      ..setNavigationDelegate(
        navigationDelegate ?? NavigationDelegate(),
      )
      ..loadHtmlString('<html><body><iframe loading="lazy" src="$url" frameborder="0" scrolling="auto" style="width: 100vw; height: 100vh"></iframe></body></html>');

    return AspectRatio(
      aspectRatio: width / height,
      child: ContainerSpan(
        style: context.style.copyWith(width: double.infinity, height: double.infinity),
        newContext: context,
        child: WebViewWidget(key: key, controller: controller),
      ),
    );
  },
);
