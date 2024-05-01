import 'package:flutter/material.dart';

import "../widgets/container.dart";

import "date.dart";
import "number.dart";
import "range.dart";
import "text.dart";

class Inputs extends StatelessWidget {
  final Map<String, dynamic> data;
  final void Function(String key, dynamic value) onChange;
  final Map<String, String> attributes;
  final Map<String, dynamic> user;

  const Inputs({
    Key? key,
    required this.data,
    required this.onChange,
    required this.attributes,
    required this.user,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String type = attributes["type"] ?? "text";
    String nameKey = attributes["name"] ?? "";

    Widget? child;

    if (nameKey.isNotEmpty) {
      dynamic value = data[nameKey] is String ? data[nameKey] : null;
      switch (type) {
        case "text":
        case "email":
        case "url":
        case "tel":
          child = TextFieldWidget(
            value: value is String ? value : null,
            onChange: (newValue) => onChange(nameKey, newValue),
            attributes: attributes,
            type: type,
            user: user,
          );
          break;
        case "date":
          child = DateField(
            value: value is String ? value : null,
            onChange: (newValue) => onChange(nameKey, newValue),
            attributes: attributes,
          );
          break;
        case "number":
          child = NumberField(
            value: value is String ? value : null,
            onChange: (newValue) => onChange(nameKey, newValue),
            attributes: attributes,
          );
          break;
        case "range":
          child = RangeField(
            value: value is String ? value : null,
            onChange: (newValue) => onChange(nameKey, newValue),
            attributes: attributes,
          );
          break;
      }
    }

    if (child != null) {
      return ContainerWidget(
        child: child,
      );
    }

    return SizedBox();
  }
}
