import 'package:cirilla/widgets/widgets.dart';
import 'package:feather_icons/feather_icons.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cirilla/constants/styles.dart';
import 'package:cirilla/mixins/mixins.dart';
import 'package:cirilla/store/store.dart';
import '../widgets/text_subtitle.dart';

class BlockItemCarousel extends StatelessWidget with Utility, NavigationMixin {
  final List blocks;
  final List Function(List) getItems;
  final Widget? separator;
  final EdgeInsetsGeometry? padding;

  const BlockItemCarousel({
    super.key,
    required this.blocks,
    required this.getItems,
    this.separator,
    this.padding,
  });

  Widget buildItem(
    BuildContext context, {
    dynamic item,
    required ThemeData theme,
    required SettingStore settingStore,
  }) {
    String title = get(item, ["value", "title", settingStore.languageKey], "");
    String subtitleItem = get(item, ["value", "subTitle", settingStore.languageKey], "");
    Map iconItem = get(item, [
      "value",
      "icon"
    ], {
      "name": "settings",
      "type": "feather",
    });
    Map action = get(item, ["value", "action"], {});
    bool isChevron = get(item, ["value", "enableChevron"], true);

    return InkWell(
      onTap: () => navigate(context, Map.castFrom<dynamic, dynamic, String, dynamic>(action)),
      child: SizedBox(
        width: 87,
        child: Column(
          children: [
            Icon(
              getIconData(data: iconItem),
              size: 34,
            ),
            const SizedBox(height: 6),
            Text(
              title,
              style: theme.textTheme.bodySmall,
              textAlign: TextAlign.center,
            ),
            if (subtitleItem.isNotEmpty)
              TextSubtitle(
                text: subtitleItem,
                style: theme.textTheme.bodySmall,
                textAlign: TextAlign.center,
              ),
            if (isChevron) const Icon(FeatherIcons.chevronRight, size: 16),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    SettingStore settingStore = Provider.of<SettingStore>(context);

    if (blocks.isEmpty) {
      return Container();
    }

    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: padding ?? EdgeInsets.zero,
      itemBuilder: (_, int index) {
        dynamic block = blocks.elementAt(index);
        String title = get(block, ["data", "title", settingStore.languageKey], "");
        List items = getItems(get(block, ["data", "items"], []));

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: theme.textTheme.titleLarge),
            if (items.isNotEmpty)
              SingleChildScrollView(
                padding: const EdgeInsets.only(top: itemPaddingSmall),
                scrollDirection: Axis.horizontal,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    for (int i = 0; i < items.length; i++) ...[
                      buildItem(
                        context,
                        item: items.elementAt(i),
                        theme: theme,
                        settingStore: settingStore,
                      ),
                      if (i < items.length - 1) const SizedBox(width: itemPaddingSmall),
                    ]
                  ],
                ),
              )
          ],
        );
      },
      separatorBuilder: (_, __) => separator ?? const SizedBox(height: 28),
      itemCount: blocks.length,
    );
  }
}
