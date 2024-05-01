import 'package:flutter/material.dart';

/// Define script codes supports
const List<String> scriptCodes = ['Hans', 'Hant'];

/// Language string to locate
///
/// Ex:
///
/// en => Locale.fromSubtags(languageCode: 'en')
///
/// zh_Hant_HK => Locale.fromSubtags(languageCode: 'zh', scriptCode: 'Hant',countryCode: 'HK')
///
Locale stringToLocale(String locale) {
  List<String> locales = locale.split('_');
  if (locales.length == 1) {
    return Locale.fromSubtags(languageCode: locales[0]);
  }
  if (locales.length == 2) {
    if (scriptCodes.contains(locales[1])) {
      return Locale.fromSubtags(languageCode: locales[0], scriptCode: locales[1]);
    }
    return Locale.fromSubtags(languageCode: locales[0], countryCode: locales[1]);
  }
  return Locale.fromSubtags(languageCode: locales[0], scriptCode: locales[1], countryCode: locales[2]);
}
