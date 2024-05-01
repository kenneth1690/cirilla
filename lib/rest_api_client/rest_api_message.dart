import 'package:cirilla/utils/conditionals.dart';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:cirilla/mixins/snack_mixin.dart' show showError, showSuccess;
import 'constants.dart';

dynamic _getData(dynamic data) {
  if (data is List || data is Map) {
    return "";
  }
  return "$data";
}

/// Get data
Map<String, String?> _convertData(String parent, dynamic data) {
  Map<String, String?> result = {};
  if (data is Map) {
    for (var key in data.keys.toList()) {
      if (data[key] is Map || data[key] is List) {
        result.addAll(_convertData("$parent.$key", data[key]));
      } else {
        result.addAll({
          "$parent.$key": "${data[key]}",
        });
      }
    }
  }
  if (data is List) {
    for (var i = 0; i < data.length; i++) {
      if (data[i] is Map || data[i] is List) {
        result.addAll(_convertData("$parent.$i", data[i]));
      } else {
        result.addAll({
          "$parent.$i": "${data[i]}"
        });
      }
    }
  }
  return result;
}

/// Get variable
dynamic _getVariables(String key, Map<String, dynamic> data) {
  if (data.containsKey(key)) {
    return data[key];
  }

  return "";
}

void restIpiShowMessage(BuildContext context, Response data, List messages) {
  if (messages.isNotEmpty) {
    Map<String, String?> dataVariable = {
      "statusCode": "${data.statusCode}",
      "data": _getData(data),
      ..._convertData("data", data.data),
    };
    List<String> variableKeys = dataVariable.keys.toList();

    for(var message in messages) {
      if(message is Map) {
        String typeMessage = message["typeMessage"] is String ? message["typeMessage"] :  "success";
        String textMessage = message["message"] is String ? message["message"]  :"success";
        List conditional = message["conditional"] is List ? message["conditional"]  : [];

        if (conditional.isEmpty) {
          _showMessage(context, typeMessage, textMessage, dataVariable);
          break;
        }

        bool check = conditionalCheck(
          "show_if",
          conditional,
          variableKeys,
          (String key) => _getVariables(key, dataVariable),
        );

        if (check) {
          _showMessage(context, typeMessage, textMessage, dataVariable);
          break;
        }
      }
    }
  }
}

void _showMessage(BuildContext context, String type, String text, Map<String, String?> data) {
  String contentText = text;

  if (expText.hasMatch(contentText)) {
    contentText = replaceText(contentText, expText, data);
  }

  if (type == "error") {
    showError(context, contentText);
  } else {
    showSuccess(context, contentText);
  }
}
