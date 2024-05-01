import 'package:cirilla/constants/constants.dart';
import 'package:cirilla/mixins/mixins.dart';
import 'package:cirilla/models/cart/gateway.dart';
import 'package:cirilla/store/store.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'payment_method_layout/payment_method_layout.dart';

class PaymentMethod extends StatelessWidget with GeneralMixin {
  final double padHorizontal;
  final List<Gateway> gateways;
  final int active;
  final void Function(int index) select;

  const PaymentMethod({
    Key? key,
    this.padHorizontal = layoutPadding,
    required this.gateways,
    required this.active,
    required this.select,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SettingStore settingStore = Provider.of<SettingStore>(context, listen: false);
    String layout = getConfig(settingStore, ['layoutCustomCheckoutPayment'], 'layout_horizontal');
    if (layout == 'layout_vertical') {
      return LayoutVertical(
        active: active,
        gateways: gateways,
        select: select,
        key: key,
        padHorizontal: padHorizontal,
      );
    }
    return LayoutHorizontal(
      active: active,
      gateways: gateways,
      select: select,
      key: key,
      padHorizontal: padHorizontal,
    );
  }
}
