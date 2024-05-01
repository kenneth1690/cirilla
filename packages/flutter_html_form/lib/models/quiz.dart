import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_html_form/convert.dart';

import 'option_data.dart';

class OptionQuiz {
  final String question;
  final String answer;

  OptionQuiz({
    required this.question,
    required this.answer,
  });
}

class QuizModel {
  final String name;
  final List<OptionQuiz> options;
  final bool required;
  final int? minLength;
  final int? maxLength;
  final int? size;

  QuizModel({
    required this.name,
    required this.options,
    required this.required,
    this.minLength,
    this.maxLength,
    this.size,
  });
}

QuizModel convertQuizModelFromRenderContext(RenderContext context) {
  Map<String, String> attributes = context.tree.attributes;
  List<StyledElement> children = context.tree.children;

  String name = attributes["data-name"] ?? "";
  bool requiredField = convertToBool(attributes["data-required"]) ?? false;
  int? minLength = convertStringToIntCanBeNull(attributes["data-minlength"]);
  int? maxLength = convertStringToIntCanBeNull(attributes["data-maxlength"]);
  int? size = convertStringToIntCanBeNull(attributes["data-size"]);

  return QuizModel(
    name: name,
    options: _getOptions(children, name),
    required: requiredField,
    minLength: minLength != null && maxLength != null && minLength > maxLength ? maxLength : minLength,
    maxLength: minLength != null && maxLength != null && minLength > maxLength ? minLength : maxLength,
    size: size,
  );
}

List<OptionQuiz> _getOptions(List<StyledElement> children, String name) {
  List<OptionQuiz> options = [];
  for (var child in children) {
    if (child.name == "span") {
      Map<String, String> attributes = child.attributes;
      List<StyledElement> spanChildren = child.children;
      if (attributes["data-name"] == name && spanChildren.isNotEmpty && spanChildren.first is TextContentElement) {
        String text = (spanChildren.first as TextContentElement).text ?? "";
        List<String> splitText = text.split("|");
        if (splitText.length == 2) {
          options.add(OptionQuiz(question: splitText[0], answer: splitText[1]));
        }
      }
    }
  }
  return options;
}
