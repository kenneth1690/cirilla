import 'package:cirilla/mixins/mixins.dart';
import 'package:cirilla/types/types.dart';
import 'package:cirilla/utils/utils.dart';
import 'package:cirilla/widgets/widgets.dart';
import 'package:feather_icons/feather_icons.dart';
import 'package:flutter/material.dart';

import 'sort.dart';

class HeadingList extends StatelessWidget with HeaderListMixin, ShapeMixin {
  final double height;
  final Map sort;
  final Function(Map sort) onchangeSort;
  final Function clickRefine;
  final List layouts;
  final int typeView;
  final Function(int visit) onChangeType;

  HeadingList({
    Key? key,
    this.height = 58,
    required this.sort,
    required this.onchangeSort,
    required this.clickRefine,
    required this.layouts,
    required this.typeView,
    required this.onChangeType,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    TranslateType translate = AppLocalizations.of(context)!.translate;
    List<IconData> iconLayout = layouts
        .map((l) {
          Map? icon = get(l, [
            "data",
            'icon'
          ], {
            "name": "square",
            "type": "feather",
          });
          return getIconData(data: icon) ?? FeatherIcons.square;
        })
        .toList()
        .cast<IconData>();

    return buildBoxHeader(
      context,
      height: height,
      left: Row(
        children: [
          buildButtonIcon(
            context,
            icon: FeatherIcons.barChart2,
            title: translate('product_list_sort'),
            height: height,
            onPressed: () async {
              Map<String, dynamic>? sortData = await showModalBottomSheet(
                isScrollControlled: true,
                context: context,
                shape: borderRadiusTop(),
                builder: (context) {
                  return Sort(value: sort as Map<String, dynamic>?);
                },
              );
              if (sortData is Map) {
                onchangeSort(sortData ?? {});
              }
            },
          ),
          const SizedBox(width: 8),
          buildButtonIcon(
            context,
            icon: FeatherIcons.sliders,
            title: translate('product_list_refine'),
            height: height,
            onPressed: () => clickRefine(),
          )
        ],
      ),
      right: iconLayout.isNotEmpty
          ? buildGroupButtonIcon(
              context,
              icons: iconLayout,
              visitSelect: typeView >= iconLayout.length ? 0 : typeView,
              onChange: (int value) => onChangeType(value),
            )
          : null,
    );
  }
}
