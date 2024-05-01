import 'package:cirilla/types/types.dart';
import 'package:cirilla/utils/utils.dart';
import 'package:cirilla/widgets/cirilla_shimmer.dart';

import '../models/models.dart';
import 'package:flutter/material.dart';

import '../topic_detail_screen.dart';

class TopicItemWidget extends StatelessWidget {
  final BBPTopic? topic;
  final Color? textColor;
  final Color? subtextColor;
  final Color? dividerColor;

  const TopicItemWidget({
    super.key,
    this.topic,
    this.textColor,
    this.subtextColor,
    this.dividerColor,
  });

  Widget buildName({
    BBPTopic? data,
    Color? color,
    double shimmerWidth = 140,
    double shimmerHeight = 16,
    required ThemeData theme,
  }) {
    if (data?.id == null) {
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
    return Text(data?.title ?? "", style: theme.textTheme.titleMedium?.copyWith(color: color));
  }

  Widget buildDate({
    BBPTopic? data,
    Color? color,
    double shimmerWidth = 70,
    double shimmerHeight = 14,
    required ThemeData theme,
  }) {
    if (data?.id == null) {
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
    return Text(data?.date ?? "", style: theme.textTheme.bodySmall?.copyWith(color: color));
  }

  Widget buildForumAuthor({
    BBPTopic? data,
    Color? textColor,
    Color? subtextColor,
    double shimmerWidth = 120,
    double shimmerHeight = 14,
    required ThemeData theme,
    required TranslateType translate,
  }) {
    if (data?.id == null) {
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
    return RichText(
      text: TextSpan(
        text: translate("bbpress_started_by"),
        children: [
          const TextSpan(text: " "),
          TextSpan(
            text: data?.authorName ?? "",
            style: TextStyle(color: textColor ?? theme.textTheme.titleMedium?.color)
          ),
          if (data?.forumTitle != null) ...[
            const TextSpan(text: " "),
            TextSpan(text: translate("bbpress_in")),
            const TextSpan(text: " "),
            TextSpan(
                text: data?.forumTitle ?? "",
                style: TextStyle(color: textColor ?? theme.textTheme.titleMedium?.color)
            ),
          ]
        ],
        style: theme.textTheme.bodySmall?.copyWith(color:  subtextColor ?? theme.textTheme.bodySmall?.color)
      ),
    );
  }

  Widget buildReplies({
    BBPTopic? data,
    Color? textColor,
    Color? subtextColor,
    double shimmerWidth = 90,
    double shimmerHeight = 14,
    required ThemeData theme,
    required TranslateType translate,
  }) {
    if (data?.id == null) {
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
    String keyPost = (data?.replyCount ?? 0) > 1 ? "bbpress_count_post_multi" : "bbpress_count_post_single";

    return RichText(
      text: TextSpan(
        text: translate("bbpress_replies_in"),
        children: [
          const TextSpan(text: " "),
          TextSpan(
            text: translate(keyPost, {
              "count": "${data?.replyCount ?? 0}"
            }),
            style: TextStyle(color: textColor ?? theme.textTheme.titleMedium?.color)
          ),
        ],
        style: theme.textTheme.bodySmall?.copyWith(color:  subtextColor ?? theme.textTheme.bodySmall?.color)
      ),
    );
  }

  void navigate(BuildContext context) {
    if (topic?.id != null) {
      Navigator.of(context).pushNamed(BBPTopicDetailScreen.routeName, arguments: {
        'topic': topic,
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
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                        child: buildName(data: topic, color: textColor, theme: theme),
                    ),
                    const SizedBox(width: 12),
                    buildDate(data: topic, color: textColor, theme: theme),
                  ],
                ),
                const SizedBox(height: 4),
                buildForumAuthor(data: topic, textColor: textColor, subtextColor: subtextColor, theme: theme, translate: translate),
                buildReplies(data: topic, textColor: textColor, subtextColor: subtextColor, theme: theme, translate: translate),
              ],
            ),
          ),
          Divider(height: 1, thickness: 1, color: dividerColor),
        ],
      ),
    );
  }
}
