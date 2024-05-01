import 'package:flutter/material.dart';

import '../convert.dart';

String _getStringCount(double value) {
  return value == value.toInt() ? value.toStringAsFixed(0): value.toString();
}

class NumberField extends StatefulWidget {
  final String? value;
  final ValueChanged<dynamic> onChange;
  final Map<String, String> attributes;

  const NumberField({
    Key? key,
    this.value,
    required this.onChange,
    required this.attributes,
  }) : super(key: key);

  @override
  State<NumberField> createState() => _NumberFieldState();
}

class _NumberFieldState extends State<NumberField> {
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

  void onMinus(double? value, double step, double? min, double? max) {
    if (value == null) {
      if (min != null) {
        _controller.text = _getStringCount(min);
        return;
      }
      double data = max != null && max < -step ? max : -step;
      _controller.text = _getStringCount(data);
      return;
    }
    double data = max != null && max < value - step ? max : value - step;
    _controller.text = _getStringCount(data);
  }

  void onPlus(double? value, double step, double? min, double? max) {
    if (value == null) {
      if (max != null) {
        _controller.text = _getStringCount(max);
        return;
      }
      double data = min != null && min > step ? min : step;
      _controller.text = _getStringCount(data);
      return;
    }
    double data = min != null && min > value + step ? min : value + step;
    _controller.text = _getStringCount(data);
  }

  @override
  Widget build(BuildContext context) {
    String placeholder = widget.attributes["placeholder"] ?? "";
    bool required = convertToBool(widget.attributes["required"]) ?? false;

    double? defaultMin = convertStringToDoubleCanBeNull(widget.attributes["min"]);
    double? defaultMax = convertStringToDoubleCanBeNull(widget.attributes["max"]);

    double? min = defaultMin != null && defaultMax != null && defaultMax < defaultMin ? defaultMax : defaultMin;
    double? max = defaultMin != null && defaultMax != null &&  defaultMax < defaultMin ? defaultMin : defaultMax;

    String defaultValue = widget.attributes["value"] ?? "";

    double step = convertStringToDoubleCanBeNull(widget.attributes["step"]) ?? 1;

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

    double? value = convertStringToDoubleCanBeNull(widget.value);

    return TextFormField(
      controller: _controller,
      validator: (String? value) {
        if (required && value?.isNotEmpty != true) {
          return "Required";
        }
        double? numberData = convertStringToDoubleCanBeNull(value);
        if (numberData != true) {
          if (min != null && numberData! < min) {
            return "This field has a too small number.";
          }
          if (max != null && numberData! > max) {
            return "This field has a too large number.";
          }
        }
        return null;
      },
      decoration: InputDecoration(
        hintText: placeholder,
        prefixIcon: _Button(
          icon: Icons.remove_rounded,
          onPressed: min == null || ((value == null || value - step >= min)) ? () => onMinus(value, step, min, max) : null,
        ),
        suffixIcon: _Button(
          icon: Icons.add_rounded,
          onPressed: max == null || ((value == null || value + step <= max))  ? () => onPlus(value, step, min, max) : null,
        ),
      ),
      keyboardType: TextInputType.number,
      textAlignVertical: TextAlignVertical.center,
      textAlign: TextAlign.center,
    );
  }
}

class _Button extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onPressed;

  const _Button({
    required this.icon,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 35,
      alignment: Alignment.center,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          fixedSize: Size(35, 35),
          minimumSize: Size(35, 35),
          maximumSize: Size(35, 35),
          padding: EdgeInsets.zero,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(35)),
          ),
        ),
        child: Icon(icon, size: 18),
      ),
    );
  }
}
