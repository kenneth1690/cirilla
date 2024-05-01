import 'dart:convert';

import 'package:awesome_drawer_bar/awesome_drawer_bar.dart';
import 'package:cirilla/constants/strings.dart';
import 'package:cirilla/screens/home/home.dart';
import 'package:cirilla/rest_api_client/rest_api_client.dart';
import 'package:cirilla/rest_api_client/rest_api_message.dart';
import 'package:cirilla/store/store.dart';
import 'package:cirilla/utils/form_field_validator.dart';
import 'package:cirilla/utils/url_launcher.dart';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:in_app_review/in_app_review.dart';
import 'package:provider/provider.dart';
import 'package:share/share.dart';

import '../register_actions.dart';
import 'utility_mixin.dart' show get;

Map<String, String?> _convertDataUser(Map<String, dynamic>? user) {
  Map<String, String?> result = {};

  if (user != null) {
    for (var key in user.keys.toList()) {
      dynamic value = user[key];
      if (value is String?) {
        result[key] = value;
        continue;
      }
      if (value is bool || value is int || value is double) {
        result[key] = value.toString();
      }
    }
  }

  return result;
}

class NavigationMixin {
  static const typeTab = 'tab';
  static const typeLauncher = 'launcher';
  static const typeShare = 'share';
  static const typeRate = 'rate';
  static const typeLogout = 'logout';
  static const typeRestApi = 'rest-api';

  /// Handle navigate in app
  Future<dynamic>? navigate(BuildContext context, Map<String, dynamic>? dataAction,
      [Map<String, String?>? data]) async {
    SettingStore settingStore = Provider.of<SettingStore>(context, listen: false);
    Map<String, dynamic>? action = dataAction;

    // User changed language
    if (settingStore.languageKey != 'text') {
      action = get(dataAction, [settingStore.locale], dataAction);
    }

    String? type = get(action, ['type'], 'tab');
    if (action == null || type == 'none') return;

    String? route = get(action, ['route'], '/');
    if (route == 'none') return;

    switch (type) {
      case typeTab:
        _openTab(context, action);
        break;
      case typeLauncher:
        _openLauncher(context, action);
        break;
      case typeRate:
        _openRate(context, action);
        break;
      case typeShare:
        _openShare(context, action);
        break;
      case typeLogout:
        _openLogout(context, action);
        break;
      case typeRestApi:
        return _restApi(context, action, (data ?? {}).cast<String, String?>());
      default:
        _openOther(context, action);
    }
  }

  /// Handle open tab
  ///
  void _openTab(BuildContext context, Map<String, dynamic>? action) async {
    String? tab = get(action, ['args', 'key'], Strings.tabActive);
    SettingStore store = Provider.of<SettingStore>(context, listen: false);
    store.setTab(tab);
    // Navigator.popUntil(context, ModalRoute.withName(HomeScreen.routeName));
    Navigator.of(context).pushNamed(HomeScreen.routeName);
    if (AwesomeDrawerBar.of(context) != null && AwesomeDrawerBar.of(context)!.isOpen()) {
      AwesomeDrawerBar.of(context)!.toggle();
    }
  }

  /// Handle logout
  ///
  void _openLogout(BuildContext context, Map<String, dynamic>? action) async {
    AuthStore store = Provider.of<AuthStore>(context, listen: false);
    await store.logout();
  }

  /// Handle open link
  ///
  void _openLauncher(BuildContext context, Map<String, dynamic>? action) async {
    Map<String, dynamic> args = get(action, ['args'], {});
    String url = get(args, ['url'], '/');
    launch(url);
  }

  /// Handle open share
  ///
  void _openShare(BuildContext context, Map<String, dynamic>? action) async {
    Map<String, dynamic> args = get(action, ['args'], {});
    String content = get(args, ['content'], '');
    String? subject = get(args, ['subject'], null);
    Share.share(content, subject: subject);
  }

  /// Handle rate app
  ///
  void _openRate(BuildContext context, Map<String, dynamic>? action) async {
    Map<String, dynamic> args = get(action, ['args'], {});
    final InAppReview inAppReview = InAppReview.instance;
    if (await inAppReview.isAvailable()) {
      String appStoreId = get(args, ['appStoreId'], '');
      String microsoftStoreId = get(args, ['microsoftStoreId'], '');
      inAppReview.openStoreListing(
        appStoreId: appStoreId,
        microsoftStoreId: microsoftStoreId,
      );
    }
  }

  /// Handle open other link
  ///
  void _openOther(BuildContext context, Map<String, dynamic>? action) async {
    String route = get(action, ['route'], '/');
    if (route == 'none') return;

    Map<String, dynamic> args = get(action, ['args'], {});

    if ((route == '/product' || route == '/post' || route == '/order_detail') && args['id'] != null) {
      route = '$route/${args['id']}';
    }

    /// Register actions
    route = await registerActions(route, context, action);
    if (route == 'none' || !context.mounted) return;

    Navigator.of(context).pushNamed(route, arguments: args);
  }

  /// Handle rest Api
  ///
  void _restApi(BuildContext context, Map<String, dynamic>? action, Map<String, String?> data) async {
    AuthStore authStore = Provider.of<AuthStore>(context, listen: false);
    Map<String, dynamic> args = get(action, ['args'], {});
    String messages = args["messages"] is String ? args["messages"] : "";

    Map<String, String?> dataGlobal = {
      ..._convertDataUser(authStore.user?.toJson()),
      "token": authStore.token ?? "",
    };

    List dataMessages = isJSON(messages) ? jsonDecode(messages) : [];

    try {
      await restIpiClient(args: args, data: data, dataGlobal: dataGlobal).then((Response value) {
        restIpiShowMessage(context, value, dataMessages);
      });
    } on DioException catch (e) {
      if (context.mounted && e.response != null) restIpiShowMessage(context, e.response!, dataMessages);
    }
  }
}