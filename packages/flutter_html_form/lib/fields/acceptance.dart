import 'package:flutter/material.dart';
import 'package:flutter_html_form/convert.dart';

import '../widgets/select_item.dart';

class AcceptanceField extends StatefulWidget {
  final String? value;
  final void Function(String value) onChange;
  final Map<String, String> attributes;

  const AcceptanceField({
    Key? key,
    this.value,
    required this.onChange,
    required this.attributes,
  }) : super(key: key);

  @override
  State<AcceptanceField> createState() => _AcceptanceFieldState();
}

class _AcceptanceFieldState extends State<AcceptanceField> {
  late TextEditingController _controller;

  @override
  void initState() {
    bool active = convertToBool(widget.attributes["data-active"]) ?? false;
    _controller = TextEditingController(text: active ? "1" : "0");

    _controller.addListener(() {
      String text = _controller.text;
      if (text != widget.value) {
        widget.onChange(text);
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    bool dataRequired = convertToBool(widget.attributes["data-required"]) ?? false;
    bool active = convertToBool(widget.attributes["data-active"]) ?? false;
    bool invert = convertToBool(widget.attributes["data-invert"]) ?? false;

    String condition = widget.attributes["data-condition"] ?? "";

    String defaultValue = active ? "1" : "0";

    /// Update only if this widget initialized.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.value == null) {
        if (_controller.text != defaultValue) {
          _controller.text = defaultValue;
        } else {
          widget.onChange(defaultValue);
        }
      }
    });

    return Column(
      children: [
        SelectItemWidget(
          isSelect: widget.value == "1",
          title: condition.trim(),
          onChange: (newValue) {
            _controller.text = newValue ? "1" : "0";
          },
          checkbox: true,
        ),
        TextFormField(
          style: TextStyle(height: 0, fontSize: 0),
          controller: _controller,
          decoration: InputDecoration(
            isDense: true,
            contentPadding: EdgeInsets.zero,
          ),
          readOnly: true,
          validator: (String? value) {
            if (dataRequired && value?.isNotEmpty != true) {
              return "Required";
            }
            if (!invert && value != "1") {
              return "Must check field";
            }
            return null;
          },
        ),
      ],
    );
  }
}
