import 'package:cirilla/types/types.dart';
import 'package:cirilla/utils/utils.dart';
import 'package:cirilla/widgets/widgets.dart';

import '../models/models.dart';
import '../mixins/mixins.dart';
import 'package:flutter/material.dart';

class MemberGroupItemWidget extends StatelessWidget with BPMemberGroupMixin {
  final BPMemberGroup? member;
  final Color? textColor;
  final Color? subtextColor;
  final Color? dividerColor;

  const MemberGroupItemWidget({
    super.key,
    this.member,
    this.textColor,
    this.subtextColor,
    this.dividerColor,
  });

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    TranslateType translate = AppLocalizations.of(context)!.translate;

    return CirillaTile(
      height: 80,
      leading: buildAvatar(data: member),
      title: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          buildName(data: member, color: textColor, theme: theme),
          buildDate(context, data: member, color: subtextColor, theme: theme, translate: translate),
        ],
      ),
      isChevron: false,
      colorDivider: dividerColor,
    );
  }
}
