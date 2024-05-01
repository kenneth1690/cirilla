import 'package:cirilla/constants/styles.dart';
import 'package:cirilla/mixins/mixins.dart';
import 'package:cirilla/store/auth/auth_store.dart';
import 'package:cirilla/store/cart/cart_store.dart';
import 'package:cirilla/types/types.dart';
import 'package:cirilla/utils/app_localization.dart';
import 'package:cirilla/widgets/cirilla_webview.dart';
import 'package:feather_icons/feather_icons.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ui/notification/notification_screen.dart';

class OrderReceived extends StatefulWidget {
  final String? url;

  const OrderReceived({Key? key, this.url}) : super(key: key);

  @override
  State<OrderReceived> createState() => _OrderReceivedState();
}

class _OrderReceivedState extends State<OrderReceived> with NavigationMixin, AppBarMixin {
  late CartStore _cartStore;
  late AuthStore _authStore;

  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();
    _authStore = Provider.of<AuthStore>(context);
    _cartStore = _authStore.cartStore;
    await _cartStore.cleanCart();
    await _cartStore.getCart();
  }

  @override
  Widget build(BuildContext context) {
    TranslateType translate = AppLocalizations.of(context)!.translate;
    return Scaffold(
      appBar: baseStyleAppBar(context, title: translate('order_info')),
      body: buildNotification(context),
    );
  }

  Widget buildNotification(BuildContext context) {
    TranslateType translate = AppLocalizations.of(context)!.translate;

    if (widget.url?.isNotEmpty == true) {
      String qr = widget.url!.contains('?') ? '&' : '?';
      String orderDetailUrl = '${widget.url}${qr}app-builder-checkout-body-class=app-builder-checkout&app-builder-decode=true';

      Map<String, String> headers = {};
      if (_authStore.isLogin) {
        headers = {"Authorization": "Bearer ${_authStore.token!}"};
      }

      return Column(
        children: [
          Expanded(
            child: CirillaWebView(
              uri: Uri.parse(orderDetailUrl),
              isLoading: false,
              headers: headers,
            ),
          ),
          Padding(
            padding: paddingDefault,
            child: SizedBox(
              height: 48,
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => navigate(context, {
                  "type": "tab",
                  "router": "/",
                  "args": {"key": "screens_category"}
                }),
                child: Text(translate('order_return_shop')),
              ),
            ),
          )
        ],
      );
    }

    return NotificationScreen(
      title: Text(translate('order_congrats'), style: Theme.of(context).textTheme.titleLarge),
      content: Text(
        translate('order_thank_you_purchase'),
        style: Theme.of(context).textTheme.bodyMedium,
        textAlign: TextAlign.center,
      ),
      iconData: FeatherIcons.check,
      textButton: Text(translate('order_return_shop')),
      onPressed: () => navigate(context, {
        "type": "tab",
        "router": "/",
        "args": {"key": "screens_category"}
      }),
    );
  }
}
