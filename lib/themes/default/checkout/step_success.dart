import 'package:cirilla/constants/constants.dart';
import 'package:cirilla/mixins/mixins.dart';
import 'package:cirilla/store/auth/auth_store.dart';
import 'package:cirilla/store/cart/cart_store.dart';
import 'package:cirilla/types/types.dart';
import 'package:cirilla/utils/utils.dart';
import 'package:feather_icons/feather_icons.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ui/notification/notification_screen.dart';
import 'package:cirilla/widgets/cirilla_webview.dart';

class StepSuccess extends StatefulWidget {
  final String? url;
  final String? titleButton;
  final void Function()? onClickButton;

  const StepSuccess({Key? key, this.url, this.titleButton, this.onClickButton}) : super(key: key);

  @override
  State<StepSuccess> createState() => _StepSuccessState();
}

class _StepSuccessState extends State<StepSuccess> with NavigationMixin {

  late CartStore _cartStore;
  late AuthStore _authStore;

  bool loading = true;

  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();
    _authStore = Provider.of<AuthStore>(context);
    _cartStore = _authStore.cartStore;
   _cleanCart();
  }

  Future<void> _cleanCart() async {
    setState(() {
      loading = true;
    });
    try {
      await _cartStore.cleanCart();
      await _cartStore.getCart();
    } catch (e) {
      avoidPrint(e);
    } finally {
      setState(() {
        loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    TranslateType translate = AppLocalizations.of(context)!.translate;

    if (loading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (widget.url?.isNotEmpty == true) {
      String qr = widget.url!.contains('?') ? '&' : '?';

      return Column(
        children: [
          Expanded(
            child: CirillaWebView(
              uri: Uri.parse('${widget.url}${qr}app-builder-checkout-body-class=app-builder-checkout'),
              isLoading: false,
            ),
          ),
          Padding(
            padding: paddingDefault,
            child: SizedBox(
              height: 48,
              width: double.infinity,
              child: ElevatedButton(
                onPressed: widget.onClickButton ?? () => navigate(context, {
                  "type": "tab",
                  "router": "/",
                  "args": {"key": "screens_category"}
                }),
                child: Text(widget.titleButton ?? translate('order_return_shop')),
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
      textButton: Text(widget.titleButton ?? translate('order_return_shop')),
      onPressed: widget.onClickButton ?? () => navigate(context, {
        "type": "tab",
        "router": "/",
        "args": {"key": "screens_category"}
      }),
    );
  }
}
