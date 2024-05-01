import 'package:cirilla/utils/utils.dart';
import 'package:cirilla/widgets/cirilla_shimmer.dart';
import 'package:cirilla/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/style.dart';

import '../models/models.dart';

mixin BPActivityMixin {
  Widget buildImage({
    BPActivity? data,
    double shimmerSize = 32,
  }) {
    if (data?.id == null) {
      return CirillaShimmer(
        child: Container(
          height: shimmerSize,
          width: shimmerSize,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(shimmerSize / 2),
          ),
        ),
      );
    }
    return ClipRRect(
      borderRadius: BorderRadius.circular(shimmerSize / 2),
      child: CirillaCacheImage(
        data?.authorAvatar,
        width: shimmerSize,
        height: shimmerSize,
      ),
    );
  }

  Widget buildTitle({
    BPActivity? data,
    Color? color,
    double shimmerWidth = 120,
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

    TextStyle textStyle = theme.textTheme.bodySmall ?? const TextStyle();
    TextStyle aStyle = theme.textTheme.labelMedium ?? const TextStyle();
    Style style = Style(
      margin: EdgeInsets.zero,
      padding: EdgeInsets.zero,
      fontFamily: textStyle.fontFamily,
      fontSize: FontSize(textStyle.fontSize),
      fontWeight: textStyle.fontWeight,
      color: color ?? textStyle.color,
    );

    return CirillaHtml(
      html: data?.title ?? "",
      style: {
        "html": style,
        "body": style,
        "div": style,
        "a": Style(
          margin: EdgeInsets.zero,
          padding: EdgeInsets.zero,
          fontFamily: aStyle.fontFamily,
          fontSize: FontSize(aStyle.fontSize),
          fontWeight: aStyle.fontWeight,
          textDecoration: TextDecoration.none,
          color: theme.primaryColor,
        ),
      },
    );
  }

  Widget buildDate(BuildContext context, {
    BPActivity? data,
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

    return Padding(
      padding: const EdgeInsets.only(top: 1),
      child: Text(dateAgo(context, date: data?.date), style: theme.textTheme.labelSmall?.copyWith(color: color)),
    );
  }

  Widget? buildContent({
    BPActivity? data,
    Color? color,
    double shimmerWidth = double.infinity,
    double shimmerHeight = 90,
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

    if (data?.content?.isNotEmpty != true) {
      return null;
    }

    TextStyle textStyle = theme.textTheme.bodyMedium ?? const TextStyle();
    Style style = Style(
      margin: EdgeInsets.zero,
      padding: EdgeInsets.zero,
      fontFamily: textStyle.fontFamily,
      fontSize: FontSize(textStyle.fontSize),
      fontWeight: textStyle.fontWeight,
      lineHeight: LineHeight(textStyle.height),
      color: color ?? theme.textTheme.labelSmall?.color,
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

  Widget? buildAction({
    BPActivity? data,
    Widget? child,
    double shimmerWidth = 100,
    double shimmerHeight = 18,
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
    return child;
  }
}
