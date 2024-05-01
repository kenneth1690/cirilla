import 'package:flutter/material.dart';

import 'models/advanced.dart';
import 'models/model.dart';

import 'widgets/flip.dart';
import 'widgets/advanced.dart';
import 'widgets/css.dart';
import 'widgets/image.dart';
import 'widgets/text.dart';

class FlutterYithBadgeItem extends StatelessWidget {
  final YithBadgeModel config;
  final double widthParent;
  final double heightParent;
  final YithBadgeAdvancedValueModel data;

  const FlutterYithBadgeItem({
    Key? key,
    required this.config,
    required this.widthParent,
    required this.heightParent,
    required this.data,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    late Widget child;
    switch (config.type) {
      case "image":
        child = FlutterYithBadgeImage(config: config, widthParent: widthParent, heightParent: widthParent);
        break;
      case "css":
        child = FlutterYithBadgeCss(config: config, widthParent: widthParent, heightParent: widthParent);
        break;
      case "advanced":
        child = FlutterYithBadgeAdvanced(config: config, widthParent: widthParent, heightParent: widthParent, data: data);
        break;
      default:
        child = FlutterYithBadgeText(config: config, widthParent: widthParent);
    }

    return FlutterYithRotation(
      rotation: config.rotation,
      child: Opacity(opacity: config.opacity / 100, child: child),
    );
  }
}
