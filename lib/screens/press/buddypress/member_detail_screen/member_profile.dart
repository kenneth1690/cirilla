import 'package:cirilla/mixins/mixins.dart';
import 'package:cirilla/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';

import '../models/models.dart';
import '../mixins/mixins.dart';

class MemberProfile extends StatelessWidget with AppBarMixin, BPGroupMixin {
  final BPMember? member;

  const MemberProfile({super.key, this.member});

  Widget buildRow({required String title, required Widget content, required ThemeData theme, bool enableDivider = true}) {
    return Column(
      children: [
        IntrinsicHeight(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              SizedBox(
                width: 100,
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

    TextStyle textStyle = theme.textTheme.bodyMedium ?? const TextStyle();
    Style style = Style(
      margin: EdgeInsets.zero,
      padding: EdgeInsets.zero,
      fontFamily: textStyle.fontFamily,
      fontSize: FontSize(textStyle.fontSize),
      fontWeight: textStyle.fontWeight,
      color: textStyle.color,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (member?.profile?.isNotEmpty == true)
          ...member!.profile!.map((e) {
            List<BPMemberProfileField> fields = e.fields?.where((element) => element.value?.isNotEmpty == true).toList() ?? [];

            if (fields.isEmpty) {
              return Container();
            }

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(e.name ?? "", style: theme.textTheme.titleLarge),
                const SizedBox(height: 8),
                ...fields.map((field) {
                  return buildRow(
                    title: field.name ?? "",
                    content: CirillaHtml(
                      html: field.value ?? "",
                      style: {
                        "html": style,
                        "body": style,
                        "div": style,
                        "p": style,
                      },
                    ),
                    theme: theme,
                  );
                }).toList(),
              ],
            );
          }).toList(),
      ],
    );
  }
}