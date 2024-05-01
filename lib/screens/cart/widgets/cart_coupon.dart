import 'package:cirilla/constants/constants.dart';
import 'package:cirilla/models/cart/cart.dart';
import 'package:cirilla/screens/cart/coupon_smart/coupon_input_apply.dart';
import 'package:cirilla/screens/cart/coupon_smart/coupon_smart_screen.dart';
import 'package:cirilla/store/store.dart';
import 'package:cirilla/utils/utils.dart';
import 'package:feather_icons/feather_icons.dart';
import 'package:flutter/material.dart';
import 'package:cirilla/mixins/cart_mixin.dart';
import 'package:cirilla/mixins/mixins.dart';
import 'package:cirilla/types/types.dart';
import 'package:provider/provider.dart';

class CartCoupon extends StatefulWidget {
  final Function(BuildContext context, int packageId, String rateId)? selectShipping;
  final CartStore? cartStore;
  final bool? enableGuestCheckout;
  final bool? enableShipping;
  final bool? enableCoupon;

  const CartCoupon({
    Key? key,
    this.cartStore,
    this.enableGuestCheckout,
    this.selectShipping,
    this.enableShipping,
    this.enableCoupon,
  }) : super(key: key);

  @override
  State<CartCoupon> createState() => _CartCouponState();
}

class _CartCouponState extends State<CartCoupon>
    with Utility, CartMixin, SnackMixin, GeneralMixin, LoadingMixin, TransitionMixin {
  bool loadingRemove = false;
  bool select = false;
  int? indexSelect;
  TextEditingController myController = TextEditingController();
  late AuthStore _authStore;
  bool isApply = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _authStore = Provider.of<AuthStore>(context);
  }

  Future<void> _removeCoupon(BuildContext context, int index) async {
    TranslateType translate = AppLocalizations.of(context)!.translate;
    try {
      setState(() {
        loadingRemove = true;
      });
      await widget.cartStore!.removeCoupon(code: widget.cartStore!.cartData!.coupons!.elementAt(index)['code']);
      setState(() {
        loadingRemove = false;
      });
      if (context.mounted) showSuccess(context, translate('cart_coupon_remove'));
    } catch (e) {
      setState(() {
        loadingRemove = false;
      });
      if (context.mounted) showError(context, e);
    }
  }

  Future<void> _applyCoupon({required String code}) async {
    TranslateType translate = AppLocalizations.of(context)!.translate;
    try {
      await widget.cartStore!.applyCoupon(code: code);
      if (mounted) showSuccess(context, translate('cart_successfully'));
      myController.clear();
    } catch (e) {
      if (mounted) showError(context, e);
    }
  }

  void onCouponList(BuildContext context) {
    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (context, _, __) => CouponSmartScreen(
          onSelected: (code) => Navigator.pop(context, code),
        ),
        transitionsBuilder: slideTransition,
      ),
    ).then((value) {
      if (value is String) {
        myController.text = value;
        _applyCoupon(code: value);
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    CartData cartData = widget.cartStore!.cartData!;

    TranslateType translate = AppLocalizations.of(context)!.translate;

    ThemeData theme = Theme.of(context);

    TextTheme textTheme = theme.textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.enableCoupon == true) ...[
          Text(translate('cart_coupon'), style: textTheme.titleSmall),
          CouponInputApply(
            onChanged: (value) {
              setState(() {});
            },
            textController: myController,
            loading: myController.text != '' && !widget.cartStore!.loadingCoupon,
            onApply: () {
              _applyCoupon(code: myController.text);
              setState(() {});
            },
          ),
          if (_authStore.isLogin)
            ListTile(
              title: Text(translate('cart_coupon_add')),
              trailing: const Icon(Icons.chevron_right_sharp),
              contentPadding: EdgeInsets.zero,
              dense: true,
              visualDensity: const VisualDensity(vertical: -4),
              onTap: () => onCouponList(context),
            ),
          Stack(
            children: [
              Column(
                children: List.generate(cartData.coupons!.length, (index) {
                  String couponTitle = get(cartData.coupons!.elementAt(index), ['code'], '');
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(couponTitle, style: textTheme.bodyMedium?.copyWith(color: theme.primaryColor)),
                      InkResponse(
                        onTap: () async {
                          setState(() {
                            loadingRemove = true;
                          });
                          if (!widget.cartStore!.loading) _removeCoupon(context, index);
                        },
                        child: const Icon(FeatherIcons.x, size: itemPaddingMedium),
                      )
                    ],
                  );
                }),
              ),
              Positioned(
                top: 0,
                bottom: 0,
                left: 0,
                right: 0,
                child: widget.cartStore!.loading && loadingRemove
                    ? Align(
                        alignment: Alignment.center,
                        child: entryLoading(context, color: theme.colorScheme.primary),
                      )
                    : Container(),
              )
            ],
          ),
          const Divider(height: 32, thickness: 1),
        ],
      ],
    );
  }
}
