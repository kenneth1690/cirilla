import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:cirilla/mixins/utility_mixin.dart';
import 'package:cirilla/utils/form_field_validator.dart';
import 'constants.dart';

/// Get data
dynamic _convertText(String text, Map<String, String?> data, Map<String, String?> dataGlobal) {
  if (expTextForm.hasMatch(text) || expText.hasMatch(text)) {
    String value = text;
    if (expTextForm.hasMatch(text)) {
      value = replaceText(value, expTextForm, data);
    }
    if (expText.hasMatch(text)) {
      value = replaceText(value, expText, dataGlobal);
    }
    return isJSON(value) ? jsonDecode(value) : value;
  }

  return text;
}

/// Get url

String _getUrl(Uri uri) {
  return "https://${uri.host}${uri.path}";
}

Map<String, dynamic> _getQuery(Uri uri, Map<String, String?> data, Map<String, String?> dataGlobal) {
  Map<String, dynamic> query = {};

  Map<String, String> uriQuery = uri.queryParameters;

  for (String key in uriQuery.keys.toList()) {
    String value = uriQuery[key] ?? "";

    query.addAll({
      key: _convertText(value, data, dataGlobal),
    });
  }

  return query;
}

/// Get data header

Map<String, dynamic> _getHeaders(String text, Map<String, String?> data, Map<String, String?> dataGlobal) {
  Map<String, dynamic> result = {};

  dynamic headers = isJSON(text) ? jsonDecode(text) : [];

  if (headers is List && headers.isNotEmpty) {
    for (var h in headers) {
      String key = get(h, ["key"], "");

      String value = get(h, ["value"], "");

      if (key.isNotEmpty) {
        result = {
          ...result,
          key: _convertText(value, data, dataGlobal),
        };
      }
    }
  }

  return result;
}

/// Get data body

Map<String, dynamic> _getBody(String text, Map<String, String?> data, Map<String, String?> dataGlobal) {
  Map<String, dynamic> result = {};

  dynamic body = isJSON(text) ? jsonDecode(text) : [];

  if (body is List && body.isNotEmpty) {
    for (var b in body) {
      String key = get(b, ["key"], "");

      String value = get(b, ["value"], "");

      if (key.isNotEmpty) {
        result = {
          ...result,
          key: _convertText(value, data, dataGlobal),
        };
      }
    }
  }

  return result;
}

Future<Response<dynamic>> restIpiClient({required Map<String, dynamic> args, required Map<String, String?> data, required Map<String, String?> dataGlobal}) {
  final Dio dio = Dio();

  String url = args["url"] ?? "";

  String method = (args["method"] ?? "GET").toUpperCase();

  String typeBody = args["typeBody"] ?? "none";

  String headers = args["headers"] ?? "";

  String body = args["body"] ?? "";

  Uri uri = Uri.parse(url);

  String? defaultContentType = typeBody == "form-data"
      ? Headers.multipartFormDataContentType
      : typeBody == "x-www-form-urlencoded"
      ? Headers.formUrlEncodedContentType
      : null;

  Map<String, dynamic> dataHeaders = _getHeaders(headers, data, dataGlobal);

  Map<String, dynamic> dataBody = _getBody(body, data, dataGlobal);

  Object? formDataBody = typeBody == "form-data" ? FormData.fromMap(dataBody) : dataBody;
  return dio.request(
    _getUrl(uri),
    queryParameters: _getQuery(uri, data, dataGlobal),
    data: typeBody != "none" && method != "GET" ? formDataBody : null,
    options: Options(
      method: method,
      headers: dataHeaders,
      contentType: dataHeaders["Content-Type"] is String ? dataHeaders["Content-Type"] : defaultContentType,
    ),
  );
}