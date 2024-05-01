import 'package:flutter/material.dart';

import '../convert.dart';

double _getDefaultValue(String? defaultValue, double min, double max) {
  double? dataValue = convertStringToDoubleCanBeNull(defaultValue);
  if (dataValue != null) {
    if (min > dataValue) {
      return min;
    }
    if (dataValue > max) {
      return max;
    }
    return dataValue;
  }
  return (max+min)/2;
}

int _getDivisions(String? defaultStep, double min, double max) {
  double dataValue = convertStringToDoubleCanBeNull(defaultStep) ?? 1;
  if ((max - min) >= dataValue) {
    return (max - min)~/dataValue;
  }
  return 1;
}

int _getDecimalsCount(double min, double max) {
  int decimalsMin = (min.toString()).contains(".") ? (min.toString()).split(".")[1].length: 0;
  int decimalsMax = (min.toString()).contains(".") ? (min.toString()).split(".")[1].length: 0;
  return decimalsMax > decimalsMin ? decimalsMax : decimalsMin;
}

class RangeField extends StatelessWidget {
  final String? value;
  final ValueChanged<dynamic> onChange;
  final Map<String, String> attributes;

  const RangeField({
    Key? key,
    this.value,
    required this.onChange,
    required this.attributes,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double defaultMin = convertStringToDoubleCanBeNull(attributes["min"]) ?? 0;
    double defaultMax = convertStringToDoubleCanBeNull(attributes["max"]) ?? 100;

    double min = defaultMax < defaultMin ? defaultMax : defaultMin;
    double max = defaultMax < defaultMin ? defaultMin : defaultMax;

    double defaultValue = _getDefaultValue(attributes["value"], min, max);
    double? numberValue = convertStringToDoubleCanBeNull(value);

    int divisions = _getDivisions(attributes["step"], min, max);

    /// Update only if this widget initialized.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (numberValue == null) {
        onChange(defaultValue.toString());
      }
    });

    int decimalsCount  = _getDecimalsCount(min, max);

    return Slider(
      value: numberValue ?? defaultValue,
      min: min,
      max: max,
      divisions: divisions,
      label: (numberValue ?? defaultValue).toStringAsFixed(decimalsCount),
      onChanged: (double value) => onChange(value.toString()),
    );
  }
}