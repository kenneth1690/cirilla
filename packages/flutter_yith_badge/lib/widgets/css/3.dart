import 'package:flutter/material.dart';

class Css3 extends StatelessWidget {
  final Color background;
  final Widget text;

  const Css3({
    Key? key,
    required this.background,
    required this.text,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 6, vertical: 10),
      decoration: BoxDecoration(
        color: background,
        border: Border.all(width: 2, color:Colors.red),
        borderRadius: BorderRadius.circular(7),
      ),
      child: text,
    );
  }
}
