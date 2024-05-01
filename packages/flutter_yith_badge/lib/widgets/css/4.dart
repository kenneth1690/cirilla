import 'dart:math' as math;
import 'package:flutter/material.dart';

class Css4 extends StatelessWidget {
  final Color background;
  final Widget text;

  const Css4({
    Key? key,
    required this.background,
    required this.text,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      alignment: Alignment.center,
      children: [
        Positioned(
          left: 0,
          right: 0,
          child: Center(
            child: LayoutBuilder(
              builder: (context, constraints) {
                double size = constraints.maxWidth;
                double sizeSquare = size / math.sqrt(2);
                return Transform(
                  transform: Matrix4.identity()..rotateZ(math.pi / 4),
                  alignment: FractionalOffset.center,
                  child: Container(
                    width: sizeSquare,
                    height: sizeSquare,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(sizeSquare * 0.05),
                      color: background,
                    ),
                  ),
                );
              },
            ),
          ),
        ),
        Container(padding: EdgeInsets.all(15), child: text),
      ],
    );
  }
}
