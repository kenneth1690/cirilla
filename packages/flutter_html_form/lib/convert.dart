/// Convert any value to bool or null
bool? convertToBool(dynamic value) {
  if (value is bool) {
    return value;
  }

  if (value == "" || value == "true" || value == 1 || value == "1") {
    return true;
  }

  if (value == "false" || value == 0 || value == "0") {
    return false;
  }

  return null;
}

double? convertStringToDoubleCanBeNull(dynamic value, [double? defaultValue]) {
  if (value == null || value == "") {
    return defaultValue;
  }

  if (value is int) {
    return value.toDouble();
  }

  if (value is double) {
    return value;
  }

  if (value is String) {
    return double.tryParse(value) ?? defaultValue;
  }

  return defaultValue;
}

int? convertStringToIntCanBeNull(dynamic value, [int? defaultValue]) {
  if (value == null || value == "") {
    return defaultValue;
  }

  if (value is double) {
    return value.toInt();
  }

  if (value is int) {
    return value;
  }

  if (value is String) {
    return int.tryParse(value) ?? defaultValue;
  }

  return defaultValue;
}