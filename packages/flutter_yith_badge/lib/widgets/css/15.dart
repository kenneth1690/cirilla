import 'package:flutter/material.dart';

class Css15 extends StatelessWidget {
  final Color background;
  final Widget text;

  const Css15({
    Key? key,
    required this.background,
    required this.text,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);

    TextStyle? textHeading = theme.textTheme.labelSmall?.copyWith(fontSize: 10, fontWeight: FontWeight.w700);

    return IntrinsicWidth(
      child: Column(
        children: [
          Container(
            color: Colors.black,
            padding: EdgeInsets.symmetric(vertical: 4, horizontal: 6),
            alignment: Alignment.center,
            child: Text(
              "Halloween",
              style: textHeading?.copyWith(color: Colors.white),
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
            alignment: Alignment.center,
            color: background,
            child: text,
          ),
        ],
      ),
    );
  }
}
