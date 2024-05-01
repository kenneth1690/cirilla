class TextDynamic {
  static RegExp exp = RegExp(r"\{\{(.*?)\}\}");

  static String replace(txt, Map<String, String?> options) => txt.replaceAllMapped(exp, (Match m) {
    if (options.isEmpty) return m.group(0) ?? '';
    if (m.group(0) == null || m.group(1) == null) return '';
    return options[m.group(1)] ?? m.group(0) ?? '';
  });

  static String getTextDynamic({required String text, required Map<String, dynamic> options}) {
    return replace(text, {
      'user_login': options["user_login"] is String ? options["user_login"]: "",
      'user_email': options["user_email"] is String ? options["user_email"]: "",
      'user_url': options["user_url"] is String ? options["user_url"]: "",
      'user_first_name': options["first_name"] is String ? options["first_name"]: "",
      'user_last_name': options["last_name"] is String ? options["last_name"]: "",
      'user_nickname': options["user_nicename"] is String ? options["user_nicename"]: "",
      'user_display_name': options["display_name"] is String ? options["display_name"]: "",
    });
  }
}
