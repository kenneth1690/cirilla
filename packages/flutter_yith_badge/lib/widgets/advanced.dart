import 'package:flutter/material.dart';

import 'package:flutter_yith_badge/models/model.dart';
import '../models/advanced.dart';
import 'advanced/3.dart';

class FlutterYithBadgeAdvanced extends StatelessWidget {
  final YithBadgeModel config;
  final double widthParent;
  final double heightParent;
  final YithBadgeAdvancedValueModel data;

  const FlutterYithBadgeAdvanced({
    Key? key,
    required this.config,
    required this.widthParent,
    required this.heightParent,
    required this.data,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {

    String text = data.getString(config.advancedDisplay);

    switch(config.advanced) {
      case "3.svg": {
        return Advanced3(
          background: config.background,
          textColor: config.color,
          text: text,
        );
      }
      default:
        return Container();
    }
  }
}
