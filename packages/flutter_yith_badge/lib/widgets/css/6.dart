import 'package:flutter/material.dart';

class Css6 extends StatelessWidget {
  final Color background;
  final Widget text;

  const Css6({
    Key? key,
    required this.background,
    required this.text,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(vertical: 3),
          child: text,
        ),
        Positioned(
          bottom: -3,
          left: 0,
          right: 0,
          child: Container(height: 3, color: background),
        ),
      ],
    );
  }
}
