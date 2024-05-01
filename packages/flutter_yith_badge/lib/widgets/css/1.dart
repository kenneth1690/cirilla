import 'package:flutter/material.dart';

class Css1 extends StatelessWidget {
  final Color background;
  final Widget text;

  const Css1({
    Key? key,
    required this.background,
    required this.text,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: background,
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      child: text,
    );
  }
}