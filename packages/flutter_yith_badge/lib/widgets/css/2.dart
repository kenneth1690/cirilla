import 'dart:math' as math;
import 'package:flutter/material.dart';

class Css2 extends StatelessWidget {
  final Color background;
  final Widget text;

  const Css2({
    Key? key,
    required this.background,
    required this.text,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      fit: StackFit.passthrough,
      children: [
        Container(
          width: 65,
          height: 65,
          child: Container(
            decoration: BoxDecoration(
              border: Border(
                right: BorderSide(width: 65, color: background),
                bottom: BorderSide(width: 65, color: Colors.transparent),
              ),
            ),
          ),
        ),
        Positioned(
          top: -19,
          left: 9,
          child: Transform.rotate(
            angle: math.pi / 4, // Convert degrees to radians
            alignment: FractionalOffset.centerLeft, // Center of the widget
            child: Container(
              width: 91,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [text],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
