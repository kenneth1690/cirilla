import 'package:flutter/material.dart';

class HeadingContent extends StatelessWidget {
  final Widget title;
  final Widget trailing;
  final EdgeInsetsGeometry? padding;

  const HeadingContent({
    super.key,
    required this.title,
    required this.trailing,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);

    return Container(
      padding: padding,
      constraints: const BoxConstraints(minHeight: 56),
      decoration:
          BoxDecoration(color: theme.canvasColor, border: Border(bottom: BorderSide(color: theme.dividerColor))),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(child: title),
          trailing,
        ],
      ),
    );
  }
}
