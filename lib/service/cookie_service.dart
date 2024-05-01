import 'package:cirilla/constants/app.dart';
import 'package:cirilla/utils/debug.dart';
import 'package:cirilla/webview_flutter.dart';
import 'package:cookie_jar/cookie_jar.dart';

import 'helpers/persist_helper.dart';

const String tokenCookieName = 'cirilla_auth_token';

class CookieService {

  late final WebViewCookieManager _webViewCookieManager;
  final PersistHelper _persistHelper;
  late final PersistCookieJar _persistCookieJar;

  CookieService(this._persistHelper) {
    _webViewCookieManager = WebViewCookieManager();
    _persistCookieJar = PersistCookieJar(
      ignoreExpires: true,
      storage: FileStorage("${_persistHelper.getString('appDocDir')}/.cookies/"),
    );
  }

  PersistCookieJar get persistCookieJar => _persistCookieJar;
  WebViewCookieManager get webViewCookieManager => _webViewCookieManager;

  /// Clear persisted cookies
  Future<void> clearPersistedCookies() async {
    await _persistCookieJar.delete(Uri.parse(baseUrl));
  }

  /// Set user token as cookie
  Future<void> setToken(String token) async {
    Uri url = Uri.parse(baseUrl);
    await _webViewCookieManager.setCookie(
      WebViewCookie(
        name: tokenCookieName,
        value: token,
        domain: url.host,
        path: '/',
      ),
    );
  }

  /// Clean webview cookies
  Future<bool> clearWebviewCookie() async {
    final bool hadCookies = await _webViewCookieManager.clearCookies();
    String message = 'There were cookies. Now, they are gone!';
    if (!hadCookies) {
      message = 'There are no cookies.';
    }
    avoidPrint("CookieService.removeToken: $message");
    return hadCookies;
  }
}