import 'package:flutter/material.dart';

import 'package:flutter_yith_badge/models/model.dart';

import 'item_image.dart';

class FlutterYithBadgeImage extends StatelessWidget {
  final YithBadgeModel config;
  final double widthParent;
  final double heightParent;

  const FlutterYithBadgeImage({
    Key? key,
    required this.config,
    required this.widthParent,
    required this.heightParent,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String image = config.imageUrl;
    String url = image.isNotEmpty && !image.startsWith("https:") ? "https:${image}": image;
    double? width = config.image == "upload" && config.uploadedImageWidth > 0 ? config.uploadedImageWidth : null;

    return Container(
      constraints: BoxConstraints(
        maxWidth: widthParent,
        maxHeight: heightParent,
      ),
      child: ItemImage(url, width: width),
    );
  }
}
