import "package:flutter/material.dart";

import "spacing.dart";

import "../convert_data.dart";

class YithBadgeModel {
  final String type;

  final String text;
  final Color background;
  final Color color;
  final YithBadgeSizeModel size;
  final YithBadgePaddingModel padding;
  final YithBadgeRadiusModel radius;
  final String image;
  final String imageUrl;
  final double uploadedImageWidth;
  final String css;
  final String advanced;
  final String advancedDisplay;
  final double opacity;
  final YithBadgeRotationModel rotation;
  final bool isFlipText;
  final String flipText;
  final String positionType;
  final String anchorPoint;
  final YithBadgePaddingModel positionValues;
  final String position;
  final String alignment;
  final YithBadgePaddingModel margin;
  final double scaleMobile;

  YithBadgeModel({
    required this.type,
    required this.text,
    required this.background,
    required this.color,
    required this.size,
    required this.padding,
    required this.radius,
    required this.image,
    required this.imageUrl,
    required this.uploadedImageWidth,
    required this.css,
    required this.advanced,
    required this.advancedDisplay,
    required this.opacity,
    required this.rotation,
    required this.isFlipText,
    required this.flipText,
    required this.positionType,
    required this.anchorPoint,
    required this.positionValues,
    required this.position,
    required this.alignment,
    required this.margin,
    required this.scaleMobile,
  });

  factory YithBadgeModel.fromJson(Map<String, dynamic> json) {
    Map<String, dynamic> newJson = {
      "type": json["type"] is String ? json["type"] : "text",
      "text": json["text"] is String ? json["text"] : "",
      "background_color": ConvertData.fromHex(json["background_color"] is String ? json["background_color"] : "#2470FF", Color(0xFF2470FF)),
      "text_color": ConvertData.fromHex(json["text_color"] is String ? json["text_color"] : "", Colors.white),
      "size": YithBadgeSizeModel.fromJson((json["size"] is Map ? json["size"]: {}).cast<String, dynamic>()),
      "padding": YithBadgePaddingModel.fromJson((json["padding"] is Map ? json["padding"]: {}).cast<String, dynamic>()),
      "border_radius": YithBadgeRadiusModel.fromJson((json["border_radius"] is Map ? json["border_radius"]: {}).cast<String, dynamic>()),
      "image": json["image"] is String ? json["image"] : "",
      "image_url": json["image_url"] is String ? json["image_url"] : "",
      "uploaded_image_width": ConvertData.stringToDouble(json["uploaded_image_width"]),
      "css": json["css"] is String ? json["css"] : "",
      "advanced": json["advanced"] is String ? json["advanced"] : "",
      "advanced_display": json["advanced_display"] is String ? json["advanced_display"] : "amount",
      "opacity": ConvertData.stringToDouble(json["opacity"], 100),
      "rotation": YithBadgeRotationModel.fromJson((json["rotation"] is Map ? json["rotation"]: {}).cast<String, dynamic>()),
      "use_flip_text": ConvertData.toBoolValue(json["use_flip_text"]) ?? false,
      "flip_text": json["flip_text"] is String ? json["flip_text"] : "vertical",
      "position_type": json["position_type"] is String ? json["position_type"] : "fixed",
      "anchor_point": json["anchor_point"] is String ? json["anchor_point"] : "top-left",
      "position_values": YithBadgePaddingModel.fromJson((json["position_values"] is Map ? json["position_values"]: {}).cast<String, dynamic>()),
      "position": json["position"] is String ? json["position"] : "top",
      "alignment": json["alignment"] is String ? json["alignment"] : "left",
      "margin": YithBadgePaddingModel.fromJson((json["margin"] is Map ? json["margin"]: {}).cast<String, dynamic>()),
      "scale_on_mobile": ConvertData.stringToDouble(json["scale_on_mobile"], 1),
    };
    return _$YithBadgeModelFromJson(newJson);
  }

  Map<String, dynamic> toJson() => _$YithBadgeModelToJson(this);
}

YithBadgeModel _$YithBadgeModelFromJson(Map<String, dynamic> json) => YithBadgeModel(
  type: json["type"] as String,
  text: json["text"] as String,
  background: json["background_color"] as Color,
  color: json["text_color"] as Color,
  size: json["size"] as YithBadgeSizeModel,
  padding: json["padding"] as YithBadgePaddingModel,
  radius: json["border_radius"] as YithBadgeRadiusModel,
  image: json["image"] as String,
  imageUrl: json["image_url"] as String,
  uploadedImageWidth: json["uploaded_image_width"] as double,
  css: json["css"] as String,
  advanced: json["advanced"] as String,
  advancedDisplay: json["advanced_display"] as String,
  opacity: json["opacity"] as double,
  rotation: json["rotation"] as YithBadgeRotationModel,
  isFlipText: json["use_flip_text"] as bool,
  flipText: json["flip_text"] as String,
  positionType: json["position_type"] as String,
  anchorPoint: json["anchor_point"] as String,
  positionValues: json["position_values"] as YithBadgePaddingModel,
  position: json["position"] as String,
  alignment: json["alignment"] as String,
  margin: json["margin"] as YithBadgePaddingModel,
  scaleMobile: json["scale_on_mobile"] as double,
);

Map<String, dynamic> _$YithBadgeModelToJson(YithBadgeModel instance) => <String, dynamic>{
  "type": instance.type,
  "text": instance.text,
  "background_color": ConvertData.fromColor(instance.background),
  "text_color": ConvertData.fromColor(instance.color),
  "size": instance.size.toJson(),
  "padding": instance.padding.toJson(),
  "border_radius": instance.radius.toJson(),
  "image": instance.image,
  "image_url": instance.imageUrl,
  "uploaded_image_width": instance.uploadedImageWidth,
  "css": instance.css,
  "advanced": instance.advanced,
  "advanced_display": instance.advancedDisplay,
  "opacity": instance.opacity,
  "rotation": instance.rotation.toJson(),
  "use_flip_text": instance.isFlipText,
  "flip_text": instance.flipText,
  "position_type": instance.positionType,
  "anchor_point": instance.anchorPoint,
  "position_values": instance.positionValues.toJson(),
  "position": instance.position,
  "fixed_alignment": instance.alignment,
  "margin": instance.margin.toJson(),
  "scale_on_mobile": instance.scaleMobile,
};