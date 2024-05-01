import 'package:cirilla/types/types.dart';
import 'package:cirilla/utils/utils.dart';
import 'package:flutter/material.dart';

import 'modal_filter.dart';

class ActivityFilterList extends StatelessWidget {
  final Axis direction;
  final EdgeInsetsGeometry? padding;
  final String value;
  final ValueChanged<String>? onChanged;

  const ActivityFilterList(
      {super.key, this.direction = Axis.vertical, this.padding, this.value = "all", this.onChanged});

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    TranslateType translate = AppLocalizations.of(context)!.translate;

    List<OptionFilter> options = [
      OptionFilter(key: "all", text: translate("buddypress_all")),
      OptionFilter(key: "new_member", text: translate("buddypress_new_member")),
      OptionFilter(key: "updated_profile", text: translate("buddypress_profile_update")),
      OptionFilter(key: "activity_update", text: translate("buddypress_update")),
      OptionFilter(key: "friendship_accepted,friendship_created", text: translate("buddypress_friendship")),
      OptionFilter(key: "created_group", text: translate("buddypress_new_group")),
      OptionFilter(key: "joined_group", text: translate("buddypress_group_member")),
      OptionFilter(key: "group_details_updated", text: translate("buddypress_group_update")),
      OptionFilter(key: "bbp_topic_create", text: translate("buddypress_topics")),
      OptionFilter(key: "bbp_reply_create", text: translate("buddypress_replies")),
    ];

    if (direction == Axis.horizontal) {
      ButtonStyle buttonStyle = ElevatedButton.styleFrom(
        minimumSize: const Size(0, 34),
        backgroundColor: theme.colorScheme.surface,
        foregroundColor: theme.colorScheme.onSurface,
        shadowColor: Colors.transparent,
      );
      ButtonStyle buttonStyleSelected = ElevatedButton.styleFrom(minimumSize: const Size(0, 34));
      return SizedBox(
        height: 34,
        child: ListView.separated(
          padding: padding ?? EdgeInsets.zero,
          scrollDirection: Axis.horizontal,
          itemBuilder: (_, int index) {
            OptionFilter option = options[index];
            return ElevatedButton(
              onPressed: value == option.key ? () => {} : () => onChanged?.call(option.key),
              style: value == option.key ? buttonStyleSelected : buttonStyle,
              child: Text(option.text),
            );
          },
          separatorBuilder: (_, __) => const SizedBox(width: 12),
          itemCount: options.length,
        ),
      );
    }

    return ModalFilterWidget(
      value: value,
      options: options,
      onSelected: (key) => onChanged?.call(key),
    );
  }
}
