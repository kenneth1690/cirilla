import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:url_launcher/url_launcher.dart' as url_launcher;

bool emailValidator(String value) {
  const Pattern emailPattern =
      r"^((([a-z]|\d|[!#\$%&'\*\+\-\/=\?\^_`{\|}~]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])+(\.([a-z]|\d|[!#\$%&'\*\+\-\/=\?\^_`{\|}~]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])+)*)|((\x22)((((\x20|\x09)*(\x0d\x0a))?(\x20|\x09)+)?(([\x01-\x08\x0b\x0c\x0e-\x1f\x7f]|\x21|[\x23-\x5b]|[\x5d-\x7e]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(\\([\x01-\x09\x0b\x0c\x0d-\x7f]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF]))))*(((\x20|\x09)*(\x0d\x0a))?(\x20|\x09)+)?(\x22)))@((([a-z]|\d|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(([a-z]|\d|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])([a-z]|\d|-|\.|_|~|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])*([a-z]|\d|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])))\.)+(([a-z]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(([a-z]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])([a-z]|\d|-|\.|_|~|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])*([a-z]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])))$";
  return RegExp(emailPattern as String).hasMatch(value);
}

Future<void> launch(String url) async {
  final Uri uri = Uri.parse(url);
  if (!await url_launcher.launchUrl(
    uri,
    mode: url_launcher.LaunchMode.externalApplication,
  )) {
    throw 'Could not launch $uri';
  }
}

void showError(BuildContext context, dynamic e, {OnTap? onLinkTap, SnackBarAction? action}) {
  String? message = '';

  if (e.runtimeType == String) {
    message = e;
  } else if (e is DioException) {
    message = e.response != null && e.response?.data != null ? e.response?.data['error'] is String ? e.response?.data['error'] : e.response?.data['message'] : e.message;
  } else if (e is Map) {
    message = e['error'] is String ? e['error'] : e['message'] is String ? e['message'] : "Error";
  }

  final snackBar = SnackBar(
    content: Builder(
      builder: (BuildContext context) => Html(
        data: "<div>$message</div>",
        style: {
          "div": Style(color: Colors.white),
          "a": Style(color: Colors.white, fontWeight: FontWeight.bold),
        },
        onLinkTap: onLinkTap,
      ),
    ),
    backgroundColor: Theme.of(context).colorScheme.error,
    action: action,
  );
  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}

void showSuccess(BuildContext context, String? e, {OnTap? onLinkTap, SnackBarAction? action}) {
  final snackBar = SnackBar(
    duration: const Duration(milliseconds: 700),
    content: Builder(
      builder: (BuildContext context) => Html(
        data: "<div>$e</div>",
        style: {
          "div": Style(color: Colors.white),
          "a": Style(color: Colors.white, fontWeight: FontWeight.bold),
        },
        onLinkTap: onLinkTap,
      ),
    ),
    action: action,
    backgroundColor: Colors.green,
  );
  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}