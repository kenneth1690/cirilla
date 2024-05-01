import 'package:flutter/material.dart';

import 'package:flutter_html/flutter_html.dart';

_buildText(TextContentElement contentText) {
  String text = (contentText.text ?? "").trim();
  if (text.trim().isNotEmpty) {
    return Text(text);
  }
  return SizedBox();
}

class TextHtml extends StatelessWidget {
  final String html;
  final Map<String, Style>? style;
  final bool shrinkWrap;
  final Function onCopy;

  const TextHtml({
    Key? key,
    required this.html,
    this.style,
    this.shrinkWrap = true,
    required this.onCopy,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    Style bodyStyle = Style.fromTextStyle(theme.textTheme.bodyMedium ?? TextStyle()).copyWith(
      margin: EdgeInsets.zero,
      padding: EdgeInsets.zero,
    );
    return Html(
      data: html,
      style: {
        'html': Style(
          margin: EdgeInsets.zero,
          padding: EdgeInsets.zero,
        ),
        'body': bodyStyle,
        'p': Style(
          padding: EdgeInsets.zero,
          margin: EdgeInsets.zero,
        ),
        'img': Style(
          padding: EdgeInsets.symmetric(vertical: 8),
        ),
        ...?style,
      },
      tagsList: Html.tags..addAll(["button", "br"]),
      customRenders: {
        tagMatcher("br"): CustomRender.widget(widget: (_, __) {
          return Container(
            height: 10,
          );
        }),
        tagMatcher("button"): CustomRender.widget(widget: (context, buildChildren) {
          if (context.tree is TextContentElement) {
            return _buildText(context.tree as TextContentElement);
          }

          List<InlineSpan> children = buildChildren();

          if (context.tree.attributes["id"] == "copyButton") {
            return SizedBox(
              width: double.infinity,
              height: 34,
              child: ElevatedButton(
                onPressed: () => onCopy(),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Flexible(
                      child: RichText(
                        text: TextSpan(
                          children: children,
                        ),
                      ),
                    ),
                    SizedBox(width: 12),
                    Icon(Icons.copy, size: 18),
                  ],
                ),
              ),
            );
          }

          return SizedBox(
            width: double.infinity,
            height: 34,
            child: ElevatedButton(
              onPressed: () {},
              child: RichText(
                text: TextSpan(
                  children: children,
                ),
              ),
            ),
          );
        }),
      },
      shrinkWrap: shrinkWrap,
    );
  }
}
