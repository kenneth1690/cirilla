import 'dart:math' as math;
import 'package:flutter/material.dart';

class _ViewBackground extends StatelessWidget {
  final Color color;
  final double width;
  final double height;

  const _ViewBackground({
    Key? key,
    required this.color,
    required this.width,
    required this.height,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Transform(
      transform: Matrix4.skewX(-10 * (math.pi / 180)), // Convert degrees to radians
      alignment: Alignment.center,
      child: Container(
        color: color,
        width: width,
        height: height,
      ),
    );
  }
}

class Css9 extends StatelessWidget {
  final Color background;
  final Widget text;

  const Css9({
    Key? key,
    required this.background,
    required this.text,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      alignment: Alignment.bottomCenter,
      children: [
        Positioned(
          left: 0,
          right: 0,
          top: 0,
          bottom: 0,
          child: LayoutBuilder(
            builder: (context, constraints) {
              double width = constraints.maxWidth;
              double height = constraints.maxHeight;
              return Stack(
                clipBehavior: Clip.none,
                children: [
                  Positioned(
                    bottom: height * - 0.07,
                    left: width * - 0.03,
                    child: _ViewBackground(
                      width: width,
                      height: height,
                      color: background.withOpacity(0.5),
                    ),
                  ),
                  Positioned(
                    bottom: height * - 0.14,
                    left: width * - 0.06,
                    child: _ViewBackground(
                      width: width,
                      height: height,
                      color: background.withOpacity(0.25),
                    ),
                  ),
                  _ViewBackground(
                    width: width,
                    height: height,
                    color: background,
                  ),
                ],
              );
            },
          ),
        ),
        Container(padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10), child: text),
      ],
    );
  }
}
