import 'package:cirilla/mixins/mixins.dart';
import 'package:cirilla/models/cart/cart.dart';
import 'package:cirilla/models/models.dart';
import 'package:cirilla/store/store.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ui/ui.dart';

class CartLayoutShipping extends StatefulWidget {
  final List<dynamic> dataShipping;
  final CartStore? cartStore;
  final ShippingRate shippingRate;
  const CartLayoutShipping({
    super.key,
    required this.dataShipping,
    required this.shippingRate,
    this.cartStore,
  });

  @override
  State<CartLayoutShipping> createState() => CartLayoutShippingState();
}

class CartLayoutShippingState extends State<CartLayoutShipping> with SnackMixin {
  Widget? child;
  bool loadingShipping = false;
  late SettingStore _settingStore;
  Map<String, dynamic> fields = {};
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _settingStore = Provider.of<SettingStore>(context);
  }

  Future<GestureTapCallback?> _selectShipping(
    BuildContext context,
    String? rateId,
    bool selected,
  ) async {
    if (!selected) {
      try {
        loadingShipping = false;
        await widget.cartStore!.selectShipping(packageId: widget.shippingRate.packageId, rateId: rateId);
      } catch (e) {
        loadingShipping = false;
        if (context.mounted) showError(context, e);
      }
    }
    return null;
  }

  List<Widget> buildListItem() {
    ThemeData theme = Theme.of(context);

    TextTheme textTheme = theme.textTheme;

    Widget child;

    return List.generate(widget.dataShipping.length, (index) {
      ShipItem dataShipInfo = widget.dataShipping.elementAt(index);

      String name = dataShipInfo.name!;

      bool selected = dataShipInfo.selected!;

      bool isloadingShipping = loadingShipping ? loadingShipping : selected;

      Color color = theme.focusColor;

      Color colorSelect = theme.primaryColor;

      Widget text = Text(
        name,
        style: isloadingShipping ? textTheme.titleSmall?.copyWith(color: colorSelect) : textTheme.titleSmall,
      );

      String itemType = get(fields, ['shippingMethodItemType'], 'icon');

      switch (itemType) {
        case "filter":
          child = ButtonSelect.filter(
            color: color,
            colorSelect: colorSelect,
            isSelect: isloadingShipping,
            onTap: () => _selectShipping(context, dataShipInfo.rateId, selected),
            child: text,
          );
          break;
        case "radio":
          child = ButtonSelect.radio(
            color: color,
            colorSelect: colorSelect,
            isSelect: isloadingShipping,
            onTap: () => _selectShipping(context, dataShipInfo.rateId, selected),
            child: text,
          );
          break;
        default:
          child = ButtonSelect.icon(
            color: color,
            colorSelect: colorSelect,
            isSelect: isloadingShipping,
            onTap: () => _selectShipping(context, dataShipInfo.rateId, selected),
            child: text,
          );
      }
      return Padding(
        padding: const EdgeInsetsDirectional.only(start: 8, top: 8),
        child: child,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    Data data = get(_settingStore.data?.screens, ['cart']);

    Map<String, WidgetConfig> widgets = data.widgets ?? {};

    fields = widgets['cartPage']?.fields ?? {};

    String layoutDirection = get(fields, ['shippingMethodLayoutDirection'], "horizontal");
    
    Axis axis = layoutDirection == "horizontal" ? Axis.horizontal : Axis.vertical;
    switch (axis) {
      case Axis.vertical:
        return child = Column(
          children: buildListItem(),
        );
      default:
        child = Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: buildListItem(),
        );
    }
    return SingleChildScrollView(
      scrollDirection: axis,
      child: child,
    );
  }
}
