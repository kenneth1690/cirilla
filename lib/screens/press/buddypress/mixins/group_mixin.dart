import 'package:cirilla/types/types.dart';
import 'package:cirilla/utils/utils.dart';
import 'package:cirilla/widgets/cirilla_cache_image.dart';
import 'package:cirilla/widgets/cirilla_shimmer.dart';
import 'package:flutter/material.dart';

import '../models/models.dart';

mixin BPGroupMixin {
  Widget buildBanner({
    BPGroup? data,
    double shimmerWidth = double.infinity,
    double shimmerHeight = double.infinity,
  }) {
    if (data?.id == null) {
      return CirillaShimmer(
        child: Container(
          height: shimmerHeight,
          width: shimmerWidth,
          decoration: const BoxDecoration(color: Colors.white),
        ),
      );
    }
    return CirillaCacheImage(
      // data?.avatar ?? "",
      "",
      width: shimmerWidth,
      height: shimmerHeight,
    );
  }

  Widget buildAvatar({
    BPGroup? data,
    double shimmerSize = 30,
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
        data?.avatar ?? "",
        width: shimmerSize,
        height: shimmerSize,
      ),
    );
  }

  Widget buildName({
    BPGroup? data,
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
    return Text(data?.name ?? "User", style: theme.textTheme.titleMedium?.copyWith(color: color));
  }

  Widget buildStatus({
    BPGroup? data,
    Color? color,
    double shimmerWidth = 70,
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
    String keyText = getKeyTextStatus(data?.status);
    return Text(translate(keyText), style: theme.textTheme.bodySmall?.copyWith(color: color));
  }

  String getKeyTextStatus(String? status) {
    switch (status) {
      case "private":
        return "buddypress_private_group";
      case "hidden":
        return "buddypress_hidden_group";
      default:
        return "buddypress_public_group";
    }
  }

  Widget buildActiveTime(
    BuildContext context, {
      BPGroup? data,
      Color? color,
      double shimmerWidth = 70,
      double shimmerHeight = 14,
      required ThemeData theme,
      required TranslateType translate,
    }
  ) {
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
      translate("buddypress_active", {
        "date": dateAgo(context, date: data?.lastActivity)
      }),
      style: theme.textTheme.bodySmall?.copyWith(color: color),
    );
  }

  Widget buildAction(
    BuildContext context, {
      BPGroup? data,
      required Widget child,
      double shimmerWidth = 130,
      double shimmerHeight = 34,
    }
  ) {
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
