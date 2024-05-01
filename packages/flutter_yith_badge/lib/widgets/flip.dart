import 'dart:math' as math;
import 'package:flutter/material.dart';

import '../models/spacing.dart';

class FlutterYithFlip extends StatelessWidget {
  final bool isFlip;
  final String type;
  final Widget child;

  const FlutterYithFlip({
    Key? key,
    this.isFlip = false,
    this.type = "vertical",
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (isFlip) {
      switch (type) {
        case "horizontal":
          return Transform(
            transform: Matrix4.identity()..rotateY(math.pi),
            alignment: FractionalOffset.center,
            child: child, // <<< set your widget here
          );
        case "both":
          return Transform(
            transform: Matrix4.identity()
              ..rotateX(math.pi)
              ..rotateY(math.pi),
            alignment: FractionalOffset.center,
            child: child, // <<< set your widget here
          );
        default:
          return Transform(
            transform: Matrix4.identity()..rotateX(math.pi),
            alignment: FractionalOffset.center,
            child: child, // <<< set your widget here
          );
      }
    }

    return child;
  }
}

class FlutterYithRotation extends StatelessWidget {
  final YithBadgeRotationModel rotation;
  final Widget child;

  const FlutterYithRotation({
    Key? key,
    required this.rotation,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (rotation.x != 0 || rotation.y != 0 || rotation.z != 0) {
      return Transform(
        transform: Matrix4.identity()
          ..rotateX((rotation.x * math.pi) / 180)
          ..rotateY((rotation.y * math.pi) / 180)
          ..rotateZ((rotation.z * math.pi) / 180),
        alignment: FractionalOffset.center,
        child: child, // <<< set your widget here
      );
    }

    return child;
  }
}
