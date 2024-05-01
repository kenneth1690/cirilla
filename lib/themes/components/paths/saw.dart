import 'package:flutter/material.dart';

const _sizeDot = 8.0;
const _pad = 3;

class SawPath extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    const sizeDotPad = _sizeDot + _pad;
    double height = 0;
    int n = size.height ~/ sizeDotPad;

    Path path = Path();
    path.moveTo(0, 0);
    for (int i = 0; i < n; i++) {
      path.lineTo(0, height + _pad);
      path.arcToPoint(Offset(0, height + sizeDotPad), radius: const Radius.circular(_sizeDot / 2));
      height = height + sizeDotPad;
    }
    path
      ..lineTo(0, size.height)
      ..lineTo(size.width - _sizeDot, size.height)
      ..arcToPoint(
        Offset(size.width, size.height - _sizeDot),
        radius: const Radius.circular(_sizeDot),
        clockwise: false,
      )
      ..lineTo(size.width, _sizeDot)
      ..arcToPoint(
        Offset(size.width - _sizeDot, 0),
        radius: const Radius.circular(_sizeDot),
        clockwise: false,
      )
      ..close();
    return path;
  }

  @override
  bool shouldReclip(oldClipper) => false;
}
