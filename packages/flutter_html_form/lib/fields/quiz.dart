import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_html_form/models/quiz.dart';

class QuizField extends StatefulWidget {
  final String? value;
  final void Function(String value) onChange;
  final QuizModel data;

  const QuizField({
    Key? key,
    this.value,
    required this.onChange,
    required this.data,
  }) : super(key: key);

  @override
  State<QuizField> createState() => _QuizFieldState();
}

class _QuizFieldState extends State<QuizField> {
  late TextEditingController _controller;

  @override
  void initState() {
    _controller = TextEditingController();

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
    int visitQuiz = widget.data.options.length > 1 ? Random().nextInt(widget.data.options.length) : 0;

    OptionQuiz quiz = widget.data.options[visitQuiz];

    /// Update only if this widget initialized.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.value == null) {
        if (_controller.text != "") {
          _controller.text = "";
        } else {
          widget.onChange("");
        }
      }
    });

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(quiz.question),
        SizedBox(height: 2),
        TextFormField(
          controller: _controller,
          validator: (String? value) {
            if (widget.data.required && value?.isNotEmpty != true) {
              return "Required";
            }
            if (widget.data.minLength != null && widget.data.minLength! > (value?.length ?? 0)) {
              return "Min length is ${widget.data.minLength}";
            }
            if (widget.data.maxLength != null && widget.data.maxLength! < (value?.length ?? 0)) {
              return "Max length is ${widget.data.maxLength}";
            }
            if (quiz.answer != value) {
              return "The answer to the quiz is incorrect.";
            }
            return null;
          },
        ),
      ],
    );
  }
}
