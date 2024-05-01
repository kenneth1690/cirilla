import 'package:cirilla/types/types.dart';
import 'package:cirilla/utils/utils.dart';

import '../models/models.dart';
import '../mixins/mixins.dart';
import 'package:flutter/material.dart';

import '../group_detail_screen.dart';

class GroupItemWidget extends StatelessWidget with BPGroupMixin {
  final BPGroup? group;
  final Color? textColor;
  final Color? subtextColor;
  final Color? dividerColor;

  const GroupItemWidget({
    super.key,
    this.group,
    this.textColor,
    this.subtextColor,
    this.dividerColor,
  });

  void navigate(BuildContext context) {
    if (group?.id != null) {
      Navigator.of(context).pushNamed(BPGroupDetailScreen.routeName, arguments: {
        'group': group,
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    TranslateType translate = AppLocalizations.of(context)!.translate;

    return InkWell(
      onTap: () => navigate(context),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: Row(
              children: [
                buildAvatar(data: group),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      buildName(data: group, color: textColor, theme: theme),
                      buildActiveTime(context, data: group, color: subtextColor, theme: theme, translate: translate),
                    ],
                  ),
                ),
                const SizedBox(width: 16),
                buildStatus(data: group, color: subtextColor, theme: theme, translate: translate),
              ],
            ),
          ),
          Divider(height: 1, thickness: 1, color: dividerColor),
        ],
      ),
    );
  }
}
