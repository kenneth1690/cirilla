import 'package:flutter/material.dart';

class SubmitField extends StatelessWidget {
  final Map<String, String> attributes;
  final Function onSubmit;
  final bool loading;
  final Widget loadingWidget;

  const SubmitField({
    Key? key,
    required this.attributes,
    required this.onSubmit,
    required this.loadingWidget,
    this.loading = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String text = attributes["value"] ?? "";

    return SizedBox(
      height: 48,
      width: double.infinity,
      child: ElevatedButton(
        onPressed: !loading ? () => onSubmit() : () => {},
        child: loading ? loadingWidget : Text(text.isNotEmpty ? text : "Send"),
      ),
    );
  }
}