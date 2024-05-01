import 'package:awesome_icons/awesome_icons.dart';
import 'package:cirilla/mixins/mixins.dart';
import 'package:cirilla/store/store.dart';
import 'package:cirilla/types/types.dart';
import 'package:cirilla/utils/utils.dart';
import 'package:provider/provider.dart';

import '../activity_comment_list_screen.dart';
import '../models/models.dart';
import '../mixins/mixins.dart';
import 'package:flutter/material.dart';

enum ActivityItemType {basic, noAction, comment}

class _IconFavorite extends StatefulWidget  {
  final BPActivity activity;
  final Color? color;
  final Function? callback;

  const _IconFavorite({
    required this.activity,
    this.color,
    this.callback,
  });

  @override
  State<_IconFavorite> createState() => _IconFavoriteState();
}

class _IconFavoriteState extends State<_IconFavorite> with SnackMixin {
  late SettingStore _settingStore;

  @override
  void didChangeDependencies() {
    _settingStore = Provider.of<SettingStore>(context);
    super.didChangeDependencies();
  }
  void onChangeFavorite(bool favorite) async {
    try {
      TranslateType translate = AppLocalizations.of(context)!.translate;
      await _settingStore.requestHelper.updateFavoriteActivity(id: widget.activity.id ?? 0);
      if (mounted) {
        showSuccess(
            context,
            translate(
                favorite ? "buddypress_remove_favorite_activity_success" : "buddypress_add_favorite_activity_success",
                {"id": "${widget.activity.id}"}
            ),
        );
      }
      widget.callback?.call();
    } catch (e) {
      if (mounted) showError(context, e);
    }
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);

    bool favorite = widget.activity.favorited ?? false;
    return GestureDetector(
      onTap: () => onChangeFavorite(favorite),
      child: Icon(favorite ? FontAwesomeIcons.solidHeart : FontAwesomeIcons.heart, size: 16, color: widget.color ?? theme.textTheme.bodySmall?.color),
    );
  }
}

class ActivityItemWidget extends StatelessWidget with TransitionMixin, BPActivityMixin {
  final BPActivity? activity;
  final Color? textColor;
  final Color? subtextColor;
  final Color? dividerColor;
  final ActivityItemType type ;
  final Function(BPActivity? activity)? callback;
  final bool enableDivider;

  const ActivityItemWidget({
    super.key,
    this.activity,
    this.textColor,
    this.subtextColor,
    this.dividerColor,
    this.type = ActivityItemType.basic,
    this.callback,
    this.enableDivider = true,
  });

  Widget? buildWidgetAction(BuildContext context, {
    BPActivity? data,
    Color? color,
    required ThemeData theme,
  }) {
    if (type == ActivityItemType.noAction) {
      return null;
    }

    AuthStore authStore = Provider.of<AuthStore>(context);
    if (type == ActivityItemType.comment) {
      if (authStore.isLogin) {
        return Wrap(
          children: [
            GestureDetector(
              onTap: () => callback?.call(activity),
              child: Icon(FontAwesomeIcons.reply, size: 16, color: color ?? theme.textTheme.bodySmall?.color),
            )
          ],
        );
      }
      return null;
    }

    return Wrap(
      spacing: 16,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        GestureDetector(
          onTap: () async {
            Navigator.push(
              context,
              PageRouteBuilder(
                pageBuilder: (context, _, __) => BPActivityCommentListScreen(
                  id: data?.id,
                  onFetch: () => callback?.call(null),
                ),
                transitionsBuilder: slideTransition,
              ),
            );
          },
          child: Icon(FontAwesomeIcons.comment, size: 16, color: color ?? theme.textTheme.bodySmall?.color),
        ),
        if (authStore.isLogin)
          _IconFavorite(activity: data!, color: color, callback: () => callback?.call(null)),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);

    return Column(
      children: [
        Padding(
          padding: type == ActivityItemType.comment ? const EdgeInsets.symmetric(vertical: 20): const EdgeInsets.all(20),
          child: _Item(
            image: buildImage(data: activity),
            name: buildTitle(data: activity, color: textColor, theme: theme),
            date: buildDate(context, data: activity, color: subtextColor, theme: theme),
            content: buildContent(data: activity, color: subtextColor, theme: theme),
            action: buildAction(
              data: activity,
              child: buildWidgetAction(context, data: activity, color: textColor, theme: theme),
            ),
            dividerColor: dividerColor,
            dividerLeft: type == ActivityItemType.basic,
          ),
        ),
        if (type == ActivityItemType.comment && activity?.comments?.isNotEmpty == true) ...[
          Padding(
            padding: const EdgeInsetsDirectional.only(start: 20),
            child: Divider(height: 1, thickness: 1, color: dividerColor),
          ),
          ...List.generate(
              activity!.comments!.length,
                  (index) => Padding(
                padding: const EdgeInsetsDirectional.only(start: 20),
                child: ActivityItemWidget(
                  activity: activity!.comments![index],
                  textColor: textColor,
                  subtextColor: subtextColor,
                  dividerColor: dividerColor,
                  callback: callback,
                  type: ActivityItemType.comment,
                  enableDivider: index < activity!.comments!.length - 1,
                ),
              )
          ).toList(),
        ],
        if (enableDivider) Divider(height: 1, thickness: 1, color: dividerColor),
      ],
    );
  }
}


class _Item extends StatelessWidget {

  final Widget image;
  final Widget name;
  final Widget date;
  final Widget? content;
  final Widget? action;
  final Color? dividerColor;
  final bool dividerLeft;

  const _Item({
    required this.image,
    required this.name,
    required this.date,
    this.content,
    this.action,
    this.dividerColor,
    this.dividerLeft = true,
  });

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Column(
            children: [
              image,
              if (dividerLeft) ...[
                const SizedBox(height: 10),
                Expanded(
                    child: VerticalDivider(
                      width: 1,
                      thickness: 1,
                      color: dividerColor,
                    )
                ),
              ]
            ],
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 3),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [Expanded(child: name), const SizedBox(width: 8), date],
                ),
                if (content != null) ...[
                  const SizedBox(height: 8),
                  content!,
                ],
                if (action != null) ...[
                  const SizedBox(height: 16),
                  action!,
                ]
              ],
            ),
          ),
        ],
      ),
    );
  }
}