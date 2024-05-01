import 'package:cirilla/store/store.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class NavigatorHistory extends NavigatorObserver {
  SettingStore get settingStore => Provider.of<SettingStore>(navigator!.context, listen: false);

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    if ('/' == route.settings.name) {
      settingStore.removeTab();
    }
  }
}