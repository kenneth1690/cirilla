import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'dart:core';

import '../convert.dart';

DateFormat _dateFormat = DateFormat("yyyy-MM-dd");

class DateField extends StatefulWidget {
  final String? value;
  final ValueChanged<dynamic> onChange;
  final Map<String, String> attributes;

  const DateField({
    Key? key,
    this.value,
    required this.onChange,
    required this.attributes,
  }) : super(key: key);

  @override
  State<DateField> createState() => _DateFieldState();
}

class _DateFieldState extends State<DateField> {
  late TextEditingController _controller;

  @override
  void initState() {
    String defaultValue = widget.attributes["value"] ?? "";
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

  DateTime? getDate(String date, DateTime? min, DateTime? max) {
    if (date.isNotEmpty) {
      DateTime newDate = _dateFormat.parse(date);
      if (min == null && max == null) {
        return newDate;
      }

      if (min != null && max != null) {
        if (min.isAfter(newDate)) {
          return min;
        }
        if (newDate.isAfter(max)) {
          return max;
        }
        return newDate;
      }

      if (min != null) {
        if (min.isAfter(newDate)) {
          return min;
        }
        return newDate;
      }

      if (max != null) {
        if (newDate.isAfter(max)) {
          return max;
        }
        return newDate;
      }
    }

    return min ?? max ?? DateTime.now();
  }
  void selectTime(BuildContext context) async {

    String? max = widget.attributes["max"];
    String? min = widget.attributes["min"];

    DateTime? defaultMaxDate = max?.isNotEmpty == true? _dateFormat.parse(max!) : null;
    DateTime? defaultMinDate = min?.isNotEmpty == true?_dateFormat.parse(min!) : null;

    DateTime? maxDate = defaultMinDate != null && defaultMaxDate != null && defaultMaxDate.isBefore(defaultMinDate) ? defaultMinDate : defaultMaxDate;
    DateTime? minDate = defaultMinDate != null && defaultMaxDate != null && defaultMaxDate.isBefore(defaultMinDate) ? defaultMaxDate : defaultMinDate;

    DateTime? dateTime = getDate(_controller.text, minDate, maxDate);
    DateTime? value = await showModalBottomSheet<DateTime?>(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return buildViewModal(
          child: StatefulBuilder(
            builder: (BuildContext context, StateSetter stateSetter) {
              return _ModalDateTime(
                value: dateTime,
                onChanged: (DateTime? value) {
                  Navigator.pop(context, value);
                },
                mode: CupertinoDatePickerMode.date,
                min: minDate,
                max: maxDate,
              );
            },
          ),
        );
      },
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20)),
      ),
    );
    if (value != null) {
      if (!mounted) return;
      String date = _dateFormat.format(value);
      if (date != _controller.text) {
        _controller.text = date;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);

    String placeholder = widget.attributes["placeholder"] ?? "";
    bool required = convertToBool(widget.attributes["required"]) ?? false;

    /// Update only if this widget initialized.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.value == null) {
        String defaultValue = widget.attributes["value"] ?? "";
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
      decoration: InputDecoration(
        hintText: placeholder,
        suffixIcon: Icon(Icons.calendar_month, color: theme.textTheme.bodyMedium?.color,),
      ),
      textAlignVertical: TextAlignVertical.center,
      readOnly: true,
      onTap: () => selectTime(context),
    );
  }

  Widget buildViewModal({Widget? child}) {
    return LayoutBuilder(builder: (_, BoxConstraints constraints) {
      double height = constraints.maxHeight;
      return Container(
        constraints: BoxConstraints(maxHeight: height * 0.7),
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 24),
        child: SizedBox(
          width: double.infinity,
          child: child,
        ),
      );
    });
  }
}

class _ModalDateTime extends StatefulWidget {
  final DateTime? value;
  final ValueChanged<DateTime?> onChanged;
  final CupertinoDatePickerMode mode;
  final DateTime? max;
  final DateTime? min;

  const _ModalDateTime({
    Key? key,
    this.value,
    required this.onChanged,
    this.mode = CupertinoDatePickerMode.date,
    this.max,
    this.min,
  }) : super(key: key);

  @override
  State<_ModalDateTime> createState() => _ModalDateTimeState();
}

class _ModalDateTimeState extends State<_ModalDateTime> {
  late DateTime? _date;

  @override
  void initState() {
    _date = widget.value;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Flexible(
          child: SingleChildScrollView(
            child: SizedBox(
              height: 200,
              child: CupertinoDatePicker(
                mode: widget.mode,
                initialDateTime: _date,
                onDateTimeChanged: (DateTime newDateTime) => setState(() {
                  _date = newDateTime;
                }),
                minimumDate: widget.min,
                maximumDate: widget.max,
              ),
            ),
          ),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: SizedBox(
                height: 48,
                child: ElevatedButton(
                  onPressed: () => widget.onChanged(null),
                  style: ElevatedButton.styleFrom(
                    foregroundColor: theme.textTheme.titleSmall?.color,
                    backgroundColor: theme.colorScheme.surface,
                  ),
                  child: Text("Cancel"),
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: SizedBox(
                height: 48,
                child: ElevatedButton(
                  onPressed: () => widget.onChanged(_date),
                  child: Text("OK"),
                ),
              ),
            ),
          ],
        )
      ],
    );
  }
}