import 'package:flutter/material.dart';

class _ViewCircle extends StatelessWidget {
  final Color color;
  final double size;

  const _ViewCircle({
    Key? key,
    required this.color,
    required this.size,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(color: color, shape: BoxShape.circle),
    );
  }
}

class Css10 extends StatelessWidget {
  final Color background;
  final Widget text;

  const Css10({
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
          child: LayoutBuilder(
            builder: (context, constraints) {
              double size = constraints.maxWidth;
              double sizeView = size * 0.9;

              return Stack(
                clipBehavior: Clip.none,
                children: [
                  Positioned(
                    top: 0,
                    left: -size * 0.15,
                    child: _ViewCircle(
                      color: background.withOpacity(0.25),
                      size: sizeView,
                    ),
                  ),
                  Positioned(
                    top: 0,
                    left: -size * 0.05,
                    child: _ViewCircle(
                      color: background.withOpacity(0.5),
                      size: sizeView,
                    ),
                  ),
                  Center(
                    child: _ViewCircle(
                      color: background,
                      size: sizeView,
                    ),
                  )
                ],
              );
            },
          ),
        ),
        Container(padding: EdgeInsets.all(15), child: text),
      ],
    );
  }
}
