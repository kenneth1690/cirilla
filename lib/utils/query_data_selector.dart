import 'package:cirilla/utils/utils.dart';
import 'package:collection/collection.dart';
import 'package:cirilla/mixins/utility_mixin.dart';
import 'package:flutter/material.dart';

import 'conditionals.dart';

/// This helper function to check data query have values to show
///
/// The [query] argument for data query
/// The [languageKey] argument for multi language's key
///
/// Return is a boolean.
///
bool checkExistQuery(dynamic query, String languageKey) {
  String type = get(query, ["type"], "text");
  String text = _getText(query, "text", languageKey, "{data}");
  String defaultText = _getText(query, "defaultText", languageKey, "");
  bool enableTextEmpty = get(query, ["enableTextEmpty"], true);
  List methods = get(query, ["methods"], []);

  return methods.isNotEmpty &&
      ((!enableTextEmpty && defaultText != "") || (type == "image" || (type == "text" && text != "")));
}

/// This helper function to get text from data by query
///
/// The [context] argument for [BuildContext]
/// The [data] argument for data to query
/// The [query] argument for data query
/// The [languageKey] argument for multi language's key
///
/// Return is string or null.
///
String? getStringQuery(BuildContext context, dynamic data, dynamic query, String languageKey) {
  String type = get(query, ["type"], "text");
  String text = _getText(query, "text", languageKey, "{data}");
  String defaultText = _getText(query, "defaultText", languageKey, "");
  bool enableTextEmpty = get(query, ["enableTextEmpty"], true);
  List methods = get(query, ["methods"], []);

  dynamic temporaryValue = data;
  if (methods.isNotEmpty) {
    for (var i = 0; i < methods.length; i++) {
      temporaryValue = _getDataWithMethod(temporaryValue, methods[i]);
    }
  }

  String? value = _getString(temporaryValue);

  if (!enableTextEmpty && value?.isNotEmpty != true) {
    return defaultText.isNotEmpty ? defaultText : null;
  }

  if (type == "image") {
    return _getString(temporaryValue);
  }

  if (value != null) {
    return TextDynamic.getTextDynamic(context, text: text, options: {"data": value});
  }
  return null;
}

/// This helper function to get text of query
///
/// The [query] argument for data query
/// The [languageKey] argument for multi language's key
///
/// Return is string.
///
String _getText(dynamic query, String key, String languageKey, String defaultValue) {
  dynamic text = get(query, [key]);
  if (text is String) {
    return text;
  }
  return get(text, [languageKey], defaultValue);
}

/// This helper function to convert basic value(return is string with types: string, int, double or bool ) to string
///
/// The [value] argument for value
///
/// Return is string or null.
///
String? _getString(dynamic value) {
  if (value is String) {
    return value;
  }

  if (value is int || value is double || value is bool) {
    return value.toString();
  }
  return null;
}

/// This helper function to convert to data
///
/// The [value] argument for value
///
/// Return is dynamic.
///
dynamic _getData(dynamic value) {
  if (_getString(value) != null) {
    return _getString(value);
  }
  if (value is List) {
    return value.map((e) => e.toString()).toList().cast<String>();
  }
  return value;
}

/// This helper function to get value from method
///
/// The [value] argument for value
/// The [method] argument for method
///
/// Return is dynamic.
///
dynamic _getDataWithMethod(dynamic value, dynamic method) {
  String methodItem = get(method, ["method"], "");
  String fieldItem = get(method, ["field"], "");
  String operatorItem = get(method, ["operator"], "is_equal_to");
  String valueItem = get(method, ["value"], "");
  String value1Item = get(method, ["value1"], "");
  String value2Item = get(method, ["value2"], "");

  switch (methodItem) {
    /// Width value is List
    case "list_map":
      return _getValueWithListMapMethod(value, fieldItem);
    case "list_filter":
      return _getValueWithListWhereMethod(value, fieldItem, operatorItem, valueItem);
    case "list_get":
      return _getValueWithListFirstWhereMethod(value, fieldItem, operatorItem, valueItem);
    case "list_getByIndex":
      return _getValueWithListIndexMethod(value, fieldItem);
    case "list_index":
      return _getValueWithListGetIndexMethod(value, fieldItem, operatorItem, valueItem);
    case "list_join":
      return _getValueWithListJoinMethod(value, valueItem);

    /// Width value is Map
    case "map_keys":
      return _getValueWithMapKeysMethod(value);
    case "map_values":
      return _getValueWithMapValuesMethod(value);
    case "map_getKey":
      return _getValueWithMapGetMethod(value, fieldItem);

    /// Width value is String
    case "string_replace":
      return _getValueWithStringReplaceMethod(_getString(value), value1Item, value2Item);
    case "string_replaceAll":
      return _getValueWithStringReplaceAllMethod(_getString(value), value1Item, value2Item);
    case "string_split":
      return _getValueWithStringSplitMethod(_getString(value), valueItem);
    default:
      return null;
  }
}

/// This helper function to get a list of method map
///
/// The [data] argument for data
/// The [field] argument for field
///
/// Return is List or null.
///
List? _getValueWithListMapMethod(dynamic data, String field) {
  if (data is List) {
    return data.map((e) => field.isNotEmpty ? get(e, [field]) : e).toList();
  }
  return null;
}

/// This helper function to get a list of method where
///
/// The [data] argument for data
/// The [field] argument for field
/// The [operator] argument for operator
/// The [value] argument for value
///
/// Return is List or null.
///
List? _getValueWithListWhereMethod(dynamic data, String field, String operator, String value) {
  if (data is List) {
    return data.where((e) {
      dynamic dataField = field.isNotEmpty ? get(e, [field]) : e;
      return operators(operator, _getData(dataField), value);
    }).toList();
  }
  return null;
}

/// This helper function to get a data in List of method firstWhere
///
/// The [data] argument for data
/// The [field] argument for field
/// The [operator] argument for operator
/// The [value] argument for value
///
/// Return is dynamic.
///
dynamic _getValueWithListFirstWhereMethod(dynamic data, String field, String operator, String value) {
  if (data is List) {
    return data.firstWhereOrNull((e) {
      dynamic dataField = field.isNotEmpty ? get(e, [field]) : e;
      return operators(operator, _getData(dataField), value);
    });
  }
  return null;
}

/// This helper function to get a data from list by visit
///
/// The [data] argument for data
/// The [field] argument for field. Must string of int and > 0
///
/// Return is dynamic.
///
dynamic _getValueWithListIndexMethod(dynamic data, String field) {
  if (data is List) {
    int visit = ConvertData.stringToInt(field) - 1;
    return visit >= 0 && visit < data.length ? data[visit] : null;
  }
  return null;
}

/// This helper function to get visit in List data
///
/// The [data] argument for data
/// The [field] argument for field
/// The [operator] argument for operator
/// The [value] argument for value
///
/// Return is int or null.
///
int? _getValueWithListGetIndexMethod(dynamic data, String field, String operator, String value) {
  if (data is List) {
    return data.indexWhere((e) {
          dynamic dataField = field.isNotEmpty ? get(e, [field]) : e;
          return operators(operator, _getData(dataField), value);
        }) +
        1;
  }
  return null;
}

/// This helper function to join list to a string
///
/// The [data] argument for data
/// The [value] argument for value
///
/// Return is string or null.
///
String? _getValueWithListJoinMethod(dynamic data, String value) {
  if (data is List) {
    return data.join(value);
  }
  return null;
}

/// This helper function to get list keys of Map
///
/// The [data] argument for data
///
/// Return is List or null.
///
List? _getValueWithMapKeysMethod(dynamic data) {
  if (data is Map) {
    return data.keys.toList();
  }
  return null;
}

/// This helper function to get list values of Map
///
/// The [data] argument for data
///
/// Return is List or null.
///
List? _getValueWithMapValuesMethod(dynamic data) {
  if (data is Map) {
    return data.values.toList();
  }
  return null;
}

/// This helper function to get a value of Map
///
/// The [data] argument for data
/// The [field] argument for field
///
/// Return is dynamic.
///
dynamic _getValueWithMapGetMethod(dynamic data, String field) {
  if (data is Map) {
    return field.isNotEmpty ? data[field] : data;
  }
  return null;
}

/// This helper function to replace in a string
///
/// The [data] argument for data
/// The [from] argument for data from
/// The [to] argument for data to
///
/// Return is string or null.
///
String? _getValueWithStringReplaceMethod(dynamic data, String from, String to) {
  if (data is String) {
    return data.replaceFirst(from, to);
  }
  return null;
}

/// This helper function to replace all in a string
///
/// The [data] argument for data
/// The [from] argument for data from
/// The [to] argument for data to
///
/// Return is string or null.
///
String? _getValueWithStringReplaceAllMethod(dynamic data, String from, String to) {
  if (data is String) {
    return data.replaceAll(from, to);
  }
  return null;
}

/// This helper function to convert string to list
///
/// The [data] argument for data
/// The [value] argument for value
///
/// Return is list or null.
///
List? _getValueWithStringSplitMethod(dynamic data, String value) {
  if (data is String) {
    return data.split(value);
  }
  return null;
}
