import 'package:flutter/material.dart';
import 'package:flutter_html_form/widgets/container.dart';

import '../models/option_value.dart';
import '../models/select.dart';
import '../widgets/select_item.dart';

// Single select
OptionValueModel _getDefaultSingleValue(SelectModel data) {
  Map<int, String> value = {};
  for (var visit in data.option.defaultValues) {
    if (value.isEmpty && visit > 0 && visit <= data.option.options.length) {
      value = {
        visit: data.option.options[visit - 1],
      };
    }
  }
  if (value.isEmpty) {
    if (!data.includeBlank) {
      value = {
        1: data.option.options[0],
      };
    } else {
      value = {
        0: "",
      };
    }
  }
  return OptionValueModel(value: value, multi: false);
}

String _getStringSingleValue(OptionValueModel? data, String defaultValue) {
  dynamic valueModel = data?.toValue();
  if (valueModel is String) {
    return valueModel;
  }
  if (valueModel is List && valueModel.isNotEmpty) {
    return valueModel.elementAtOrNull(0) is String ? valueModel.elementAtOrNull(0) : defaultValue;
  }
  return defaultValue;
}

// Multi select
OptionValueModel _getDefaultMultiValue(SelectModel data) {
  Map<int, String> value = {};
  for (var visit in data.option.defaultValues) {
    if (visit == 0) {
      if (data.includeBlank) {
        value = {
          ...value,
          visit: "",
        };
      }
    } else if (visit > 0 && visit <= data.option.options.length) {
      value = {
        ...value,
        visit: data.option.options[visit - 1],
      };
    }
  }
  return OptionValueModel(value: value, multi: true);
}

class SelectField extends StatelessWidget {
  final OptionValueModel? value;
  final ValueChanged<dynamic> onChange;
  final SelectModel data;

  const SelectField({
    Key? key,
    this.value,
    required this.onChange,
    required this.data,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (data.multiple) {
      return _SelectMulti(value: value, onChange: onChange, data: data);
    }
    return _SelectSingle(value: value, onChange: onChange, data: data);
  }
}

class _SelectSingle extends StatefulWidget {
  final OptionValueModel? value;
  final ValueChanged<dynamic> onChange;
  final SelectModel data;

  const _SelectSingle({
    Key? key,
    this.value,
    required this.onChange,
    required this.data,
  }) : super(key: key);

  @override
  State<_SelectSingle> createState() => _SelectSingleState();
}

class _SelectSingleState extends State<_SelectSingle> {
  late TextEditingController _controller;

  @override
  void initState() {
    String defaultValue = _getStringSingleValue(_getDefaultSingleValue(widget.data), "");
    String value = _getStringSingleValue(widget.value, defaultValue);
    _controller = TextEditingController(text: value);

    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void openDialog() async {
    List<int> keys = widget.value?.value.keys.toList() ?? [];
    int? visit = keys.isNotEmpty ? keys.first : null;

    int? data = await showModalBottomSheet<int?>(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20)),
      ),
      builder: (_) {
        MediaQueryData mediaQuery = MediaQuery.of(context);
        double height = (mediaQuery.size.height - mediaQuery.viewInsets.bottom) * 0.8;
        return Container(
          constraints: BoxConstraints(maxHeight: height),
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(vertical: 24, horizontal: 20),
            child: _ModalView(
              visit: visit,
              options: widget.data.option.options,
              onChange: (data) => Navigator.of(context).pop(data),
              includeBlank: widget.data.includeBlank,
            ),
          ),
        );
      },
    );
    if (data != null && data != visit) {
      String textOption = data == 0 ? "" : widget.data.option.options[data - 1];
      _controller.text = textOption;
      widget.onChange(OptionValueModel(value: {data: textOption}, multi: false));
    }
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);

    OptionValueModel defaultValues = _getDefaultSingleValue(widget.data);

    /// Update only if this widget initialized.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.value == null) {
        String textDefault = _getStringSingleValue(defaultValues, "");
        if (_controller.text != textDefault) {
          _controller.text = textDefault;
        }
        widget.onChange(defaultValues);
      }
    });

    return TextFormField(
      controller: _controller,
      readOnly: true,
      decoration: InputDecoration(
        hintText: widget.data.includeBlank ? "Please choose an option" : null,
        hintStyle: theme.inputDecorationTheme.labelStyle,
        suffixIcon: Icon(Icons.keyboard_arrow_down, color: theme.iconTheme.color),
      ),
      onTap: openDialog,
      textAlignVertical: TextAlignVertical.center,
      validator: (String? value) {
        if (widget.data.required && value?.isNotEmpty != true) {
          return "Required";
        }
        return null;
      },
    );
  }
}

class _SelectMulti extends StatefulWidget {
  final OptionValueModel? value;
  final ValueChanged<dynamic> onChange;
  final SelectModel data;

  const _SelectMulti({
    Key? key,
    this.value,
    required this.onChange,
    required this.data,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _SelectMultiState();
}

class _SelectMultiState extends State<_SelectMulti> {
  late TextEditingController _controller;

  @override
  void initState() {
    OptionValueModel defaultValue = _getDefaultMultiValue(widget.data);
    _controller = TextEditingController(text: widget.value?.toKeys() ?? defaultValue.toKeys());

    _controller.addListener(() {
      String text = _controller.text;
      if (text != widget.value?.toKeys()) {
        Map<int, String> value = {};
        List<String> options = widget.data.option.options;
        List<String> keys = text.split("_");

        for (var key in keys) {
          int visit = int.tryParse(key) ?? 0;
          if (visit == 0) {
            if (widget.data.includeBlank) {
              value = {
                ...value,
                visit: "",
              };
            }
          } else if (visit > 0 && visit <= options.length) {
            value = {
              ...value,
              visit: options[visit - 1],
            };
          }
        }
        widget.onChange(OptionValueModel(value: value, multi: widget.data.multiple));
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
    OptionValueModel defaultValues = _getDefaultMultiValue(widget.data);

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
        ContainerBorderWidget(
          child: Column(
            children: [
              if (widget.data.includeBlank)
                SelectItemTileCheckWidget(
                  title: "Please choose an option",
                  isSelect: widget.value?.value.keys.contains(0) ?? false,
                  onChange: (_) {
                    String visit = "0";
                    if (!_controller.text.contains(visit)) {
                      _controller.text = _controller.text.isEmpty ? visit : "${_controller.text}_$visit";
                    } else {
                      _controller.text = "${_controller.text.split("_").where((e) => e != visit).toList().join("_")}";
                    }
                  },
                ),
              if (options.isNotEmpty)
                ...List.generate(options.length, (index) {
                  bool isSelect = widget.value?.value.keys.contains(index + 1) ?? false;
                  return SizedBox(
                    width: double.infinity,
                    child: SelectItemTileCheckWidget(
                      isSelect: isSelect,
                      title: options[index],
                      onChange: (_) {
                        String visit = "${index + 1}";
                        if (!_controller.text.contains(visit)) {
                          _controller.text = _controller.text.isEmpty ? visit : "${_controller.text}_$visit";
                        } else {
                          _controller.text =
                              "${_controller.text.split("_").where((e) => e != visit).toList().join("_")}";
                        }
                      },
                    ),
                  );
                }).toList(),
            ],
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

class _ModalView extends StatelessWidget {
  final int? visit;
  final List<String> options;
  final ValueChanged<int> onChange;
  final bool includeBlank;

  _ModalView({
    Key? key,
    this.visit,
    required this.options,
    required this.onChange,
    this.includeBlank = false,
  }) : super(key: key);

  void onClick(int index) {
    if (index != visit) {
      onChange(index);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (includeBlank)
          SelectItemTileCheckWidget(
            title: "Please choose an option",
            isSelect: visit == 0,
            onChange: (_) => onClick(0),
          ),
        if (options.isNotEmpty)
          ...List.generate(
            options.length,
            (index) {
              int visitKey = index + 1;
              return SelectItemTileCheckWidget(
                title: options[index],
                isSelect: visit == visitKey,
                onChange: (_) => onClick(visitKey),
              );
            },
          )
      ],
    );
  }
}
