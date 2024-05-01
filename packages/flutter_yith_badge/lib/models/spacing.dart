import "package:flutter/material.dart";

import "../convert_data.dart";

class YithBadgeSizeModel {
  final Size dimensions;
  final bool linked;
  final String unit;

  YithBadgeSizeModel({
    required this.dimensions,
    required this.linked,
    required this.unit,
  });

  factory YithBadgeSizeModel.fromJson(Map<String, dynamic> json) {
    Map<String, dynamic> newJson = {
      "dimensions": ConvertData.toSize(json["dimensions"], Size(150, 50)),
      "linked": ConvertData.toBoolValue(json["linked"]) ?? false,
      "unit": json["unit"] == "%" ? "%" : "px",
    };
    return _$YithBadgeSizeModelFromJson(newJson);
  }

  Map<String, dynamic> toJson() => _$YithBadgeSizeModelToJson(this);
}

class YithBadgePaddingModel {
  final double left;
  final double right;
  final double top;
  final double bottom;
  final bool linked;
  final String unit;


  YithBadgePaddingModel({
    required this.left,
    required this.right,
    required this.top,
    required this.bottom,
    required this.linked,
    required this.unit,
  });

  factory YithBadgePaddingModel.fromJson(Map<String, dynamic> json) {
    Map<String, dynamic> dimensions = (json["dimensions"] is Map ? json["dimensions"] : {}).cast<String, dynamic>();
    Map<String, dynamic> newJson = {
      "left": ConvertData.stringToDouble(dimensions["left"]),
      "right": ConvertData.stringToDouble(dimensions["right"]),
      "top": ConvertData.stringToDouble(dimensions["top"]),
      "bottom": ConvertData.stringToDouble(dimensions["bottom"]),
      "linked": ConvertData.toBoolValue(json["linked"]) ?? false,
      "unit": json["unit"] == "%" ? "%" : "px",
    };
    return _$YithBadgePaddingModelFromJson(newJson);
  }

  Map<String, dynamic> toJson() => _$YithBadgePaddingModelToJson(this);
}

class YithBadgeRadiusModel {
  final double topLeft;
  final double topRight;
  final double bottomLeft;
  final double bottomRight;
  final bool linked;
  final String unit;

  YithBadgeRadiusModel({
    required this.topLeft,
    required this.topRight,
    required this.bottomLeft,
    required this.bottomRight,
    required this.linked,
    required this.unit,
  });

  factory YithBadgeRadiusModel.fromJson(Map<String, dynamic> json) {
    Map<String, dynamic> dimensions = (json["dimensions"] is Map ? json["dimensions"] : {}).cast<String, dynamic>();

    Map<String, dynamic> newJson = {
      "top-left": ConvertData.stringToDouble(dimensions["top-left"]),
      "top-right": ConvertData.stringToDouble(dimensions["top-right"]),
      "bottom-left": ConvertData.stringToDouble(dimensions["bottom-left"]),
      "bottom-right": ConvertData.stringToDouble(dimensions["bottom-right"]),
      "linked": ConvertData.toBoolValue(json["linked"]) ?? false,
      "unit": json["unit"] == "%" ? "%" : "px",
    };
    return _$YithBadgeRadiusModelFromJson(newJson);
  }

  Map<String, dynamic> toJson() => _$YithBadgeRadiusModelToJson(this);
}

class YithBadgeRotationModel {
  final double x;
  final double y;
  final double z;

  YithBadgeRotationModel({
    required this.x,
    required this.y,
    required this.z,
  });

  factory YithBadgeRotationModel.fromJson(Map<String, dynamic> json) {
    Map<String, dynamic> newJson = {
      "x": ConvertData.stringToDouble(json["x"]),
      "y": ConvertData.stringToDouble(json["y"]),
      "z": ConvertData.stringToDouble(json["z"]),
    };
    return _$YithBadgeRotationModelFromJson(newJson);
  }

  Map<String, dynamic> toJson() => _$YithBadgeRotationModelToJson(this);
}

YithBadgeSizeModel _$YithBadgeSizeModelFromJson(Map<String, dynamic> json) => YithBadgeSizeModel(
  dimensions: json["dimensions"] as Size,
  linked: json["linked"] as bool,
  unit: json["unit"] as String,
);

Map<String, dynamic> _$YithBadgeSizeModelToJson(YithBadgeSizeModel instance) => <String, dynamic>{
  "dimensions": ConvertData.fromSize(instance.dimensions),
  "linked": instance.linked ? "yes" : "no",
  "unit": instance.unit,
};

YithBadgePaddingModel _$YithBadgePaddingModelFromJson(Map<String, dynamic> json) => YithBadgePaddingModel(
      left: json["left"] as double,
      right: json["right"] as double,
      top: json["top"] as double,
      bottom: json["bottom"] as double,
      linked: json["linked"] as bool,
      unit: json["unit"] as String,
    );

Map<String, dynamic> _$YithBadgePaddingModelToJson(YithBadgePaddingModel instance) => <String, dynamic> {
  "dimensions": {
    "top": instance.top,
    "right": instance.right,
    "bottom": instance.bottom,
    "left": instance.left
  },
  "linked": instance.linked ? "yes" : "no",
  "unit": instance.unit
};

YithBadgeRadiusModel _$YithBadgeRadiusModelFromJson(Map<String, dynamic> json) => YithBadgeRadiusModel(
      topLeft: json["top-left"] as double,
      topRight: json["top-right"] as double,
      bottomLeft: json["bottom-left"] as double,
      bottomRight: json["bottom-right"] as double,
      linked: json["linked"] as bool,
      unit: json["unit"] as String,
    );

Map<String, dynamic> _$YithBadgeRadiusModelToJson(YithBadgeRadiusModel instance) => <String, dynamic>{
  "dimensions": {
    "top-left": instance.topLeft,
    "top-right": instance.topRight,
    "bottom-left": instance.bottomLeft,
    "bottom-right": instance.bottomRight,
  },
  "linked": instance.linked ? "yes" : "no",
  "unit": instance.unit
};

YithBadgeRotationModel _$YithBadgeRotationModelFromJson(Map<String, dynamic> json) => YithBadgeRotationModel(
      x: json["x"] as double,
      y: json["y"] as double,
      z: json["z"] as double,
    );

Map<String, dynamic> _$YithBadgeRotationModelToJson(YithBadgeRotationModel instance) => <String, dynamic>{
      "x": instance.x,
      "y": instance.y,
      "z": instance.x,
    };


