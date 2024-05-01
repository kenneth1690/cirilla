import 'package:flutter/material.dart';

import 'package:flutter_html/flutter_html.dart';

CustomRenderMatcher classMatcher(String className) => (context) {
  return context.tree.element?.className == className;
};

class TextHtml extends StatelessWidget {
  final String html;
  final Map<String, Style>? style;
  final bool shrinkWrap;

  const TextHtml({
    Key? key,
    required this.html,
    this.style,
    this.shrinkWrap = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Html(
      data: html,
      style: {
        'html': Style(
            margin: EdgeInsets.zero,
            padding: EdgeInsets.zero,
        ),
        'body': Style(
            margin: EdgeInsets.zero,
            padding: EdgeInsets.zero,
            lineHeight: const LineHeight(1.4),
            fontSize: const FontSize(16),
            color: Colors.white,
            textAlign: TextAlign.center,
        ),
        'p': Style(
          padding: EdgeInsets.zero,
          margin: EdgeInsets.zero,
        ),
        'img': Style(
          padding: EdgeInsets.symmetric(vertical: 8),
        ),
        ...?style,
      },
      shrinkWrap: shrinkWrap,
    );
  }
}