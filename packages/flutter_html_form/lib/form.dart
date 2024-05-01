import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';

import 'models/checkbox.dart';
import 'models/radio.dart';
import 'models/select.dart';
import 'models/quiz.dart';
import 'models/option_value.dart';
import 'conditional.dart';

import 'fields/checkbox.dart';
import 'fields/radio.dart';
import 'fields/select.dart';
import 'fields/textarea.dart';
import 'fields/inputs.dart';
import 'fields/submit.dart';
import 'fields/acceptance.dart';
import 'fields/quiz.dart';

import 'widgets/container.dart';

CustomRender formRender({Key? key}) => CustomRender.widget(
      widget: (context, buildChildren) {
        if (context.tree is TextContentElement) {
          return _buildText(context.tree as TextContentElement);
        }

        List<InlineSpan> children = buildChildren();
        return _Form(keyForm: key, children: children);
      },
    );

CustomRender labelRender() => CustomRender.widget(
      widget: (context, buildChildren) {
        if (context.tree is TextContentElement) {
          return _buildText(context.tree as TextContentElement);
        }

        return RichText(
          text: TextSpan(children: buildChildren(), style: TextStyle()),
        );
      },
    );

CustomRender inputRender({
  required Map<String, dynamic> data,
  required void Function(String key, dynamic value) onChange,
  required Map<String, dynamic> user,
  bool submitLoading = false,
  required Function submitOnPressed,
  required Widget submitLoadingWidget,
}) =>
    CustomRender.widget(
      widget: (context, buildChildren) {
        String type = context.tree.attributes["type"] ?? "text";

        if (type == "submit") {
          return SubmitField(
            attributes: context.tree.attributes,
            onSubmit: submitOnPressed,
            loading: submitLoading,
            loadingWidget: submitLoadingWidget,
          );
        }
        return Inputs(
          data: data,
          onChange: onChange,
          attributes: context.tree.attributes,
          user: user,
        );
      },
    );

CustomRender textareaRender({
  required Map<String, dynamic> data,
  required void Function(String key, dynamic value) onChange,
  required Map<String, dynamic> user,
}) =>
    CustomRender.widget(
      widget: (context, _) {
        if (checkShowField(data, context.tree.attributes)) {
          String? defaultValue;
          if (context.tree.children.isNotEmpty && context.tree.children[0] is TextContentElement) {
            defaultValue = (context.tree.children[0] as TextContentElement).text;
          }

          Map<String, String> attributes = context.tree.attributes;
          String nameKey = attributes["name"] ?? "";

          dynamic value = data[nameKey] is String ? data[nameKey] : null;

          return Container(
            width: double.infinity,
            margin: context.style.margin,
            padding: context.style.padding,
            color: context.style.backgroundColor,
            child: ContainerWidget(
              child: TextareaField(
                value: value is String ? value : null,
                onChange: (newValue) => onChange(nameKey, newValue),
                attributes: {
                  ...attributes,
                  "type": "textarea",
                  if (defaultValue != null) "value": defaultValue,
                },
                user: user,
              ),
            ),
          );
        }

        return SizedBox();
      },
    );

CustomRender checkboxRender({
  required Map<String, dynamic> data,
  required void Function(String key, dynamic value) onChange,
}) =>
    CustomRender.widget(
      widget: (context, buildChildren) {
        CheckboxModel dataModel = convertCheckboxModelFromRenderContext(context);
        if (dataModel.option.options.isNotEmpty) {
          OptionValueModel? value = data[dataModel.name] is OptionValueModel ? data[dataModel.name] : null;
          return ContainerWidget(
            child: CheckboxField(
              value: value,
              onChange: (newValue) => onChange(dataModel.name, newValue),
              data: dataModel,
            ),
          );
        }
        return SizedBox();
      },
    );

CustomRender radioRender({
  required Map<String, dynamic> data,
  required void Function(String key, dynamic value) onChange,
}) =>
    CustomRender.widget(
      widget: (context, buildChildren) {
        RadioModel dataModel = convertRadioModelFromRenderContext(context);
        if (dataModel.option.options.isNotEmpty) {
          OptionValueModel? value = data[dataModel.name] is OptionValueModel ? data[dataModel.name] : null;
          return ContainerWidget(
            child: RadioField(
              value: value,
              onChange: (newValue) => onChange(dataModel.name, newValue),
              data: dataModel,
            ),
          );
        }
        return SizedBox();
      },
    );

CustomRender selectRender({
  required Map<String, dynamic> data,
  required void Function(String key, dynamic value) onChange,
}) =>
    CustomRender.widget(
      widget: (context, buildChildren) {
        SelectModel dataModel = convertSelectModelFromRenderContext(context);
        if (dataModel.option.options.isNotEmpty) {
          OptionValueModel? value = data[dataModel.name] is OptionValueModel ? data[dataModel.name] : null;
          return ContainerWidget(
            child: SelectField(
              value: value,
              onChange: (newValue) => onChange(dataModel.name, newValue),
              data: dataModel,
            ),
          );
        }
        return SizedBox();
      },
    );

CustomRender acceptanceRender({
  required Map<String, dynamic> data,
  required void Function(String key, dynamic value) onChange,
}) =>
    CustomRender.widget(
      widget: (context, buildChildren) {
        Map<String, String> attributes = context.tree.attributes;

        String key = attributes["data-name"] ?? "";
        return ContainerWidget(
          child: AcceptanceField(
            value: data[key] is String ? data[key] : null,
            onChange: (newValue) => onChange(key, newValue),
            attributes: attributes,
          ),
        );
      },
    );

CustomRender quizRender({
  required Map<String, dynamic> data,
  required void Function(String key, dynamic value) onChange,
}) =>
    CustomRender.widget(
      widget: (context, buildChildren) {
        QuizModel dataModel = convertQuizModelFromRenderContext(context);
        if (dataModel.options.isNotEmpty) {
          String? value = data[dataModel.name] is String ? data[dataModel.name] : null;
          return ContainerWidget(
            child: QuizField(
              value: value,
              onChange: (newValue) => onChange(dataModel.name, newValue),
              data: dataModel,
            ),
          );
        }
        return SizedBox();
      },
    );

CustomRender conditionalRender({required Map<String, dynamic> data}) => CustomRender.widget(
      widget: (context, buildChildren) {
        Widget child = Container();

        if (context.tree.children.isNotEmpty) {
          if (context.tree is TextContentElement) {
            child = _buildText(context.tree as TextContentElement);
          } else {
            child = RichText(
              text: TextSpan(children: buildChildren(), style: TextStyle()),
            );
          }
        }

        return Visibility(
          visible: checkShowField(data, context.tree.attributes),
          maintainState: true,
          child: child,
        );
        return SizedBox();
      },
    );

_buildText(TextContentElement contentText) {
  String text = (contentText.text ?? "").trim();
  if (text.trim().isNotEmpty) {
    return Text(text);
  }
  return SizedBox();
}

class _Form extends StatelessWidget {
  final Key? keyForm;
  final List<InlineSpan> children;

  const _Form({
    this.keyForm,
    this.children = const [],
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Form(
        key: keyForm,
        child: RichText(
          text: TextSpan(
            children: children,
          ),
        ),
      ),
    );
  }
}
