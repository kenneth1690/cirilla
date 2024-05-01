import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_html_form/convert.dart';

import 'option_data.dart';

class RadioModel {
  final String name;
  final OptionDataModel option;
  final bool required;
  final bool labelFirst;

  RadioModel({
    required this.name,
    required this.option,
    required this.required,
    required this.labelFirst,
  });
}

RadioModel convertRadioModelFromRenderContext(RenderContext context) {
  Map<String, String> attributes = context.tree.attributes;
  List<StyledElement> children = context.tree.children;

  String name = attributes["data-name"] ?? "";
  bool labelFirst = convertToBool(attributes["data-labelfirst"]) ?? false;
  bool requiredField = convertToBool(attributes["data-required"]) ?? false;
  return RadioModel(name: name, option: _getOption(children, name), required: requiredField, labelFirst: labelFirst);
}

OptionDataModel _getOption(List<StyledElement> children, String name) {
  List<String> options = [];
  List<String> images = [];
  int? defaultValue = null;

  var i = 1;
  for(var child in children) {
    if (child.name == "input") {
      Map<String, String> attributes = child.attributes;
      if (attributes["type"] == "radio" || attributes["name"] == name) {
        String value = attributes["value"] ?? "";
        options.add(value);
        if (attributes.keys.toList().contains("src")) {
          images.add(attributes["src"] ?? "");
        }
        if ((convertToBool(attributes["checked"]) ?? false) && defaultValue == null) {
          defaultValue = i;
        }
        i ++;
      }
    }

  }
  return OptionDataModel(options: options, imageOptions: images.isNotEmpty ? images : null, defaultValues: defaultValue != null ? [defaultValue]: []);
}