import 'package:cirilla/types/types.dart';
import 'package:cirilla/utils/utils.dart';
import 'package:cirilla/widgets/cirilla_cache_image.dart';
import 'package:cirilla/widgets/cirilla_shimmer.dart';
import 'package:flutter/material.dart';

import '../models/models.dart';

mixin BPMemberGroupMixin {

  Widget buildAvatar({
    BPMemberGroup? data,
    double shimmerSize = 45,
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
    BPMemberGroup? data,
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

  Widget buildDate(BuildContext context, {
    BPMemberGroup? data,
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
    return Text(translate("buddypress_join", {"date": dateAgo(context, date: data?.date)}), style: theme.textTheme.bodySmall?.copyWith(color: color));
  }
}
