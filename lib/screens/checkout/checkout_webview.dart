import 'package:cirilla/constants/app.dart';
import 'package:cirilla/constants/constants.dart';
import 'package:cirilla/constants/currencies.dart';
import 'package:cirilla/mixins/mixins.dart';
import 'package:cirilla/screens/checkout/order_received.dart';
import 'package:cirilla/service/cookie_service.dart';
import 'package:cirilla/store/auth/auth_store.dart';
import 'package:cirilla/store/setting/setting_store.dart';
import 'package:cirilla/types/types.dart';
import 'package:cirilla/utils/app_localization.dart';
import 'package:cirilla/utils/debug.dart';
import 'package:cirilla/widgets/cirilla_webview.dart';
import 'package:cookie_jar/cookie_jar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/provider.dart';
import 'package:cirilla/webview_flutter.dart';

class CheckoutWebView extends StatefulWidget {
  static const routeName = '/checkout-webview';

  const CheckoutWebView({Key? key}) : super(key: key);

  @override
  State<CheckoutWebView> createState() => _CheckoutWebViewState();
}

class _CheckoutWebViewState extends State<CheckoutWebView> with TransitionMixin, AppBarMixin {
  late SettingStore _settingStore;
  late AuthStore _authStore;

  @override
  void didChangeDependencies() {
    _settingStore = Provider.of<SettingStore>(context);
    _authStore = Provider.of<AuthStore>(context);
    _loadCookie();
    super.didChangeDependencies();
  }

  void navigateOrderReceived(BuildContext context, String url) {
    Navigator.of(context).pushReplacement(PageRouteBuilder(
      pageBuilder: (context, _, __) => OrderReceived(url: url),
      transitionsBuilder: slideTransition,
    ));
  }

  Future<bool> _loadCookie() async {
    // Init cookie service
    CookieService cookieService = CookieService(_settingStore.persistHelper);
    // Clear webview cookie
    await cookieService.clearWebviewCookie();
    // Init webview cookie manager
    final WebViewCookieManager cookieManager = WebViewCookieManager();
    Uri url = Uri.parse(baseUrl);
    if (_authStore.isLogin) {
      await cookieManager.setCookie(
        WebViewCookie(
          name: 'cirilla_auth_token',
          value: _authStore.token ?? '',
          domain: url.host,
          path: '/',
        ),
      );
    } else {
      final cj = cookieService.persistCookieJar;
      List<Cookie> results = await cj.loadForRequest(Uri.parse(baseUrl));
      if (results.isNotEmpty) {
        int i = 0;
        Future.doWhile(() async {
          Cookie cookie = results[i];
          await cookieManager.setCookie(
            WebViewCookie(
              name: cookie.name,
              value: Uri.decodeComponent(cookie.value),
              domain: url.host,
              path: '/',
            ),
          );
          i++;
          return i < results.length;
        });
      }
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Observer(builder: (_) {
      Map<String, String?> queryParams = {
        'app-builder-checkout-body-class': 'app-builder-checkout',
        if (_settingStore.languageKey != "text") 'lang': _settingStore.locale,
        if (_settingStore.isCurrencyChanged) CURRENCY_PARAM: _settingStore.currency,
      };

      Uri checkoutUri = Uri.parse(_settingStore.checkoutUrl ?? '');

      TranslateType translate = AppLocalizations.of(context)!.translate;
      return Scaffold(
        appBar: baseStyleAppBar(context, title: translate('cart_checkout')),
        body: Builder(builder: (BuildContext context) {
          return Padding(
              padding: const EdgeInsets.only(top: layoutPadding),
              child: FutureBuilder<bool>(
                future: _loadCookie(),
                builder: (context, snapshot) {
                  if (snapshot.hasData && snapshot.data == true) {
                    return CirillaWebView(
                      uri: Uri(
                        scheme: checkoutUri.scheme,
                        host: checkoutUri.host,
                        port: checkoutUri.port,
                        path: checkoutUri.path,
                        queryParameters: queryParams,
                      ),
                      onNavigationRequest: (NavigationRequest request) {
                        avoidPrint(request.url);

                        if (request.url.contains('/order-received/')) {
                          navigateOrderReceived(context, request.url);
                        }

                        if (request.url.contains('/cart/')) {
                          Navigator.of(context).pop();
                          return NavigationDecision.navigate;
                        }

                        if (request.url.contains('/my-account/')) {
                          return NavigationDecision.prevent;
                        }

                        return NavigationDecision.navigate;
                      },
                      onPageStarted: (String url) {
                        if (url.contains('/order-received/')) {
                          navigateOrderReceived(context, url);
                        }
                        avoidPrint('Page started loading: $url');
                      },
                    );
                  }
                  return Container();
                },
              ));
        }),
      );
    });
  }
}
