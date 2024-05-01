import 'dart:convert';

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'helpers.dart';
import 'html.dart';

typedef _TranslateType = String Function(String key, [Map<String, String>? options]);

class FlutterYithTrackOrderWidget extends StatefulWidget {
  static String title = "Track order";

  /// data is Map<String,dynamic>
  /// example:
  /// {
  ///  'orderData': order!.toJson(),
  ///  'translate': translate,
  ///  'baseURL': 'https://example.com/wp-json',
  /// }
  final Map<String, dynamic> data;

  static bool checkOpen(Map<String, dynamic> data) {
    List metaData = data["meta_data"] is List ? data["meta_data"] : [];
    dynamic metaTrackOrder = metaData.firstWhereOrNull((element) =>
        element is Map && element["key"] == "ywot_tracking_code" && element["value"] != null && element["value"] != "");
    return metaTrackOrder != null;
  }

  FlutterYithTrackOrderWidget({
    Key? key,
    required this.data,
  });

  @override
  State<FlutterYithTrackOrderWidget> createState() => _FlutterYithTrackOrderWidgetState();
}

class _FlutterYithTrackOrderWidgetState extends State<FlutterYithTrackOrderWidget> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _txtEmail;
  late TextEditingController _txtOrderId;

  final FocusNode _orderIdFocusNode = FocusNode();

  bool _loading = false;

  @override
  void initState() {
    Map<String, dynamic> data = widget.data["orderData"] is Map
        ? (widget.data["orderData"] as Map).cast<String, dynamic>()
        : {}.cast<String, dynamic>();
    _txtEmail = TextEditingController(
        text: data["billing"] is Map && data["billing"]["email"] is String ? data["billing"]["email"] : "");
    _txtOrderId = TextEditingController(text: "${data["id"] ?? ""}");

    super.initState();
  }

  @override
  void dispose() {
    _txtEmail.dispose();
    _txtOrderId.dispose();
    _orderIdFocusNode.dispose();
    super.dispose();
  }

  void onSubmit(_TranslateType translate) {
    if (!_loading) {
      FocusManager.instance.primaryFocus?.unfocus();
      if (_formKey.currentState!.validate()) {
        trackOrder(translate);
      }
    }
  }

  void trackOrder(_TranslateType translate) async {
    try {
      setState(() {
        _loading = true;
      });

      String url = widget.data["baseURL"] is String ? widget.data["baseURL"] : "";

      var uri = Uri.parse("$url/app-builder/v1/order-tracking").replace(queryParameters: {
        "order_id": _txtOrderId.text,
        "email": "ngocdt@rnlab.io",
      });
      var response = await http.get(
        uri,
        headers: {'Content-Type': 'application/json; charset=utf-8'},
      );

      if (response.statusCode == 200) {
        dynamic data = jsonDecode(response.body);
        showResult(data, translate);
      } else {
        dynamic data = jsonDecode(response.body);
        showError(context, data);
      }
      setState(() {
        _loading = false;
      });
    } catch (e) {
      showError(context, e);
      setState(() {
        _loading = false;
      });
    }
  }

  void showResult(Map data, _TranslateType translate) async {
    String text = data["message"] is String ? data["message"] : "";
    String url = data["url"] is String ? data["url"] : "";
    String trackingCode =
        data["data"] is Map && data["data"]["tracking_code"] is String ? data["data"]["tracking_code"] : "";

    await showDialog<String>(
      context: context,
      builder: (BuildContext context) => Dialog(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Align(
                alignment: AlignmentDirectional.centerEnd,
                child: TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Icon(Icons.close),
                ),
              ),
              const SizedBox(height: 4),
              TextHtml(
                html: text,
                onCopy: () {
                  Clipboard.setData(ClipboardData(text: trackingCode)).then((_) {
                    showSuccess(context, translate("Copied!"));
                  });
                },
              ),
              SizedBox(height: 8),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => launch(url),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(translate("Track your order")),
                      SizedBox(width: 12),
                      Icon(Icons.track_changes, size: 18),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    _TranslateType translate = widget.data["translate"] is _TranslateType ? widget.data["translate"] : (key, __) => key;

    return Form(
      key: _formKey,
      child: Column(
        children: [
          TextFormField(
            controller: _txtEmail,
            validator: (String? value) {
              if (value == null || value == "") {
                return translate("Field empty");
              }

              if (!emailValidator(value)) {
                return translate("Invalid email");
              }
              return null;
            },
            decoration: InputDecoration(
              labelText: translate("Your email"),
            ),
            keyboardType: TextInputType.emailAddress,
            textInputAction: TextInputAction.next,
            onFieldSubmitted: (value) {
              FocusScope.of(context).requestFocus(_orderIdFocusNode);
            },
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _txtOrderId,
            focusNode: _orderIdFocusNode,
            validator: (String? value) {
              if (value == null || value == "") {
                return translate("Field empty");
              }
              return null;
            },
            decoration: InputDecoration(
              labelText: translate("Your order ID"),
            ),
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () => onSubmit(translate),
              child: _loading
                  ? SpinKitThreeBounce(
                      color: Theme.of(context).colorScheme.onPrimary,
                      size: 16,
                    )
                  : Text(translate("Track order")),
            ),
          ),
        ],
      ),
    );
  }
}
