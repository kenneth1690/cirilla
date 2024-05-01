import 'package:cirilla/types/types.dart';
import 'package:cirilla/utils/utils.dart';
import 'package:cirilla/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:cirilla/mixins/mixins.dart';
import 'package:cirilla/store/store.dart';

import 'cart_view.dart';
import 'content_view.dart';
import '../widgets/view_content.dart';

class PointSaleScreen extends StatefulWidget {
  static const routeName = '/point_sale';
  final SettingStore? store;

  const PointSaleScreen({
    super.key,
    this.store,
  });

  @override
  State<PointSaleScreen> createState() => _PointSaleScreenState();
}

class _PointSaleScreenState extends State<PointSaleScreen> with AppBarMixin {
  bool _showCart = true;

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    TranslateType translate = AppLocalizations.of(context)!.translate;

    Color colorAppbar = theme.colorScheme.onPrimary;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: theme.primaryColor,
        shadowColor: Colors.transparent,
        elevation: 0,
        iconTheme: theme.appBarTheme.iconTheme?.copyWith(color: colorAppbar),
        titleTextStyle: theme.appBarTheme.titleTextStyle?.copyWith(color: colorAppbar),
        leading: leading(),
        title: Text(translate("point_sale_txt")),
        actions: [
          CirillaCartIcon(
            enableCount: !_showCart,
            color: Colors.transparent,
            icon: const CirillaIconBuilder(data: {'type': 'feather', 'name': 'shopping-cart'}, size: 20),
            onClick: () => setState(() {
              _showCart = !_showCart;
            }),
          ),
          const SizedBox(width: 20),
        ],
      ),
      body: ViewContent(
        enableEnd: _showCart,
        startWidget: const ContentView(),
        endWidget:  const CartView(),
      ),
    );
  }
}
