import 'package:cirilla/constants/constants.dart';
import 'package:cirilla/mixins/mixins.dart';
import 'package:cirilla/models/models.dart';
import 'package:cirilla/store/store.dart';
import 'package:cirilla/types/types.dart';
import 'package:cirilla/utils/utils.dart';
import 'package:cirilla/widgets/widgets.dart';
import 'package:feather_icons/feather_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/provider.dart';
import 'package:ui/notification/notification_screen.dart';

import 'coupon_input_apply.dart';

class CouponSmartScreen extends StatefulWidget {
  final ValueChanged<String> onSelected;
  const CouponSmartScreen({
    required this.onSelected,
    super.key,
  });

  @override
  State<CouponSmartScreen> createState() => CouponSmartScreenState();
}

class CouponSmartScreenState extends State<CouponSmartScreen> with AppBarMixin, LoadingMixin {
  late CartStore _cartStore;
  late SettingStore _settingStore;
  Coupon? selected;
  final TextEditingController _controller = TextEditingController();
  bool isApply = false;
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _cartStore = Provider.of<AuthStore>(context).cartStore;
    _settingStore = Provider.of<SettingStore>(context);

    if (_cartStore.couponSmartStore.loadingCoupon == false && _cartStore.couponSmartStore.data.isEmpty) {
      _cartStore.couponSmartStore.getCoupons({
        "cart_key": _cartStore.cartKey,
        'lang': _settingStore.locale,
      });
    }
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void onSelectCoupon(Coupon value) {
    _controller.text = value.couponCode?.toUpperCase() ?? '';
    setState(() {
      selected = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    TranslateType translate = AppLocalizations.of(context)!.translate;
    List<Coupon?> loadingData = List.generate(10, (index) => null);

    return Observer(builder: (_) {
      bool loading = _cartStore.couponSmartStore.loadingCoupon;

      List<Coupon?> data = _cartStore.couponSmartStore.data;

      bool enableClickButton = !loading && data.isNotEmpty && selected?.couponCode != null || _controller.text != '';
      String couponCode = selected?.couponCode ?? _controller.text;

      bool empty = !loading && data.isEmpty;

      return Scaffold(
        appBar: AppBar(
          title: Text(translate('cart_coupon_list')),
          leading: leadingPined(),
        ),
        body: Column(
          children: [
            if (!empty)
              Padding(
                padding: const EdgeInsets.fromLTRB(layoutPadding, itemPadding, layoutPadding, itemPaddingMedium),
                child: CouponInputApply(
                  onChanged: (value) {
                    setState(() {});
                  },
                  textController: _controller,
                  onApply: () => widget.onSelected(_controller.text),
                  loading: enableClickButton,
                ),
              ),
            Expanded(
              child: empty ? NotificationScreen(
                title: Text(
                  translate('cart_coupon_list'),
                  style: theme.textTheme.titleLarge,
                  textAlign: TextAlign.center,
                ),
                content: Text(
                  translate('cart_coupon_empty'),
                  style: theme.textTheme.bodyMedium,
                  textAlign: TextAlign.center,
                ),
                iconData: FeatherIcons.layers,
                isButton: false,
              ) : _CouponListPageData(
                data: loading ? loadingData : data,
                selected: selected,
                onSelected: onSelectCoupon,
              ),
            ),
          ],
        ),
        bottomNavigationBar: !empty
            ? Padding(
                padding: const EdgeInsets.all(layoutPadding),
                child: SizedBox(
                  height: 48,
                  child: ElevatedButton(
                    onPressed: enableClickButton ? () => widget.onSelected(couponCode) : null,
                    child: Text(translate('cart_apply')),
                  ),
                ),
              )
            : null,
      );
    });
  }
}

class _CouponListPageData extends StatelessWidget {
  final List<Coupon?> data;
  final Coupon? selected;
  final ValueChanged<Coupon> onSelected;

  const _CouponListPageData({
    required this.data,
    required this.onSelected,
    this.selected,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(layoutPadding, itemPadding, layoutPadding, itemPadding),
      itemBuilder: (_, int index) {
        Coupon? item = data[index];
        bool valueSelected = item?.couponCode == selected?.couponCode;
        return CirillaCouponItem(
          coupon: data[index],
          selected: valueSelected,
          onChangeSelected: () {
            if (item != null && !valueSelected) {
              onSelected(item);
            }
          },
        );
      },
      separatorBuilder: (_, __) => const SizedBox(height: 16),
      itemCount: data.length,
    );
  }
}
