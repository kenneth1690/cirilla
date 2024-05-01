import 'package:cirilla/mixins/mixins.dart';
import 'package:cirilla/types/types.dart';
import 'package:cirilla/utils/utils.dart';
import 'package:cirilla/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';

import 'models/models.dart';
import 'mixins/mixins.dart';

class BPGroupDetailInfoScreen extends StatelessWidget with AppBarMixin, BPGroupMixin {
  final BPGroup? group;

  const BPGroupDetailInfoScreen({super.key, this.group});

  Widget buildRow({required String title, required Widget content, required ThemeData theme, bool enableDivider = true}) {
    return Column(
      children: [
        IntrinsicHeight(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  child: Text(title, style: theme.textTheme.titleSmall),
                ),
              ),
              const VerticalDivider(width: 30, thickness: 1),
              Expanded(
                flex: 3,
                child:  Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [content],
                  )
                ),
              )
            ],
          ),
        ),
        if (enableDivider) const Divider(height: 1, thickness: 1)
      ],
    );
  }
  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    TranslateType translate = AppLocalizations.of(context)!.translate;

    TextStyle textStyle = theme.textTheme.bodyMedium ?? const TextStyle();
    Style style = Style(
      margin: EdgeInsets.zero,
      padding: EdgeInsets.zero,
      fontFamily: textStyle.fontFamily,
      fontSize: FontSize(textStyle.fontSize),
      fontWeight: textStyle.fontWeight,
      color: textStyle.color,
    );

    return Scaffold(
      appBar: baseStyleAppBar(context, title: translate("buddypress_info")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            buildRow(
              title: translate("buddypress_name"),
              content: Text(group?.name ?? "",  style: theme.textTheme.bodyMedium),
              theme: theme,
            ),
            buildRow(
              title: translate("buddypress_avatar"),
              content: CirillaCacheImage(group?.avatar, width: 150, height: 150),
              theme: theme,
            ),
            buildRow(
              title: translate("buddypress_status"),
              content: Text(translate(getKeyTextStatus(group?.status)),  style: theme.textTheme.bodyMedium),
              theme: theme,
            ),
            buildRow(
              title: translate("buddypress_description"),
              content: CirillaHtml(
                html: group?.description ?? "",
                style: {
                  "html": style,
                  "body": style,
                  "div": style,
                  "p": style,
                },
              ),
              theme: theme,
            ),
            buildRow(
              title: translate("buddypress_members"),
              content: Text("${group?.memberCount ?? 0}",  style: theme.textTheme.bodyMedium),
              theme: theme,
            ),
            buildRow(
              title: translate("buddypress_create_at"),
              content: Text(dateAgo(context, date: group?.createdAt),  style: theme.textTheme.bodyMedium),
              theme: theme,
            ),
            buildRow(
              title: translate("buddypress_last_active"),
              content: Text(dateAgo(context, date: group?.lastActivity),  style: theme.textTheme.bodyMedium),
              theme: theme,
            ),
          ],
        ),
      ),
    );
  }
}