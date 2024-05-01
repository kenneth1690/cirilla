import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_html_form/convert.dart';

import 'option_data.dart';

class SelectModel {
  final String name;
  final OptionDataModel option;
  final bool required;
  final bool includeBlank;
  final bool multiple;

  SelectModel({
    required this.name,
    required this.option,
    required this.required,
    required this.includeBlank,
    required this.multiple,
  });
}

SelectModel convertSelectModelFromRenderContext(RenderContext context) {
  Map<String, String> attributes = context.tree.attributes;
  List<StyledElement> children = context.tree.children;

  String name = attributes["name"] ?? "";
  bool multiple = convertToBool(attributes["multiple"]) ?? false;
  bool requiredField = convertToBool(attributes["required"]) ?? false;
  bool includeBlank = convertToBool(attributes["data-includeblank"]) ?? false;
  return SelectModel(name: name, option: _getOption(children, name), required: requiredField, multiple: multiple, includeBlank: includeBlank);
}

OptionDataModel _getOption(List<StyledElement> children, String name) {
  List<String> options = [];
  List<int> defaultValues = [];

  var i = 1;
  for(var child in children) {
    if (child.name == "option") {
      Map<String, String> attributes = child.attributes;
      String value = attributes["value"] ?? "";
      bool selected = convertToBool(attributes["selected"]) ?? false;

      options.add(value);
      if (selected) {
        defaultValues.add(i);
      }
      i++;
    }

  }
  return OptionDataModel(options: options, defaultValues: defaultValues);
}