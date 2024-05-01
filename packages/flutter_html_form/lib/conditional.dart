import 'models/option_value.dart';

bool checkShowField(Map<String, dynamic> data, Map<String, dynamic> attributes) {
  String keyConditional = attributes["data-key"] ?? "";
  String valueConditional = attributes["data-value"] ?? "";
  if (keyConditional.isNotEmpty) {
    if (data[keyConditional] is OptionValueModel) {
      OptionValueModel value = data[keyConditional];
      return value.value.values.toList().contains(valueConditional);
    }
    return data[keyConditional] == valueConditional;
  }
  return true;
}
