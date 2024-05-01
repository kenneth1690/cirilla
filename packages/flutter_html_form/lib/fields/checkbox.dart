import 'package:flutter/material.dart';
import 'package:flutter_html_form/widgets/container.dart';

import '../models/checkbox.dart';
import '../models/option_value.dart';
import '../widgets/grid.dart';
import '../widgets/select_item.dart';

OptionValueModel _getDefaultValue(CheckboxModel data) {
  Map<int, String> value = {};
  for (var visit in data.option.defaultValues) {
    if (visit > 0 && visit <= data.option.options.length) {
      if (!data.exclusive || (data.exclusive && value.isEmpty)) {
        value = {
          ...value,
          visit: data.option.options[visit - 1],
        };
      }
    }
  }
  return OptionValueModel(value: value, multi: !data.exclusive);
}

class CheckboxField extends StatefulWidget {
  final OptionValueModel? value;
  final ValueChanged<dynamic> onChange;
  final CheckboxModel data;

  const CheckboxField({
    Key? key,
    this.value,
    required this.onChange,
    required this.data,
  }) : super(key: key);

  @override
  State<CheckboxField> createState() => _CheckboxFieldState();
}

class _CheckboxFieldState extends State<CheckboxField> {
  late TextEditingController _controller;

  @override
  void initState() {
    OptionValueModel defaultValue = _getDefaultValue(widget.data);
    _controller = TextEditingController(text: widget.value?.toKeys() ?? defaultValue.toKeys());

    _controller.addListener(() {
      String text = _controller.text;
      if (text != widget.value?.toKeys()) {
        Map<int, String> value = {};
        List<String> options = widget.data.option.options;
        List<String> keys = text.split("_");

        for(var key in keys) {
          int visit = int.tryParse(key) ?? 0;
          if (visit > 0 && visit <= options.length) {
            value = {
              ...value,
              visit: options[visit - 1],
            };
          }
        }
        widget.onChange(OptionValueModel(value: value, multi: !widget.data.exclusive));
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
    List<String> options = widget.data.option.options;
    List<String>? images = widget.data.option.imageOptions;
    OptionValueModel defaultValues = _getDefaultValue(widget.data);

    /// Update only if this widget initialized.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.value == null) {
        if (_controller.text != defaultValues.toKeys()) {
          _controller.text = defaultValues.toKeys();
        } else {
          widget.onChange(defaultValues);
        }
      }
    });

    return Column(
      children: [
        if (images != null)
          GridWidget(
            count: options.length,
            buildItem: (int index, double width) {
              bool isSelect = widget.value?.value.keys.contains(index + 1) ?? false;

              return SelectItemImageWidget(
                size: width,
                isSelect: isSelect,
                title: options[index],
                image: images.elementAtOrNull(index) ?? "",
                onChange: (_) {
                  String visit = "${index + 1}";
                  if (widget.data.exclusive) {
                    _controller.text = visit;
                  } else {
                    if (!_controller.text.contains(visit)) {
                      _controller.text = _controller.text.isEmpty ? visit : "${_controller.text}_$visit";
                    } else {
                      _controller.text = "${_controller.text.split("_").where((e) => e != visit).toList().join("_")}";
                    }
                  }
                },
                checkbox: true,
              );
            },
          )
        else
        ContainerBorderWidget(
          child: ListView.separated(
            itemBuilder: (_, int index) {
              bool isSelect = widget.value?.value.keys.contains(index + 1) ?? false;
              return SelectItemWidget(
                isSelect: isSelect,
                title: options[index],
                onChange: (_) {
                  String visit = "${index + 1}";
                  if (widget.data.exclusive) {
                    _controller.text = visit;
                  } else {
                    if (!_controller.text.contains(visit)) {
                      _controller.text = _controller.text.isEmpty ? visit : "${_controller.text}_$visit";
                    } else {
                      _controller.text = "${_controller.text.split("_").where((e) => e != visit).toList().join("_")}";
                    }
                  }
                },
                checkbox: true,
                titleFirst: widget.data.labelFirst,
              );
            },
            separatorBuilder: (_, __) => SizedBox(height: 10),
            itemCount: options.length,
            padding: EdgeInsets.zero,
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
          ),
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
            if (widget.data.required && value?.isNotEmpty != true) {
              return "Required";
            }
            return null;
          },
        ),
      ],
    );
  }
}
