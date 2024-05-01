class OptionValueModel {
  final Map<int, String> value;
  final bool multi;

  OptionValueModel({
    required this.value,
    this.multi = true,
  });

  dynamic toValue() => _$ValueOption(this);
  String toKeys() => _$KeyOption(this);
}

dynamic _$ValueOption(OptionValueModel instance) {
  if (instance.multi) {
    return instance.value.values.toList();
  }
  return instance.value.values.toList().firstOrNull ?? "";
}

String _$KeyOption(OptionValueModel instance) {
  if (instance.multi) {
    return instance.value.keys.toList().join("_");
  }
  return instance.value.keys.toList().firstOrNull?.toString() ?? "";
}