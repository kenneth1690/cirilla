
import 'package:flutter/material.dart';

import 'models/spacing.dart';

class ConvertData {
  static double stringToDouble(dynamic value, [double defaultValue = 0]) {
    if (value == null || value == "") {
      return defaultValue;
    }
    if (value is int) {
      return value.toDouble();
    }
    if (value is double) {
      return value;
    }

    if (value is String) {
      return double.tryParse(value) ?? defaultValue;
    }

    return defaultValue;
  }


  static Color? fromHex(String hex, [defaultColor = Colors.white]) {
    if (!RegExp(r'^#+([a-fA-F0-9]{6}|[a-fA-F0-9]{5}|[a-fA-F0-9]{3})$').hasMatch(hex)) {
      return defaultColor;
    }
    String color = hex.replaceAll('#', '');
    String value = color.length == 6 ? color : '';
    if (value.length != 6) {
      if (color.length == 3) {
        for (int i = 0; i < color.length; i++) {
          value = '$value${color[i]}${color[i]}';
        }
      } else if (color.length == 5) {
        value = '${color.substring(0, 4)}0${color[4]}';
      }
    }
    return Color(int.parse('0xff$value'));
  }

  static String fromColor(Color color) {
    String hex = color.value.toRadixString(16);

    return '#${hex.substring(2)}';
  }

  static Size toSize(dynamic value, [Size defaultValue = Size.zero]) {
    if (value is Map) {
      double width = stringToDouble(value["width"], defaultValue.width);
      double height = stringToDouble(value["height"], defaultValue.height);
      return Size(width, height);
    }

    return defaultValue;
  }

  static Map<String, dynamic> fromSize(Size value) {
    return {
      "width": value.width,
      "height": value.height,
    };
  }

  static bool? toBoolValue(dynamic value) {
    if (value is bool) {
      return value;
    }

    if (value == "true" || value == 1 || value == "1" || value == "yes") {
      return true;
    }

    if (value == "false" || value == 0 || value == "0" || value == "no") {
      return false;
    }
    return null;
  }

  static EdgeInsets spacingToEdgeInsets(YithBadgePaddingModel value, double width) {
    double left = value.left > 0 ? value.left : 0;
    double right = value.right > 0 ? value.right : 0;
    double top = value.top > 0 ? value.top : 0;
    double bottom = value.bottom > 0 ? value.bottom : 0;

    switch(value.unit) {
      case "%":
        return EdgeInsets.only(
          left: (width * left)/100,
          right: (width * right)/100,
          top: (width * top)/100,
          bottom: (width * bottom)/100,
        );
      default:
        return EdgeInsets.only(
          left: left,
          right: right,
          top: top,
          bottom: bottom,
        );
    }
  }

  static BorderRadius radiusToBorderRadius(YithBadgeRadiusModel value, double width, double height) {
    double topLeft = value.topLeft > 0 ? value.topLeft : 0;
    double topRight = value.topRight > 0 ? value.topRight : 0;
    double bottomLeft = value.bottomLeft > 0 ? value.bottomLeft : 0;
    double bottomRight = value.bottomRight > 0 ? value.bottomRight : 0;

    switch(value.unit) {
      case "%":
        return BorderRadius.only(
          topLeft: Radius.elliptical((width * topLeft) / 100, (height * topLeft) / 100),
          topRight: Radius.elliptical((width * topRight) / 100, (height * topRight) / 100),
          bottomLeft: Radius.elliptical((width * bottomLeft) / 100, (height * bottomLeft) / 100),
          bottomRight: Radius.elliptical((width * bottomRight) / 100, (height * bottomRight) / 100),
        );
      default:
        return BorderRadius.only(
          topLeft: Radius.circular(topLeft),
          topRight: Radius.circular(topRight),
          bottomLeft: Radius.circular(bottomLeft),
          bottomRight: Radius.circular(bottomRight),
        );
    }
  }

  static Color darkenColor(Color color, [double factor = 0.4]) {
    int red = (color.red * (1.0 - factor)).round();
    int green = (color.green * (1.0 - factor)).round();
    int blue = (color.blue * (1.0 - factor)).round();
    return Color.fromRGBO(red, green, blue, 1);
  }
}
