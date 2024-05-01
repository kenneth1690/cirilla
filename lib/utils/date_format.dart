import 'package:cirilla/types/types.dart';
import 'package:cirilla/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:timeago/timeago.dart' as timeago;

String formatDate({required String date, String dateFormat = 'MMMM d, y', String locate = 'en_US'}) {
  DateTime newDate = DateTime.parse(date);
  return DateFormat(dateFormat, locate).format(newDate);
}

bool compareSpaceDate({required String date, int space = 30}) {
  DateTime newDateNow = DateTime.now();
  DateTime newDate = DateTime.parse(date).add(Duration(days: space));
  return !newDateNow.isAfter(newDate);
}

String? formatPosition({Duration? position}) {
  return RegExp(r'((^0*[1-9]\d*:)?\d{2}:\d{2})\.\d+$').firstMatch(position.toString())?.group(1);
}

String getLocate(BuildContext context) {
  final Locale appLocale = Localizations.localeOf(context);
  return appLocale.toString();
}

String dateAgo(BuildContext context, {DateTime? date}) {
  DateTime newDate = date ?? DateTime.now();

  String locale = getLocate(context);
  TranslateType translate = AppLocalizations.of(context)!.translate;
  timeago.setLocaleMessages("${locale}_trans", _LocaleMessages(translate: translate));
  return timeago.format(newDate, locale: "${locale}_trans");
}

class _LocaleMessages implements timeago.LookupMessages {
  final TranslateType translate;
  _LocaleMessages({
    required this.translate,
  });

  @override
  String prefixAgo() => '';
  @override
  String prefixFromNow() => '';
  @override
  String suffixAgo() => translate("timeago_ago");
  @override
  String suffixFromNow() => translate("timeago_from_now");
  @override
  String lessThanOneMinute(int seconds) => translate("timeago_less_a_minute");
  @override
  String aboutAMinute(int minutes) => translate("timeago_a_minute");
  @override
  String minutes(int minutes) => translate("timeago_minutes", {"minutes": minutes.toString()});
  @override
  String aboutAnHour(int minutes) => translate("timeago_an_hour");
  @override
  String hours(int hours) => translate("timeago_hours", {"hours": hours.toString()});
  @override
  String aDay(int hours) => translate("timeago_a_day");
  @override
  String days(int days) => translate("timeago_days", {"days": days.toString()});
  @override
  String aboutAMonth(int days) => translate("timeago_a_month");
  @override
  String months(int months) => translate("timeago_months", {"months": months.toString()});
  @override
  String aboutAYear(int year) => translate("timeago_a_year");
  @override
  String years(int years) => translate("timeago_years", {"years": years.toString()});
  @override
  String wordSeparator() => ' ';
}