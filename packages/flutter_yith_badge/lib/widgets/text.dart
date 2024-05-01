import 'package:flutter/material.dart';
import 'package:flutter_yith_badge/convert_data.dart';

import 'package:flutter_yith_badge/models/model.dart';

import 'flip.dart';
import 'html.dart';

class FlutterYithBadgeText extends StatelessWidget {
  final YithBadgeModel config;
  final double widthParent;

  const FlutterYithBadgeText({
    Key? key,
    required this.config,
    required this.widthParent,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = config.size.dimensions;

    return Container(
      width: size.width,
      height: size.height,
      decoration: BoxDecoration(
          color: config.background,
          borderRadius: ConvertData.radiusToBorderRadius(config.radius, size.width, size.height)
      ),
      alignment: Alignment.center,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: double.infinity,
            child: Padding(
                padding: ConvertData.spacingToEdgeInsets(config.padding, widthParent),
                child: FlutterYithFlip(
                  isFlip: config.isFlipText,
                  type: config.flipText,
                  child: TextHtml(html: config.text, shrinkWrap: false),
                )
            ),
          ),
        ],
      ),
    );
  }
}
