import 'package:flutter/material.dart';

import '../models/models.dart';
import '../mixins/mixins.dart';

class BMConversationItemWidget extends StatelessWidget with BMConversationMixin {
  final BMConversation? conversation;
  final GestureTapCallback? onTap;

  const BMConversationItemWidget({super.key, this.conversation, this.onTap});

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);

    bool isLoading = conversation?.id == null || conversation?.id == 0;

    return InkWell(
      onTap: () {
        if (!isLoading) {
          onTap?.call();
        }
      },
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                buildImage(context, data: conversation, loading: isLoading),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      buildUser(context, data: conversation, loading: isLoading, theme: theme),
                      buildTitle(data: conversation, loading: isLoading, theme: theme),
                      buildContent(data: conversation, loading: isLoading, theme: theme),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    buildDate(context, data: conversation, loading: isLoading, theme: theme),
                    const SizedBox(height: 4),
                    buildCount(data: conversation, loading: isLoading, theme: theme),
                  ],
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
