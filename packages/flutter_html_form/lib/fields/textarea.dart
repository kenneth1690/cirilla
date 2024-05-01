import 'package:flutter/material.dart';

import '../convert.dart';
import '../text_dynamic.dart';

class TextareaField extends StatefulWidget {
  final String? value;
  final ValueChanged<dynamic> onChange;
  final Map<String, String> attributes;
  final Map<String, dynamic> user;

  const TextareaField({
    Key? key,
    this.value,
    required this.onChange,
    required this.attributes,
    required this.user,
  }) : super(key: key);

  @override
  State<TextareaField> createState() => _TextareaFieldState();
}

class _TextareaFieldState extends State<TextareaField> {
  late TextEditingController _controller;

  @override
  void initState() {
    String defaultValue = TextDynamic.getTextDynamic(text: widget.attributes["value"] ?? "", options: widget.user);
    _controller = TextEditingController(text: widget.value ?? defaultValue);

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
    String placeholder = widget.attributes["placeholder"] ?? "";
    bool required = convertToBool(widget.attributes["required"]) ?? false;

    /// Update only if this widget initialized.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.value == null) {
        String defaultValue = TextDynamic.getTextDynamic(text: widget.attributes["value"] ?? "", options: widget.user);
        if (_controller.text != defaultValue) {
          _controller.text = defaultValue;
        } else {
          widget.onChange(defaultValue);
        }
      }
    });

    return TextFormField(
      controller: _controller,
      validator: (String? value) {
        if (required && value?.isNotEmpty != true) {
          return "Required";
        }
        return null;
      },
      maxLines: 4,
      decoration: InputDecoration(hintText: placeholder),
    );
  }
}
