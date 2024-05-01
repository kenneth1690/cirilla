import 'package:cirilla/store/store.dart';
import 'package:cirilla/utils/utils.dart';
import 'package:cirilla/widgets/cirilla_shimmer.dart';
import 'package:cirilla/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/style.dart';
import 'package:provider/provider.dart';

import '../models/models.dart';
import '../widgets/widgets.dart';
import '../../utils.dart';

mixin BMConversationMixin {
  Widget buildImage(BuildContext context, {
    BMConversation? data,
    double shimmerSize = 45,
    bool loading = true,
  }) {
    if (loading) {
      return CirillaShimmer(
        child: Container(
          height: shimmerSize,
          width: shimmerSize,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(4),
          ),
        ),
      );
    }

    return AvatarUserWidget(
      users: data?.participants,
      width: shimmerSize,
    );
  }

  Widget buildUser(BuildContext context, {
    BMConversation? data,
    Color? color,
    double shimmerWidth = 90,
    double shimmerHeight = 14,
    required ThemeData theme,
    bool loading = true,
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
    if (data?.participants != null && data!.participants!.length < 3) {
      AuthStore authStore = Provider.of<AuthStore>(context);
      BMUser? user = data.participants?.firstWhere((element) => element.userId.toString() != authStore.user?.id, orElse: () => BMUser());
      return Text(user?.name ?? "", style: theme.textTheme.titleSmall);
    }
    return Container();

  }

  Widget buildTitle({
    BMConversation? data,
    Color? color,
    double shimmerWidth = 70,
    double shimmerHeight = 14,
    required ThemeData theme,
    bool loading = true
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

    if (data?.title?.isNotEmpty != true) {
      return Container();
    }

    TextStyle? style = data?.participants != null && data!.participants!.length < 3 ? theme.textTheme.labelSmall : theme.textTheme.titleSmall;
    return Text(data!.title!, style: style);
  }

  Widget buildContent({
    BMConversation? data,
    Color? color,
    double shimmerWidth = double.infinity,
    double shimmerHeight = 16,
    required ThemeData theme,
    bool loading = true,
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

    if (data?.lastMessage?.message?.isNotEmpty != true) {
      return Container();
    }

    TextStyle textStyle = theme.textTheme.bodySmall ?? const TextStyle();
    Style style = Style(
      margin: EdgeInsets.zero,
      padding: EdgeInsets.zero,
      fontFamily: textStyle.fontFamily,
      fontSize: FontSize(textStyle.fontSize),
      fontWeight: textStyle.fontWeight,
      color: color ?? textStyle.color,
    );

    return CirillaHtml(
      html: data!.lastMessage!.message!,
      style: {
        "html": style,
        "body": style,
        "div": style,
        "p": style,
      },
    );
  }
  Widget buildDate(BuildContext context, {
    BMConversation? data,
    Color? color,
    double shimmerWidth = 60,
    double shimmerHeight = 14,
    required ThemeData theme,
    bool loading = true
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

    return Text(dateAgo(context, date: convertToDate(data?.lastTime)), style: theme.textTheme.labelSmall);
  }

  Widget buildCount({
    BMConversation? data,
    Color? color,
    double shimmerWidth = 20,
    double shimmerHeight = 14,
    required ThemeData theme,
    bool loading = true
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

    if ((data?.unread ?? 0) > 0) {
      return CirillaBadge(label: "${data?.unread}", type: CirillaBadgeType.error);
    }
    return Container();
  }
}
