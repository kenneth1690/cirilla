import 'package:cirilla/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cirilla/constants/styles.dart';
import 'package:cirilla/mixins/mixins.dart';
import 'package:cirilla/store/store.dart';

import '../widgets/text_subtitle.dart';

class BlockItemList extends StatelessWidget with Utility, NavigationMixin {
  final List blocks;
  final List Function(List) getItems;
  final double pad;

  const BlockItemList({
    super.key,
    required this.blocks,
    required this.getItems,
    this.pad = 28,
  });

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
      padding: EdgeInsets.zero,
      itemBuilder: (_, int index) {
        dynamic block = blocks.elementAt(index);
        String title = get(block, ["data", "title", settingStore.languageKey], "");
        List items = getItems(get(block, ["data", "items"], []));

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: theme.textTheme.titleSmall),
            const SizedBox(height: itemPadding),
            if (items.isNotEmpty)
              ...List.generate(items.length, (i) {
                dynamic item = items.elementAt(i);

                String titleItem = get(item, ["value", "title", settingStore.languageKey], "");
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

                return CirillaTile(
                  title: Text(titleItem, style: theme.textTheme.titleSmall),
                  leading: Icon(
                    getIconData(data: iconItem),
                    size: 16,
                  ),
                  trailing: subtitleItem.isNotEmpty
                      ? TextSubtitle(text: subtitleItem, style: theme.textTheme.bodyMedium)
                      : null,
                  isChevron: isChevron,
                  onTap: () => navigate(context, Map.castFrom<dynamic, dynamic, String, dynamic>(action)),
                );
              }),
          ],
        );
      },
      separatorBuilder: (_, __) => SizedBox(height: pad),
      itemCount: blocks.length,
    );
  }
}
