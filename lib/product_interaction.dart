import 'package:flutter/material.dart';
import 'package:cirilla/models/models.dart';

/// product interaction
///
/// data is Product?
/// parentData is Product?
/// child is Widget
/// width is double
/// height is double
///
/// Return Widget
Widget productInteraction(
  BuildContext context, {
  required String key,
  Product? data,
  Product? parentData,
  required Widget child,
  required double width,
  required double height,
}) {
  /// Return a widget here
  if (key == 'placeholder') {
    return const Placeholder();
  }

  return child;
}
