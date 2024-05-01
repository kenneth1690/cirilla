dynamic getData(dynamic data, List<dynamic> paths, [defaultValue]) {
  if (data == null || (paths.isNotEmpty && !(data is Map || data is List))) return defaultValue;
  if (paths.isEmpty) return data ?? defaultValue;
  List<dynamic> newPaths = List.of(paths);
  String? key = newPaths.removeAt(0);
  return getData(data[key], newPaths, defaultValue);
}
