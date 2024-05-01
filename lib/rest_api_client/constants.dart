RegExp expTextForm = RegExp(r"\[(.*?)\]");
RegExp expText = RegExp(r"\{(.*?)\}");

String replaceText(txt, RegExp reg, Map<String, String?> options) => txt.replaceAllMapped(reg, (Match m) {
  if (options.isEmpty) return m.group(0) ?? '';

  if (m.group(0) == null || m.group(1) == null) return '';

  return options[m.group(1)] ?? m.group(0) ?? '';
});