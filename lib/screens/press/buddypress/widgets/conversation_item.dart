import 'package:cirilla/store/store.dart';
import 'package:cirilla/types/types.dart';
import 'package:cirilla/utils/utils.dart';
import 'package:cirilla/widgets/cirilla_shimmer.dart';
import 'package:provider/provider.dart';

import '../models/models.dart';
import 'package:feather_icons/feather_icons.dart';
import 'package:flutter/material.dart';

import '../chat_message_screen.dart';

class ConversationItemWidget extends StatelessWidget {
  final BPConversation? conversation;
  final bool enableCountUser;

  const ConversationItemWidget({
    super.key,
    this.conversation,
    this.enableCountUser = false,
  });

  Widget buildUser(BuildContext context, {
    BPConversation? data,
    bool loading = true,
    double shimmerWidth = 140,
    double shimmerHeight = 14,
    required ThemeData theme,
  }) {
    if (loading) {
      return CirillaShimmer(
        child: Container(
          height: shimmerHeight,
          width: shimmerWidth,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(1),
          ),
        ),
      );
    }
    TranslateType translate = AppLocalizations.of(context)!.translate;
    AuthStore authStore = Provider.of<AuthStore>(context);

    int countUser = data?.recipients?.length ?? 1;
    BPMember? user = enableCountUser ?
      data?.recipients?.firstWhere((element) => "${element.id}" != authStore.user?.id) :
      countUser > 2 ?
        data?.recipients?.firstWhere((element) => element.id == data.senderIds?.first) :
        data?.recipients?.firstWhere((element) => "${element.id}" != authStore.user?.id);

    if (enableCountUser) {
      String keyTran = countUser > 2 ? "buddypress_and_multi" : "buddypress_and_single";
      return RichText(
        text: TextSpan(
          text: "${user?.name}",
          children: [
            const TextSpan(text: " "),
            TextSpan(
              text: translate(keyTran, {"count": "${countUser - 1}"}),
              style: theme.textTheme.labelMedium?.copyWith(color: theme.textTheme.bodyLarge?.color),
            ),
          ],
          style: theme.textTheme.titleSmall,
        ),
      );
    }

    return RichText(
      text: TextSpan(
        text: translate("buddypress_from"),
        children: [
          const TextSpan(text: " "),
          TextSpan(
            text: user?.name ?? "",
            style: theme.textTheme.titleSmall,
          ),
        ],
        style: theme.textTheme.labelMedium?.copyWith(color: theme.textTheme.bodyLarge?.color),
      ),
    );
  }

  Widget buildTitle({
    BPConversation? data,
    bool loading = true,
    double shimmerWidth = 170,
    double shimmerHeight = 16,
    required ThemeData theme,
  }) {
    if (loading) {
      return CirillaShimmer(
        child: Container(
          height: shimmerHeight,
          width: shimmerWidth,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(1),
          ),
        ),
      );
    }
    return Text(
      data?.title ?? "",
      style: theme.textTheme.titleMedium,
    );
  }

  Widget buildMessage({
    BPConversation? data,
    bool loading = true,
    double shimmerWidth = 210,
    double shimmerHeight = 12,
    required ThemeData theme,
  }) {
    if (loading) {
      return CirillaShimmer(
        child: Container(
          height: shimmerHeight,
          width: shimmerWidth,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(1),
          ),
        ),
      );
    }
    return Text(
      (data?.message ?? "").replaceAll("\n", " "),
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
    );
  }

  void navigate(BuildContext context) {
    if (conversation?.id != null) {
      Navigator.of(context).pushNamed(BPChatMessageScreen.routeName, arguments: {
        'conversation': conversation,
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);

    bool loading = conversation?.id == null;

    return InkWell(
      onTap: () => navigate(context),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      buildUser(
                        context,
                        data: conversation,
                        loading: loading,
                        theme: theme,
                      ),
                      buildTitle(
                        data: conversation,
                        loading: loading,
                        theme: theme,
                      ),
                      const SizedBox(height: 2),
                      buildMessage(
                        data: conversation,
                        loading: loading,
                        theme: theme,
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 16),
                const Icon(
                  FeatherIcons.chevronRight,
                  size: 16,
                )
              ],
            ),
          ),
          const Divider(height: 1, thickness: 1),
        ],
      ),
    );
  }
}
