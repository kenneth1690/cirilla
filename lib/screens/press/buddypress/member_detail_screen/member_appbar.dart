import 'package:flutter/material.dart';

import '../models/models.dart';

import 'constants.dart';
import 'member_appbar_style1.dart';
import 'member_appbar_style2.dart';

class MemberAppbarWidget extends StatelessWidget {
  final BPMember? member;
  final String? banner;
  final Function(int? id, String slug)? callback;
  final String type;
  final bool enableMentionName;
  final bool enablePublishMessage;
  final bool enablePrivateMessage;

  const MemberAppbarWidget({
    super.key,
    required this.member,
    this.banner,
    this.callback,
    this.type = typeViewStyle1,
    this.enableMentionName = true,
    this.enablePublishMessage = true,
    this.enablePrivateMessage = true,
  });

  @override
  Widget build(BuildContext context) {
    if (type == typeViewStyle2) {
      return MemberAppbarStyle2Widget(
        member: member,
        banner: banner,
        callback: callback,
        enableMentionName: enableMentionName,
        enablePublishMessage: enablePublishMessage,
        enablePrivateMessage: enablePrivateMessage,
      );
    }
    return MemberAppbarStyle1Widget(
      member: member,
      banner: banner,
      callback: callback,
      enableMentionName: enableMentionName,
      enablePublishMessage: enablePublishMessage,
      enablePrivateMessage: enablePrivateMessage,
    );
  }
}