import 'package:cirilla/constants/constants.dart';
import 'package:cirilla/mixins/cart_mixin.dart';
import 'package:cirilla/mixins/mixins.dart';
import 'package:cirilla/models/cart/cart.dart';
import 'package:cirilla/models/models.dart';
import 'package:cirilla/screens/cart/widgets/cart_coupon.dart';
import 'package:cirilla/screens/cart/widgets/cart_items.dart';
import 'package:cirilla/screens/cart/widgets/cart_shipping.dart';
import 'package:cirilla/screens/screens.dart';
import 'package:cirilla/service/constants/endpoints.dart';
import 'package:cirilla/store/store.dart';
import 'package:cirilla/utils/debug.dart';
import 'package:cirilla/widgets/cirilla_express_checkout.dart';
import 'package:cirilla/widgets/widgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/provider.dart';
import 'package:cirilla/types/types.dart';
import 'package:cirilla/utils/app_localization.dart';
import 'package:cirilla/utils/url_launcher.dart';

import 'widgets/cart_total.dart';

class CartBody extends StatefulWidget {
  final AppBar Function(bool enableCount, int count)? onBuilderAppbar;
  final Widget Function(bool disable)? onBuilderButtonCheckout;
  final Widget emptyChild;

  const CartBody({Key? key, this.onBuilderAppbar, required this.emptyChild, this.onBuilderButtonCheckout}) : super(key: key);

  @override
  CartBodyState createState() => CartBodyState();
}

class CartBodyState extends State<CartBody>
    with LoadingMixin, Utility, CartMixin, SnackMixin, NavigationMixin, AppBarMixin, GeneralMixin {
  final ScrollController _controller = ScrollController();
  final GlobalKey<SliverAnimatedListState> _listKey = GlobalKey<SliverAnimatedListState>();
  TextEditingController myController = TextEditingController();
  late CartStore _cartStore;
  late SettingStore _settingStore;
  bool enableKey = false;
  List<CartItem>? _items = List<CartItem>.of([]);

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _cartStore = Provider.of<AuthStore>(context).cartStore..getCart(false);
    _settingStore = Provider.of<SettingStore>(context);
  }

  @override
  void dispose() {
    super.dispose();
  }

  updateQuantity(CartItem cartItem, int value, int index) {
    _cartStore.updateQuantity(key: cartItem.key, quantity: value, index: index);
  }

  Future<void> onRemoveItem(BuildContext context, CartItem cartItem, int index) async {
    _listKey.currentState!.removeItem(index, (_, animation) {
      return SizeTransition(
        sizeFactor: animation,
        child: Item(
          cartItem: cartItem,
          updateQuantity: (CartItem cartItem, int value) {
            avoidPrint('removed');
          },
        ),
      );
    }, duration: const Duration(milliseconds: 250));
    _items!.removeAt(index);
    try {
      await _cartStore.removeCart(key: cartItem.key);
    } catch (e) {
      if (context.mounted) showError(context, e);
    }
  }

  void _checkoutLaunch(BuildContext context) {
    AuthStore authStore = Provider.of<AuthStore>(context, listen: false);
    SettingStore settingStore = Provider.of<SettingStore>(context, listen: false);
    Map<String, String?> queryParams = {
      'cart_key_restore': _cartStore.cartKey!,
      'app-builder-checkout-body-class': 'app-builder-checkout'
    };

    if (authStore.isLogin) {
      queryParams.putIfAbsent('app-builder-decode', () => 'true');
      queryParams.putIfAbsent('app-builder-token', () => authStore.token);
    }

    if (settingStore.isCurrencyChanged) {
      queryParams.putIfAbsent('currency', () => settingStore.currency);
    }

    if (settingStore.languageKey != "text") {
      queryParams.putIfAbsent(authStore.isLogin ? '_lang' : 'lang', () => settingStore.locale);
    }

    String url = authStore.isLogin ? Endpoints.restUrl + Endpoints.loginToken : settingStore.checkoutUrl!;

    String checkoutUrl = "$url?${Uri(queryParameters: queryParams).query}";
    launch(checkoutUrl);
  }

  void _checkout(BuildContext context) {
    AuthStore authStore = Provider.of<AuthStore>(context, listen: false);
    SettingStore settingStore = Provider.of<SettingStore>(context, listen: false);

    if (getConfig(settingStore, ['forceLoginCheckout'], false) && !authStore.isLogin) {
      Navigator.of(context).pushNamed(
        LoginScreen.routeName,
        arguments: {
          'showMessage': ({String? message}) {
            avoidPrint('Login Success');
          }
        },
      );
    } else {
      if (isWeb) {
        _checkoutLaunch(context);
      } else {
        Navigator.of(context).pushNamed(
          getConfig(settingStore, ['customCheckout'], false) ? Checkout.routeName : CheckoutWebView.routeName,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Observer(builder: (_) {
      CartData? cartData = _cartStore.cartData;

      if (_items != cartData?.items) {
        _items = cartData?.items;
      }

      enableKey = !_cartStore.loadingAddCart;

      bool isEmpty = cartData == null || _items?.isEmpty == true;

      Widget child = Stack(
        children: [
          if (!isEmpty) buildContent(),
          if (isEmpty) widget.emptyChild,
          if (_cartStore.loadingRemoveCart || _cartStore.loadingShipping || _cartStore.loadingCoupon)
            Align(
              alignment: FractionalOffset.center,
              child: buildLoadingOverlay(context),
            ),
        ],
      );

      if (widget.onBuilderAppbar == null) {
        return child;
      }

      return Scaffold(
        appBar: widget.onBuilderAppbar!(!isEmpty, _items?.length ?? 0),
        body: child,
      );
    });
  }

  Future<void> buildDialog(BuildContext context, TranslateType translate) async {
    String? result = await showDialog<String>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: Text(translate('cart_delete_dialog_title')),
        content: Text(translate('cart_delete_dialog_description')),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.pop(context, 'Cancel'),
            child: Text(translate('cart_delete_dialog_cancel')),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, 'OK'),
            child: Text(translate('cart_delete_dialog_ok')),
          ),
        ],
      ),
    );
    if (result == "OK") {
      await _cartStore.cleanCart();
    }
  }

  Widget buildContent() {
    int? count = _items?.length;
    bool loading = _cartStore.loading;
    return CustomScrollView(
      physics: const BouncingScrollPhysics(),
      controller: _controller,
      slivers: <Widget>[
        CupertinoSliverRefreshControl(
          onRefresh: _cartStore.getCart,
          builder: buildAppRefreshIndicator,
        ),
        if (_cartStore.cartData?.errors?.isNotEmpty == true) ..._buildErrorMessages(_cartStore.cartData!.errors!),
        SliverAnimatedList(
          key: enableKey && !loading ? _listKey : Key('$count'),
          itemBuilder: (context, index, animation) {
            CartItem? cartItem = _items?[index];
            if (cartItem == null) {
              return const SizedBox();
            }
            return buildItem(cartItem, animation, index);
          },
          initialItemCount: count!,
        ),
        SliverToBoxAdapter(child: buildBill(context)),
      ],
    );
  }

  List<SliverToBoxAdapter> _buildErrorMessages(List<dynamic> errors) {
    return errors
        .map((error) => SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 2),
                child: CirillaMessage(
                  message: error['message'] as String? ?? '',
                  type: CirillaMessageType.error,
                ),
              ),
            ))
        .toList();
  }

  Widget buildItem(CartItem cartItem, Animation animation, int index) {
    return SizeTransition(
      sizeFactor: animation as Animation<double>,
      child: Column(
        children: [
          Item(
            key: Key('${cartItem.key}'),
            cartItem: cartItem,
            onRemove: !_cartStore.loadingRemoveCart ? () => onRemoveItem(context, cartItem, index) : null,
            updateQuantity: (cartItem, value) => updateQuantity(cartItem, value, index),
          ),
          const Divider(height: 2, thickness: 1),
        ],
      ),
    );
  }

  Widget buildBill(BuildContext context) {
    TranslateType translate = AppLocalizations.of(context)!.translate;

    ThemeData theme = Theme.of(context);

    TextTheme textTheme = theme.textTheme;

    // Configs
    CartData? cartData = _cartStore.cartData;

    Data data = get(_settingStore.data?.screens, ['cart']);

    Map<String, WidgetConfig> widgets = data.widgets ?? {};

    Map<String, dynamic> fields = widgets['cartPage']?.fields ?? {};

    bool enableShipping = get(fields, ['enableShipping'], true);
    bool enableCoupon = get(fields, ['enableCoupon'], true);
    bool enableExpressCheckout = get(fields, ['enableExpressCheckout'], false);

    return Padding(
      padding: const EdgeInsetsDirectional.only(
        start: layoutPadding,
        end: layoutPadding,
        top: itemPaddingLarge,
        bottom: 150,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CartCoupon(
            cartStore: _cartStore,
            enableGuestCheckout: true,
            enableShipping: enableShipping,
            enableCoupon: enableCoupon,
          ),
          if (enableShipping == true && cartData?.needsShipping == true) ...[
            Text(translate('cart_shipping'), style: textTheme.titleMedium),
            const SizedBox(height: 4),
            CartShipping(
              cartData: cartData,
              cartStore: _cartStore,
            ),
            const SizedBox(height: itemPaddingLarge),
          ],
          CartTotal(cartData: cartData!),
          const SizedBox(height: itemPaddingExtraLarge),
          if (enableExpressCheckout == true) ...buildExpressCheckoutButton(context),
          widget.onBuilderButtonCheckout?.call(cartData.errors?.isNotEmpty == true) ?? ElevatedButton(
            style: ElevatedButton.styleFrom(minimumSize: const Size(double.infinity, 48)),
            onPressed: cartData.errors?.isNotEmpty == true ? null: () => _checkout(context),
            child: Text(translate('cart_proceed_to_checkout')),
          ),
        ],
      ),
    );
  }

  List<Widget> buildExpressCheckoutButton(BuildContext context) {
    TranslateType translate = AppLocalizations.of(context)!.translate;
    return [
      const SizedBox(
        width: double.infinity,
        child: CirillaExpressCheckout(needAddToCart: false, isFull: true),
      ),
      const SizedBox(height: itemPadding),
      CirillaDividerText(
        width: MediaQuery.of(context).size.width - itemPadding * 2,
        text: translate('login_text_or'),
      ),
      const SizedBox(height: itemPadding),
    ];
  }
}
