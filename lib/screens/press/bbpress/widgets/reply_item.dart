import 'package:cirilla/constants/color_block.dart';
import 'package:cirilla/store/store.dart';
import 'package:cirilla/widgets/cirilla_shimmer.dart';
import 'package:cirilla/widgets/widgets.dart';
import 'package:flutter_html/style.dart';
import 'package:provider/provider.dart';
import 'package:ui/ui.dart';

import '../models/models.dart';
import 'package:flutter/material.dart';

class ReplyItemWidget extends StatelessWidget {
  final BBPReply? reply;
  final Color? textColor;
  final Color? subtextColor;
  final Color? dividerColor;
  final GestureTapCallback? onReply;

  const ReplyItemWidget({
    super.key,
    this.reply,
    this.textColor,
    this.subtextColor,
    this.dividerColor,
    this.onReply,
  });

  Widget buildAvatar({
    BBPReply? data,
    double size = 48,
  }) {
    if (data?.id == null) {
      return CirillaShimmer(
        child: Container(
          height: size,
          width: size,
          decoration: const BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
          ),
        ),
      );
    }

    return ClipRRect(
      borderRadius: BorderRadius.circular(size/2),
      child: CirillaCacheImage(
        data?.authorAvatar,
        width: size,
        height: size,
      ),
    );
  }

  Widget buildNumber({
    BBPReply? data,
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
    return BadgeUi(
      text: Text(
        "#${data?.id}",
        style: theme.textTheme.labelSmall?.copyWith(color: Colors.white),
      ),
      color: ColorBlock.green,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      radius: 19,
    );
  }

  Widget buildName({
    BBPReply? data,
    Color? color,
    double shimmerWidth = 120,
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
    return Text(
      data?.authorName ?? '',
      style: theme.textTheme.titleSmall?.copyWith(color: color, fontWeight: FontWeight.w500),
    );
  }

  Widget buildDate({
    BBPReply? data,
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

  Widget buildContent({
    BBPReply? data,
    Color? color,
    double shimmerWidth = double.infinity,
    double shimmerHeight = 40,
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

    TextStyle textStyle = (theme.textTheme.bodySmall ?? const TextStyle()).copyWith(color: color);
    Style style = Style(
      margin: EdgeInsets.zero,
      padding: EdgeInsets.zero,
      fontFamily: textStyle.fontFamily,
      fontSize: FontSize(textStyle.fontSize),
      fontWeight: textStyle.fontWeight,
      lineHeight: const LineHeight(1.6),
      color: textStyle.color,
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

  Widget? buildAction(BuildContext context, {
    BBPReply? data,
    Color? color,
    double shimmerWidth = 100,
    double shimmerHeight = 18,
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
    AuthStore authStore = Provider.of<AuthStore>(context);
    if (authStore.isLogin) {
      return Wrap(
        spacing: 8,
        children: [
          GestureDetector(
            onTap: onReply,
            child: Icon(Icons.reply, size: 20, color: color ?? theme.textTheme.bodySmall?.color),
          ),
        ],
      );
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);

    return _UiItem(
      number: buildNumber(data: reply, theme: theme),
      authorAvatar: buildAvatar(data: reply),
      authorName: buildName(data: reply, color: textColor, theme: theme),
      date: buildDate(data: reply, color: subtextColor, theme: theme),
      content: buildContent(
        data: reply,
        color: subtextColor,
        theme: theme,
      ),
      action: buildAction(
        context,
        data: reply,
        color: subtextColor,
        theme: theme,
      ),
      dividerColor: dividerColor,
    );
  }
}

class _UiItem extends StatelessWidget {
  final Widget authorAvatar;
  final Widget authorName;
  final Widget number;
  final Widget date;
  final Widget content;
  final Widget? action;
  final Color? dividerColor;

  const _UiItem({
    Key? key,
    required this.authorAvatar,
    required this.authorName,
    required this.date,
    required this.number,
    required this.content,
    this.action,
    this.dividerColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return Column(
      children: [
        Row(
          children: [
            authorAvatar,
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  authorName,
                  date,
                ],
              ),
            ),
            const SizedBox(width: 16),
            number,
          ],
        ),
        const SizedBox(height: 12),
        IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(width: 24),
              Container(width: 1, color: dividerColor ?? Theme.of(context).dividerColor),
              const SizedBox(width: 40),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.surface,
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(8),
                          bottomLeft: Radius.circular(8),
                        ),
                      ),
                      child: content,
                    ),
                    if (action != null) ...[
                      const SizedBox(height: 8),
                      action!,
                    ]
                  ],
                )
              ),
            ],
          ),
        ),
      ],
    );
  }
}
