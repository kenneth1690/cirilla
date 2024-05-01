import 'package:cirilla/mixins/mixins.dart';
import 'package:cirilla/store/store.dart';
import 'package:cirilla/types/types.dart';
import 'package:cirilla/utils/utils.dart';
import 'package:provider/provider.dart';

import '../mixins/mixins.dart';
import '../models/models.dart';
import 'package:flutter/material.dart';

import '../member_detail_screen/member_detail_screen.dart';
import 'member_button_friend_slug.dart';

class MemberItemWidget extends StatelessWidget with BPMemberMixin, LoadingMixin {
  final BPMember? member;
  final Color? textColor;
  final Color? subtextColor;
  final Color? dividerColor;
  final bool enableRequiredItem;
  final Function(int? id, String currentType)? onActionCallback;

  const MemberItemWidget({
    super.key,
    this.member,
    this.textColor,
    this.subtextColor,
    this.dividerColor,
    this.enableRequiredItem = false,
    this.onActionCallback,
  });

  void navigate(BuildContext context) {
    if (member?.id != null) {
      Navigator.of(context).pushNamed(BPMemberDetailScreen.routeName, arguments: {
        'member': member,
        "callback": onActionCallback,
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    TranslateType translate = AppLocalizations.of(context)!.translate;

    AuthStore authStore = Provider.of<AuthStore>(context);

    ButtonStyle buttonStyle = ElevatedButton.styleFrom(
      minimumSize: const Size(0, 30),
      textStyle: theme.textTheme.labelMedium,
    );
    Widget childLoading = Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        entryLoading(
          context,
          color: theme.colorScheme.onPrimary,
        ),
      ],
    );

    return _ItemUi(
      avatar: buildImage(data: member),
      name: buildName(data: member, color: textColor, theme: theme),
      date: buildDate(data: member, color: subtextColor, theme: theme, translate: translate),
      friend: authStore.isLogin
          ? buildFriend(
              data: member,
              child: member?.friendshipStatusSlug?.isNotEmpty == true || enableRequiredItem
                  ? Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      alignment: WrapAlignment.start,
                      children: [
                        if (member?.friendshipStatusSlug?.isNotEmpty == true && (!enableRequiredItem || (enableRequiredItem && member?.friendshipStatusSlug != "awaiting_response")))
                          MemberButtonFriendSlugWidget(
                            id: member?.id,
                            slug: member!.friendshipStatusSlug!,
                            callback: onActionCallback,
                            onRenderChild: (String title, Function onClick, bool loading) {
                              return ElevatedButton(
                                onPressed: !loading ? () => onClick() : () => {},
                                style: buttonStyle,
                                child: loading
                                    ? childLoading
                                    : Text(title, textAlign: TextAlign.center),
                              );
                            },
                          ),
                        if (enableRequiredItem && member?.friendshipStatusSlug == "awaiting_response") ...[
                          MemberButtonFriendSlugWidget(
                            id: member?.id,
                            slug: "accept",
                            callback: onActionCallback,
                            onRenderChild: (String title, Function onClick, bool loading) {
                              return ElevatedButton(
                                onPressed: !loading ? () => onClick() : () => {},
                                style: buttonStyle,
                                child: loading
                                    ? childLoading
                                    : Text(title, textAlign: TextAlign.center),
                              );
                            },
                          ),
                          MemberButtonFriendSlugWidget(
                            id: member?.id,
                            slug: "reject",
                            callback: onActionCallback,
                            onRenderChild: (String title, Function onClick, bool loading) {
                              return ElevatedButton(
                                onPressed: !loading ? () => onClick() : () => {},
                                style: buttonStyle,
                                child: loading
                                    ? childLoading
                                    : Text(title, textAlign: TextAlign.center),
                              );
                            },
                          ),
                        ]
                      ],
                    )
                  : null,
              theme: theme,
            )
          : null,
      dividerColor: dividerColor,
      onTap: () => navigate(context),
    );
  }
}

class _ItemUi extends StatelessWidget {
  final Widget? avatar;
  final Widget? name;
  final Widget? date;
  final Widget? friend;
  final Color? dividerColor;
  final GestureTapCallback? onTap;
  const _ItemUi({this.avatar, this.name, this.date, this.friend, this.dividerColor, this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: Row(
              children: [
                if (avatar != null) ...[
                  avatar!,
                  const SizedBox(width: 16),
                ],
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (name != null) name!,
                      if (date != null) date!,
                      if (friend != null) ...[
                        const SizedBox(height: 4),
                        friend!,
                      ],
                    ],
                  ),
                ),
              ],
            ),
          ),
          Divider(height: 1, thickness: 1, color: dividerColor),
        ],
      ),
    );
  }
}
