import 'package:flutter/material.dart';
import 'badge.dart';

import 'convert_data.dart';
import 'models/advanced.dart';
import 'models/model.dart';
import 'models/spacing.dart';

double _getPercent(double salePrice, double regularPrice) {
  if (salePrice > 0 && salePrice <= regularPrice) {
    return ((regularPrice - salePrice) * 100) / (regularPrice == 0 ? 1 : regularPrice);
  }
  return 0;
}

String _getPrice(dynamic value) {
  if (value == '') return '0';
  if (value is String) return value;
  if (value is int || value is double) return value.toString();
  return '0';
}

String? _b2bkingFilterPrice(String? price, Map<String, dynamic> product, Map<String, dynamic>? options, String type) {
  List? data = product["meta_data"] is List ? product["meta_data"] : null;
  String b2bkingCustomerGroupId =
      options?["b2bkingCustomerGroupId"] is String ? options!["b2bkingCustomerGroupId"] : "";

  if (options == null || b2bkingCustomerGroupId == '' || data == null) {
    return price;
  }

  Map<String, dynamic> metaData = data.firstWhere(
    (e) => e['key'] == 'b2bking_${type}_product_price_group_$b2bkingCustomerGroupId',
    orElse: () => {'value': ''},
  );

  if (metaData['value'] == '' || metaData['value'] == null) {
    return price;
  }

  return metaData['value'].replaceAll(',', '');
}

YithBadgeAdvancedValueModel _getDataAdvanced(
  BuildContext context,
  Map<String, dynamic>? product,
  Map<String, dynamic>? userOptions,
  String Function(BuildContext context, {String? price, String? currency, String? symbol, String? pattern})
      formatCurrency,
) {
  Map<String, dynamic> p = (product ?? {}).cast<String, dynamic>();
  String amount = formatCurrency(context, price: "0");
  String percentage = "0%";

  String type = p["type"] is String ? p["type"] : "simple";
  bool onSale = ConvertData.toBoolValue(p["on_sale"]) ?? false;

  String priceP = _getPrice(p["price"]);
  String regularPriceP = _getPrice(p["regular_price"]);
  String? salePriceP = _getPrice(p["sale_price"]);

  if ((type == "simple" || type == "external") && onSale) {
    String? priceProduct = regularPriceP != '0' ? regularPriceP : priceP;
    String? salePriceProduct = salePriceP;

    String? filterRegularPrice = _b2bkingFilterPrice(priceProduct, p, userOptions, 'regular');
    String? filterSalePrice = _b2bkingFilterPrice(salePriceProduct, p, userOptions, 'sale');

    double price = ConvertData.stringToDouble(filterRegularPrice);
    double salePrice = ConvertData.stringToDouble(filterSalePrice);

    double distance = price - salePrice;

    double percent = _getPercent(salePrice, price);

    amount = formatCurrency(context, price: distance.toString());
    percentage = "${percent.toStringAsFixed(percent.truncateToDouble() == percent ? 0 : 1)}%";
  }

  return YithBadgeAdvancedValueModel.fromJson({
    "amount": amount,
    "percentage": percentage,
  });
}

List _dataBadges(Map<String, dynamic>? product) {
  if (product != null && product["meta_data"] is List) {
    dynamic yithBadge = (product["meta_data"] as List).firstWhere(
          (e) => e is Map && e['key'] == 'mobile_yith_wcbm_badges',
          orElse: () => {'value': []},
        ) ??
        {'value': []};

    return yithBadge is Map && yithBadge["value"] is List ? yithBadge["value"] : [];
  }
  return [];
}

class FlutterYithBadgeContainer extends StatelessWidget {
  final Widget background;
  final double width;
  final double height;
  final Map<String, dynamic>? data;
  final Map<String, dynamic>? parentData;
  final String Function(BuildContext context, {String? price, String? currency, String? symbol, String? pattern})
      formatCurrency;
  final Map<String, dynamic>? userOptions;

  const FlutterYithBadgeContainer({
    Key? key,
    this.data,
    this.parentData,
    required this.background,
    required this.width,
    required this.height,
    required this.formatCurrency,
    this.userOptions,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<Widget> childrenBadge = [];

    List badges = _dataBadges(data);
    List badgesParent = _dataBadges(parentData);

    YithBadgeAdvancedValueModel dataAdvanced = _getDataAdvanced(context, data, userOptions, formatCurrency);
    YithBadgeAdvancedValueModel dataAdvancedParent = _getDataAdvanced(context, parentData, userOptions, formatCurrency);

    if (badges.isEmpty && badgesParent.isEmpty) {
      return SizedBox(width: width, height: height, child: background);
    }
    if (badges.isNotEmpty) {
      for (var badge in badges) {
        if (badge is Map) {
          YithBadgeModel model = YithBadgeModel.fromJson(badge.cast<String, dynamic>());

          childrenBadge.add(
            model.positionType == "values"
                ? _ViewValues(
                    config: model,
                    width: width,
                    height: height,
                    child: FlutterYithBadgeItem(
                      config: model,
                      widthParent: width,
                      heightParent: height,
                      data: dataAdvanced,
                    ),
                  )
                : _ViewFixed(
                    config: model,
                    width: width,
                    child: FlutterYithBadgeItem(
                      config: model,
                      widthParent: width,
                      heightParent: height,
                      data: dataAdvanced,
                    ),
                  ),
          );
        }
      }
    }

    if (badgesParent.isNotEmpty) {
      for (var badge in badgesParent) {
        if (badge is Map && badges.indexWhere((b) => b["id"] == badge["id"]) == -1) {
          YithBadgeModel model = YithBadgeModel.fromJson(badge.cast<String, dynamic>());

          childrenBadge.add(
            model.positionType == "values"
                ? _ViewValues(
                    config: model,
                    width: width,
                    height: height,
                    child: FlutterYithBadgeItem(
                        config: model, widthParent: width, heightParent: height, data: dataAdvancedParent),
                  )
                : _ViewFixed(
                    config: model,
                    width: width,
                    child: FlutterYithBadgeItem(
                        config: model, widthParent: width, heightParent: height, data: dataAdvancedParent),
                  ),
          );
        }
      }
    }

    return SizedBox(
      width: width,
      height: height,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          SizedBox(
            width: width,
            height: height,
            child: background,
          ),
          ...childrenBadge,
        ],
      ),
    );
  }
}

class _ViewFixed extends StatelessWidget {
  final YithBadgeModel config;
  final double width;
  final Widget child;

  const _ViewFixed({
    Key? key,
    required this.config,
    required this.width,
    required this.child,
  }) : super(key: key);

  double getSpacing(double value, String type, double parent) {
    if (type == "%") {
      return (value * parent) / 100;
    }
    return value;
  }

  @override
  Widget build(BuildContext context) {
    YithBadgePaddingModel margin = config.margin;

    double? top;
    double? left;
    double? right;
    double? bottom;

    late Alignment alignment;

    switch (config.position) {
      case "middle":
        top = getSpacing(margin.top, margin.unit, width);
        bottom = 0;
        switch (config.alignment) {
          case "center":
            left = getSpacing(margin.left, margin.unit, width);
            right = 0;
            alignment = Alignment.center;
            break;
          case "right":
            right = getSpacing(margin.right, margin.unit, width);
            alignment = Alignment.centerRight;
            break;
          default:
            left = getSpacing(margin.left, margin.unit, width);
            alignment = Alignment.centerLeft;
        }
        break;
      case "bottom":
        bottom = getSpacing(margin.bottom, margin.unit, width);
        switch (config.alignment) {
          case "center":
            left = getSpacing(margin.left, margin.unit, width);
            right = 0;
            alignment = Alignment.bottomCenter;
            break;
          case "right":
            alignment = Alignment.bottomRight;
            right = getSpacing(margin.right, margin.unit, width);
            break;
          default:
            alignment = Alignment.bottomLeft;
            left = getSpacing(margin.left, margin.unit, width);
        }
        break;
      default:
        top = getSpacing(margin.top, margin.unit, width);
        switch (config.alignment) {
          case "center":
            left = getSpacing(margin.left, margin.unit, width);

            right = 0;
            alignment = Alignment.topCenter;
            break;
          case "right":
            alignment = Alignment.topRight;
            right = getSpacing(margin.right, margin.unit, width);
            break;
          default:
            alignment = Alignment.topLeft;
            left = getSpacing(margin.left, margin.unit, width);
        }
    }

    return Positioned.fill(
      top: top,
      left: left,
      right: right,
      bottom: bottom,
      child: Align(
        alignment: alignment,
        child: Transform.scale(
          scale: config.scaleMobile,
          alignment: alignment,
          child: child,
        ),
      ),
    );
  }
}

class _ViewValues extends StatelessWidget {
  final YithBadgeModel config;
  final double height;
  final double width;
  final Widget child;

  const _ViewValues({
    Key? key,
    required this.config,
    required this.width,
    required this.height,
    required this.child,
  }) : super(key: key);

  double getSpacing(double value, String type, double parent) {
    if (type == "%") {
      return (value * parent) / 100;
    }
    return value;
  }

  @override
  Widget build(BuildContext context) {
    YithBadgePaddingModel position = config.positionValues;
    YithBadgePaddingModel margin = config.margin;

    double? topPosition;
    double? leftPosition;
    double? rightPosition;
    double? bottomPosition;

    late Alignment alignment;

    switch (config.anchorPoint) {
      case "top-right":
        topPosition = getSpacing(position.top, position.unit, height) + getSpacing(margin.top, margin.unit, width);
        rightPosition = getSpacing(position.right, position.unit, width) + getSpacing(margin.right, margin.unit, width);

        alignment = Alignment.topRight;
        break;
      case "bottom-left":
        bottomPosition =
            getSpacing(position.bottom, position.unit, height) + getSpacing(margin.bottom, margin.unit, width);
        leftPosition = getSpacing(position.left, position.unit, width) + getSpacing(margin.left, margin.unit, width);
        alignment = Alignment.bottomLeft;
        break;
      case "bottom-right":
        bottomPosition =
            getSpacing(position.bottom, position.unit, height) + getSpacing(margin.bottom, margin.unit, width);
        rightPosition = getSpacing(position.right, position.unit, width) + getSpacing(margin.right, margin.unit, width);
        alignment = Alignment.bottomRight;
        break;
      default:
        topPosition = getSpacing(position.top, position.unit, height) + getSpacing(margin.top, margin.unit, width);
        leftPosition = getSpacing(position.left, position.unit, width) + getSpacing(margin.left, margin.unit, width);
        alignment = Alignment.topLeft;
    }

    return Positioned.fill(
      top: topPosition,
      left: leftPosition,
      right: rightPosition,
      bottom: bottomPosition,
      child: Transform.scale(
        scale: config.scaleMobile,
        alignment: alignment,
        child: child,
      ),
    );
  }
}
