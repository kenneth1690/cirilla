import 'package:cirilla/constants/color_block.dart';
import 'package:cirilla/constants/strings.dart';
import 'package:cirilla/mixins/mixins.dart';
import 'package:cirilla/models/product/product.dart';
import 'package:cirilla/store/setting/setting_store.dart';
import 'package:cirilla/types/types.dart';
import 'package:cirilla/utils/utils.dart';
import 'package:cirilla/widgets/cirilla_product_item.dart';
import 'package:cirilla/widgets/widgets.dart';
import 'package:feather_icons/feather_icons.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ui/notification/notification_screen.dart';

class ProductListLayout extends StatefulWidget {
  // List product
  final List<Product>? products;

  // loading Product
  final bool loading;

  // layout product
  final Map? layout;

  // config styles
  final Map<String, dynamic>? styles;

  // width view content list
  final double widthView;

  const ProductListLayout({
    Key? key,
    required this.products,
    this.loading = true,
    this.layout,
    this.styles,
    this.widthView = 300,
  }) : super(key: key);

  @override
  State<ProductListLayout> createState() => _ProductListLayoutState();
}

class _ProductListLayoutState extends State<ProductListLayout> with Utility, NavigationMixin, GeneralMixin {
  // Build Item product
  Widget buildItem(
    BuildContext context, {
    required Size size,
    Product? product,
    String? templateItem,
    Map<String, dynamic>? templateData,
    Map<String, dynamic>? styles,
  }) {
    ThemeData theme = Theme.of(context);
    SettingStore settingStore = Provider.of<SettingStore>(context);
    String themeModeKey = settingStore.themeModeKey;

    Color textColor =
        ConvertData.fromRGBA(get(styles, ['textColor', themeModeKey], {}), theme.textTheme.titleMedium?.color);
    Color subTextColor =
        ConvertData.fromRGBA(get(styles, ['subTextColor', themeModeKey], {}), theme.textTheme.bodySmall?.color);
    Color priceColor =
        ConvertData.fromRGBA(get(styles, ['priceColor', themeModeKey], {}), theme.textTheme.titleMedium?.color);
    Color salePriceColor = ConvertData.fromRGBA(get(styles, ['salePriceColor', themeModeKey], {}), ColorBlock.red);
    Color regularPriceColor =
        ConvertData.fromRGBA(get(styles, ['regularPriceColor', themeModeKey], {}), theme.textTheme.bodySmall?.color);
    Map wishlist = get(styles, ['wishlistColor', themeModeKey], {});
    Color? wishlistColor = wishlist.isNotEmpty ? ConvertData.fromRGBA(wishlist, Colors.black) : null;

    Color labelNewColor = ConvertData.fromRGBA(get(styles, ['labelNewColor', themeModeKey], {}), ColorBlock.green);
    Color labelNewTextColor = ConvertData.fromRGBA(get(styles, ['labelNewTextColor', themeModeKey], {}), Colors.white);
    double? radiusLabelNew = ConvertData.stringToDouble(get(styles, ['radiusLabelNew'], 10));
    Color labelSaleColor = ConvertData.fromRGBA(get(styles, ['labelSaleColor', themeModeKey], {}), ColorBlock.red);
    Color labelSaleTextColor =
        ConvertData.fromRGBA(get(styles, ['labelSaleTextColor', themeModeKey], {}), Colors.white);
    double? radiusLabelSale = ConvertData.stringToDouble(get(styles, ['radiusLabelSale'], 10));

    double? radiusImage = ConvertData.stringToDouble(get(styles, ['radiusImage'], 8));
    String? typeCart = get(styles, ['typeCart'], 'elevated');
    double? radiusCart = ConvertData.stringToDouble(get(styles, ['radiusCart'], 8));
    Map iconCart = get(styles, ['iconCart'], {'name': 'plus', 'type': 'feather'});

    return CirillaProductItem(
      key: product?.id != null ? Key('${product!.id}') : null,
      product: product,
      template: templateItem,
      dataTemplate: templateData,
      width: size.width,
      height: size.height,
      textColor: textColor,
      subTextColor: subTextColor,
      priceColor: priceColor,
      salePriceColor: salePriceColor,
      regularPriceColor: regularPriceColor,
      labelNewColor: labelNewColor,
      labelNewTextColor: labelNewTextColor,
      labelNewRadius: radiusLabelNew,
      labelSaleColor: labelSaleColor,
      labelSaleTextColor: labelSaleTextColor,
      labelSaleRadius: radiusLabelSale,
      radiusImage: radiusImage,
      background: Colors.transparent,
      wishlistColor: wishlistColor,
      radius: 0,
      iconAddCart: getIconData(data: iconCart),
      radiusAddCart: radiusCart,
      outlineAddCart: typeCart == 'outline',
    );
  }

  @override
  Widget build(BuildContext context) {
    if (widget.loading == false && widget.products?.isEmpty != false) {
      return SliverToBoxAdapter(
        child: buildEmpty(context),
      );
    }

    String layoutItem = get(widget.layout, ["layoutItem"], "list");
    String template = get(widget.layout, ["template", "template"], Strings.productItemContained);
    Map<String, dynamic>? dataTemplate = get(widget.layout, ["template", "data"]);
    bool enableDivider = get(widget.layout, ["enableDivider"], true);
    double pad = ConvertData.stringToDouble(get(widget.layout, ["pad"]), 32);
    double runPad = ConvertData.stringToDouble(get(widget.layout, ["runPad"]), 16);

    double width = ConvertData.stringToDouble(get(dataTemplate, ['size', 'width'], 100));
    double height = ConvertData.stringToDouble(get(dataTemplate, ['size', 'height'], 100));

    List<Product> emptyProducts = List.generate(10, (index) => Product()).toList();
    List<Product> data = widget.loading == false ? widget.products ?? [] : emptyProducts;

    switch (layoutItem) {
      case "grid":
        double column = ConvertData.stringToDouble(get(widget.layout, ["columnItem"], 2));

        double spacing = runPad;

        double widthItem = ((widget.widthView - spacing * (column - 1)) / column).floorToDouble();
        double widthImage = widthItem;
        double heightImage = (widthImage * height) / width;

        return SliverToBoxAdapter(
          child: Wrap(
            spacing: spacing,
            crossAxisAlignment: WrapCrossAlignment.start,
            children: List.generate(
              widget.products!.length,
              (index) => SizedBox(
                width: widthItem,
                child: Column(
                  children: [
                    buildItem(
                      context,
                      product: widget.products!.elementAt(index),
                      templateItem: template,
                      templateData: dataTemplate,
                      size: Size(widthImage, heightImage),
                      styles: widget.styles,
                    ),
                    if (enableDivider) Divider(height: pad, thickness: 1) else SizedBox(height: pad),
                  ],
                ),
              ),
            ),
          ),
        );
      default:
        return SliverList(
          delegate: SliverChildBuilderDelegate(
            (_, index) {
              double widthImage = widget.widthView;
              double heightImage = (widthImage * height) / width;

              return Column(
                children: [
                  buildItem(
                    context,
                    product: data.elementAt(index),
                    templateItem: template,
                    templateData: dataTemplate,
                    size: Size(widthImage, heightImage),
                    styles: widget.styles,
                  ),
                  if (enableDivider) Divider(height: pad, thickness: 1) else SizedBox(height: pad),
                ],
              );
            },
            childCount: data.length,
          ),
        );
    }
  }

  Widget buildEmpty(BuildContext context) {
    TranslateType translate = AppLocalizations.of(context)!.translate;
    return NotificationScreen(
      title: Text(
        translate('product'),
        style: Theme.of(context).textTheme.titleLarge,
        textAlign: TextAlign.center,
      ),
      content: Text(translate('product_no_products_were_found'),
          style: Theme.of(context).textTheme.bodyMedium, textAlign: TextAlign.center),
      iconData: FeatherIcons.layers,
      textButton: Text(translate('order_return_shop')),
      onPressed: () => navigate(context, {
        "type": "tab",
        "router": "/",
        "args": {"key": "screens_category"}
      }),
    );
  }
}
