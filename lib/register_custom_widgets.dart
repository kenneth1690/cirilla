import 'package:cirilla/types/types.dart';
import 'package:flutter/material.dart';

/// Import other custom widgets here

/// Register custom widgets
///
/// [key] is the key of the custom widget
/// [data] is the data of the custom widget
/// [translate] is translate of the custom widget
/// [baseUrl] is url of the custom widget
///
/// Return a widget or null
Widget? registerCustomWidgets(String key, dynamic data, TranslateType translate, String baseUrl) {
  /// Return a widget here
  if (key == 'placeholder') {
    return const Placeholder();
  }
  /// Return more custom widgets here

  return null;
}