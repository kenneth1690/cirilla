import 'package:awesome_bottom_bar/awesome_bottom_bar.dart';
import 'package:awesome_bottom_bar/widgets/inspired/inspired.dart';
import 'package:cirilla/mixins/mixins.dart';
import 'package:cirilla/models/setting/setting.dart';
import 'package:cirilla/store/store.dart';
import 'package:cirilla/utils/convert_data.dart';
import 'package:cirilla/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'tab_item_count.dart';

class Tabs extends StatefulWidget {
  final String? selected;
  final Function? onItemTapped;
  final Data? data;

  const Tabs({
    Key? key,
    this.selected,
    this.onItemTapped,
    this.data,
  }) : super(key: key);

  @override
  State<Tabs> createState() => _TabsState();
}

class _TabsState extends State<Tabs> with Utility {
  int fixedIndex = 0;
  late SettingStore settingStore;
  late String themeModeKey;
  late String? languageKey;
  dynamic item;
  String? key;

  @override
  void didChangeDependencies() {
    settingStore = Provider.of<SettingStore>(context);
    themeModeKey = settingStore.themeModeKey;
    languageKey = settingStore.languageKey;
    super.didChangeDependencies();
  }

  List<TabItem> tabItems() {
    WidgetConfig widgetConfig = widget.data!.widgets!['tabs']!;
    List items = get(widgetConfig.fields, ['items'], []);
    return List.generate(
      items.length,
      (index) {
        item = items.elementAt(index);
        bool active = get(item, ['active'], false);
        bool enableCount = get(item, ['data', 'enableCount'], false);
        String countType = get(item, ['data', 'countType'], 'cart');
        if (active) {
          fixedIndex = index;
        }
        return TabItem(
          icon: getIconData(data: get(item, ['data', 'icon'], {'name': 'home', 'type': 'feather'})),
          title: get(item, ['data', 'title', languageKey], ''),
          key: get(item, ['data', 'action', 'args', 'key'], ''),
          count: enableCount ? TabItemCount(type: countType) : null,
        );
      },
    );
  }

  int indexSelected() {
    int indexWhere = tabItems().indexWhere((e) => e.key == widget.selected);
    List<String?> tabs = settingStore.tabs;
    key = tabItems()[fixedIndex].key;
    if (key != tabs[0]) {
      tabs.replaceRange(0, 1, [key]);
      widget.onItemTapped!(key);
      return fixedIndex;
    }
    if (indexWhere == -1) {
      return 0;
    }
    return indexWhere;
  }

  onTap(int index) {
    widget.onItemTapped!(tabItems()[index].key);
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);

    WidgetConfig widgetConfig = widget.data!.widgets!['tabs']!;

    String layoutData = widgetConfig.layout ?? 'default';

    Map<String, dynamic>? styles = widgetConfig.styles;
    Map<String, dynamic>? fields = widgetConfig.fields;

    bool? enableShadow = get(styles, ['enableShadow'], true);
    bool? animated = get(fields, ['animated'], true);
    bool? fixedActive = get(fields, ['fixedActive'], false);

    double? padTop = ConvertData.stringToDouble(get(styles, ['padTop'], 12));
    double? pad = ConvertData.stringToDouble(get(styles, ['pad'], 4));
    double? padBottom = ConvertData.stringToDouble(get(styles, ['padBottom'], 12));
    bool showBottomBar = get(fields, ['hidden'], false);

    bool enableCustomize = get(item, ['data', 'enableCustomize'], false);

    Map<String, dynamic> configStyle = enableCustomize ? get(item, ['data'], {}) : styles;

    Color background =
        ConvertData.fromRGBA(get(configStyle, ['background', themeModeKey], {}), theme.bottomAppBarTheme.color);

    Color textColor = ConvertData.fromRGBA(get(configStyle, ['color', themeModeKey], {}), Colors.black);

    Color activeColor = ConvertData.fromRGBA(get(configStyle, ['colorActive', themeModeKey], {}), theme.primaryColor);

    Color colorOnActive =
        ConvertData.fromRGBA(get(configStyle, ['colorOnActive', themeModeKey], {}), theme.primaryColor);

    double? radius = ConvertData.stringToDouble(get(configStyle, ['radius'], 0));

    double? activeBorderRadius = ConvertData.stringToDouble(get(configStyle, ['activeBorderRadius'], 30));

    BorderRadius borderRadius = BorderRadius.only(
      topLeft: Radius.circular(radius),
      topRight: Radius.circular(radius),
    );

    Widget styleBottomBar() {
      switch (layoutData) {
        case 'border_top':
          return BottomBarDivider(
            items: tabItems(),
            colorSelected: activeColor,
            color: textColor,
            indexSelected: indexSelected(),
            backgroundColor: background,
            onTap: onTap,
            top: padTop,
            bottom: padBottom,
            pad: pad,
            animated: animated!,
            enableShadow: enableShadow,
          );
        case 'border_bottom':
          return BottomBarDivider(
            items: tabItems(),
            colorSelected: activeColor,
            color: textColor,
            indexSelected: indexSelected(),
            backgroundColor: background,
            onTap: onTap,
            top: padTop,
            bottom: padBottom,
            pad: pad,
            animated: animated!,
            enableShadow: enableShadow,
            styleDivider: StyleDivider.bottom,
          );
        case 'salomon':
          return BottomBarSalomon(
            items: tabItems(),
            color: textColor,
            backgroundColor: background,
            colorSelected: colorOnActive,
            backgroundSelected: activeColor,
            top: padTop,
            bottom: padBottom,
            animated: animated!,
            enableShadow: enableShadow,
            borderRadius: borderRadius,
            radiusSalomon: BorderRadius.circular(activeBorderRadius),
            indexSelected: indexSelected(),
            onTap: onTap,
          );
        case 'inspired_inside':
          return BottomBarInspiredInside(
            items: tabItems(),
            backgroundColor: background,
            color: textColor,
            colorSelected: colorOnActive,
            indexSelected: indexSelected(),
            animated: animated!,
            isAnimated: false,
            radius: radius,
            padTop: padTop,
            pad: pad,
            fixed: fixedActive!,
            fixedIndex: fixedIndex,
            padbottom: padBottom,
            onTap: onTap,
            elevation: enableShadow == true ? 5 : 0,
            itemStyle: ItemStyle.circle,
            chipStyle: ChipStyle(convexBridge: true, background: activeColor),
          );
        case 'inspired_inside_hexagon':
          return BottomBarInspiredInside(
            items: tabItems(),
            backgroundColor: background,
            color: textColor,
            colorSelected: colorOnActive,
            indexSelected: indexSelected(),
            animated: animated!,
            isAnimated: false,
            radius: radius,
            padTop: padTop,
            pad: pad,
            fixed: fixedActive!,
            fixedIndex: fixedIndex,
            padbottom: padBottom,
            elevation: enableShadow == true ? 5 : 0,
            onTap: onTap,
            itemStyle: ItemStyle.hexagon,
            chipStyle: ChipStyle(isHexagon: true, background: activeColor),
          );
        case 'inspired_outside':
          return BottomBarInspiredOutside(
            items: tabItems(),
            backgroundColor: background,
            color: textColor,
            colorSelected: colorOnActive,
            indexSelected: indexSelected(),
            animated: animated!,
            isAnimated: false,
            radius: radius,
            padTop: padTop,
            pad: pad,
            fixed: fixedActive!,
            fixedIndex: fixedIndex,
            padbottom: padBottom,
            elevation: enableShadow == true ? 5 : 0,
            onTap: onTap,
            itemStyle: ItemStyle.circle,
            chipStyle: ChipStyle(notchSmoothness: NotchSmoothness.sharpEdge, background: activeColor),
          );
        case 'inspired_outside_hexagon':
          return BottomBarInspiredOutside(
            items: tabItems(),
            backgroundColor: background,
            color: textColor,
            colorSelected: colorOnActive,
            indexSelected: indexSelected(),
            animated: animated!,
            isAnimated: false,
            elevation: enableShadow == true ? 5 : 0,
            onTap: onTap,
            radius: radius,
            padTop: padTop,
            pad: pad,
            fixed: fixedActive!,
            fixedIndex: fixedIndex,
            padbottom: padBottom,
            itemStyle: ItemStyle.hexagon,
            chipStyle:
                ChipStyle(notchSmoothness: NotchSmoothness.defaultEdge, drawHexagon: true, background: activeColor),
          );
        case 'inspired_outside_deep':
          return BottomBarInspiredOutside(
            items: tabItems(),
            backgroundColor: background,
            color: textColor,
            colorSelected: colorOnActive,
            indexSelected: indexSelected(),
            animated: animated!,
            isAnimated: false,
            elevation: enableShadow == true ? 5 : 0,
            onTap: onTap,
            radius: radius,
            padTop: padTop,
            pad: pad,
            fixed: fixedActive!,
            fixedIndex: fixedIndex,
            padbottom: padBottom,
            itemStyle: ItemStyle.circle,
            chipStyle: ChipStyle(notchSmoothness: NotchSmoothness.verySmoothEdge, background: activeColor),
          );
        case 'inspired_outside_radius':
          return BottomBarInspiredOutside(
            items: tabItems(),
            backgroundColor: background,
            color: textColor,
            colorSelected: colorOnActive,
            indexSelected: indexSelected(),
            animated: animated!,
            isAnimated: false,
            elevation: enableShadow == true ? 5 : 0,
            onTap: onTap,
            radius: radius,
            padTop: padTop,
            pad: pad,
            fixed: fixedActive!,
            fixedIndex: fixedIndex,
            padbottom: padBottom,
            itemStyle: ItemStyle.circle,
            chipStyle: ChipStyle(notchSmoothness: NotchSmoothness.softEdge, background: activeColor),
          );
        case 'inspired_curve':
          return BottomBarCreative(
            items: tabItems(),
            backgroundColor: background,
            borderRadius: borderRadius,
            color: textColor,
            colorSelected: activeColor,
            enableShadow: enableShadow,
            indexSelected: indexSelected(),
            highlightStyle: HighlightStyle(
              sizeLarge: true,
              background: activeColor,
              color: colorOnActive,
            ),
            top: padTop,
            pad: pad,
            bottom: padBottom,
            isFloating: true,
            onTap: onTap,
          );
        case 'inspired_curve_hexagon':
          return BottomBarCreative(
            items: tabItems(),
            backgroundColor: background,
            borderRadius: borderRadius,
            color: textColor,
            colorSelected: activeColor,
            enableShadow: enableShadow,
            indexSelected: indexSelected(),
            highlightStyle: HighlightStyle(
              isHexagon: true,
              sizeLarge: true,
              background: activeColor,
              color: colorOnActive,
            ),
            top: padTop,
            pad: pad,
            bottom: padBottom,
            isFloating: true,
            onTap: onTap,
          );
        case 'creative':
          return BottomBarCreative(
            items: tabItems(),
            backgroundColor: background,
            borderRadius: borderRadius,
            color: textColor,
            colorSelected: activeColor,
            enableShadow: enableShadow,
            indexSelected: indexSelected(),
            highlightStyle: HighlightStyle(
              background: activeColor,
              color: colorOnActive,
            ),
            top: padTop,
            pad: pad,
            bottom: padBottom,
            isFloating: false,
            onTap: onTap,
          );
        case 'creative_hexagon':
          return BottomBarCreative(
            items: tabItems(),
            backgroundColor: background,
            borderRadius: borderRadius,
            color: textColor,
            colorSelected: activeColor,
            enableShadow: enableShadow,
            indexSelected: indexSelected(),
            highlightStyle: HighlightStyle(
              isHexagon: true,
              sizeLarge: true,
              background: activeColor,
              color: colorOnActive,
            ),
            top: padTop,
            pad: pad,
            bottom: padBottom,
            isFloating: false,
            onTap: onTap,
          );
        case 'fancy':
          return BottomBarInspiredFancy(
            items: tabItems(),
            backgroundColor: background,
            color: textColor,
            colorSelected: activeColor,
            top: padTop,
            bottom: padBottom,
            pad: pad,
            borderRadius: borderRadius,
            indexSelected: indexSelected(),
            styleIconFooter: StyleIconFooter.dot,
            animated: animated!,
            enableShadow: enableShadow,
            onTap: onTap,
          );
        case 'fancy_border':
          return BottomBarInspiredFancy(
            items: tabItems(),
            backgroundColor: background,
            color: textColor,
            colorSelected: activeColor,
            top: padTop,
            bottom: padBottom,
            pad: pad,
            borderRadius: borderRadius,
            indexSelected: indexSelected(),
            styleIconFooter: StyleIconFooter.divider,
            animated: animated!,
            enableShadow: enableShadow,
            onTap: onTap,
          );
        case 'floating':
          return Container(
            padding: const EdgeInsets.only(bottom: 30, left: 32, right: 32),
            child: BottomBarFloating(
              items: tabItems(),
              backgroundColor: background,
              color: textColor,
              colorSelected: activeColor,
              indexSelected: indexSelected(),
              animated: animated!,
              borderRadius: BorderRadius.circular(radius),
              top: padTop,
              bottom: padBottom,
              pad: pad,
              enableShadow: enableShadow,
              onTap: onTap,
            ),
          );
        case 'default_bg':
          return BottomBarBackground(
            items: tabItems(),
            backgroundColor: background,
            color: textColor,
            colorSelected: colorOnActive,
            indexSelected: indexSelected(),
            backgroundSelected: activeColor,
            paddingVertical: 25,
            animated: animated!,
            top: padTop,
            pad: pad,
            borderRadius: borderRadius,
            bottom: padBottom,
            onTap: onTap,
          );
        default:
          return BottomBarDefault(
            items: tabItems(),
            backgroundColor: background,
            color: textColor,
            colorSelected: activeColor,
            animated: animated!,
            borderRadius: borderRadius,
            enableShadow: enableShadow,
            indexSelected: indexSelected(),
            top: padTop,
            bottom: padBottom,
            pad: pad,
            onTap: onTap,
          );
      }
    }

    if (showBottomBar) {
      return const SizedBox();
    }
    return styleBottomBar();
  }
}
