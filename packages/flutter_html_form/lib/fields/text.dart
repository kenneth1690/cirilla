import 'package:flutter/material.dart';

import '../convert.dart';
import '../validate.dart';
import '../text_dynamic.dart';

class TextFieldWidget extends StatefulWidget {
  final String? value;
  final ValueChanged<dynamic> onChange;
  final Map<String, String> attributes;
  final String type;
  final Map<String, dynamic> user;

  const TextFieldWidget({
    Key? key,
    this.value,
    required this.onChange,
    required this.attributes,
    this.type = "text",
    required this.user,
  }) : super(key: key);

  @override
  State<TextFieldWidget> createState() => _TextFieldState();
}

class _TextFieldState extends State<TextFieldWidget> {
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

  TextInputType? getInputType() {
    switch (widget.type) {
      case "email":
        return TextInputType.emailAddress;
      case "url":
        return TextInputType.url;
      case "tel":
        return TextInputType.phone;
      default:
        return null;
    }
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

        if (widget.type == "email" && !emailValidator(value ?? "")) {
          return "Invalid email";
        }

        if (widget.type == "url" && !Uri.parse(value ?? "").isAbsolute) {
          return "Invalid Url";
        }
        if (widget.type == "tel" && !phoneValidator(value ?? "")) {
          return "Invalid phone number";
        }
        return null;
      },
      decoration: InputDecoration(hintText: placeholder),
      keyboardType: getInputType(),
    );
  }
}
