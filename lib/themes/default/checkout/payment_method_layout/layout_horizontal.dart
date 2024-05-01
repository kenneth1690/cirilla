import 'package:cirilla/constants/constants.dart';
import 'package:cirilla/models/cart/gateway.dart';
import 'package:cirilla/payment_methods.dart';
import 'package:flutter/material.dart';
import 'item_gateway.dart';

class LayoutHorizontal extends StatelessWidget {
  final List<Gateway> gateways;
  final int active;
  final void Function(int index) select;
  final double padHorizontal;
  const LayoutHorizontal({
    required this.gateways,
    required this.active,
    required this.select,
    this.padHorizontal = layoutPadding,
    super.key,
  });
  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          padding: EdgeInsets.symmetric(horizontal: padHorizontal),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: List.generate(gateways.length, (index) {
              String? imageMethod = methods[gateways[index].id]?.logoPath;
              String? packageName = methods[gateways[index].id]?.libraryName;
              if (packageName != null) {
                if (packageName.isEmpty) {
                  packageName = null;
                }
              }
              return ItemGateway(
                active: active,
                index: index,
                select: select,
                imageMethod: imageMethod,
                packageName: packageName,
                title: Flexible(
                  child: Text(
                    gateways[index].title ?? '',
                    style: theme.textTheme.titleSmall?.copyWith(color: 0 == index ? theme.primaryColor : null),
                  ),
                ),
                padding: const EdgeInsetsDirectional.only(end: itemPadding),
              );
            }),
          ),
        ),
        if (gateways.isNotEmpty)
          ItemDescription(
            padding: EdgeInsets.fromLTRB(padHorizontal, itemPaddingExtraLarge, padHorizontal, 0),
            description: gateways[active].description ?? '',
          ),
      ],
    );
  }
}
