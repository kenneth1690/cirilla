import 'package:cirilla/types/types.dart';
import 'package:cirilla/utils/utils.dart';
import 'package:cirilla/widgets/cirilla_shimmer.dart';
import 'package:cirilla/widgets/widgets.dart';
import 'package:flutter_html/style.dart';

import '../forum_detail_screen.dart';
import '../models/models.dart';
import 'package:flutter/material.dart';

class ForumItemWidget extends StatelessWidget {
  final BBPForum? forum;
  final Color? textColor;
  final Color? subtextColor;
  final Color? dividerColor;

  const ForumItemWidget({
    super.key,
    this.forum,
    this.textColor,
    this.subtextColor,
    this.dividerColor,
  });

  Widget buildName({
    BBPForum? data,
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

  Widget buildTopic(BuildContext context, {
    BBPForum? data,
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
    TranslateType translate = AppLocalizations.of(context)!.translate;

    int count = data?.topicCount ?? 0;
    late String keyText;

    if (count < 1) {
      keyText = "bbpress_count_no_topic";
    } else if (count == 1) {
      keyText = "bbpress_count_topic_single";
    } else {
      keyText = "bbpress_count_topic_multi";
    }

    return Text(
      translate(keyText, {
        "count": count.toString(),
      }),
      style: theme.textTheme.bodySmall?.copyWith(color: color),
    );
  }

  Widget buildContent({
    BBPForum? data,
    Color? color,
    double shimmerWidth = 130,
    double shimmerHeight = 15,
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
    TextStyle textStyle = theme.textTheme.bodySmall ?? const TextStyle();

    Style style = Style(
      margin: EdgeInsets.zero,
      padding: EdgeInsets.zero,
      fontFamily: textStyle.fontFamily,
      fontSize: FontSize(textStyle.fontSize),
      fontWeight: textStyle.fontWeight,
      lineHeight: const LineHeight(1.6),
      color: color ?? textStyle.color,
    );

    return CirillaHtml(
      html: data?.content ?? "",
      style: {
        "html": style,
        "body": style,
        "div": style,
        "p": style,
      },
    );
  }
  void navigate(BuildContext context) {
    if (forum?.id != null) {
      Navigator.of(context).pushNamed(BBPForumDetailScreen.routeName, arguments: {
        'forum': forum,
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);

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
                        child: buildName(data: forum, color: textColor, theme: theme),
                    ),
                    const SizedBox(width: 12),
                    buildTopic(context, data: forum, color: subtextColor, theme: theme),
                  ],
                ),
                const SizedBox(height: 4),
                buildContent(data: forum, color: subtextColor, theme: theme),
              ],
            ),
          ),
          Divider(height: 1, thickness: 1, color: dividerColor),
        ],
      ),
    );
  }
}
