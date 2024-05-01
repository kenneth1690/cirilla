class OptionDataModel {
  final List<String> options;
  final List<String>? imageOptions;
  final List<int> defaultValues;

  OptionDataModel({
    required this.options,
    required this.defaultValues,
    this.imageOptions,
  });
}