class ConvertData {

  static bool? toBoolValue(dynamic value) {
    if (value is bool) {
      return value;
    }

    if (value == "true" || value == 1 || value == "1" || value == "yes") {
      return true;
    }

    if (value == "false" || value == 0 || value == "0" || value == "no") {
      return false;
    }
    return null;
  }
}
