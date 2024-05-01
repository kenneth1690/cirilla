import 'package:cirilla/mixins/mixins.dart';
import 'package:cirilla/models/models.dart';
import 'package:cirilla/types/types.dart';
import 'package:cirilla/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:cirilla/constants/styles.dart';

import '../profile/user_content.dart';
import '../profile/button_signin.dart';
import '../profile/block_item_list.dart';

class LayoutStyle1 extends StatelessWidget with AppBarMixin {
  final bool isLogin;
  final Widget? footer;
  final List blocks;
  final List Function(List) getItems;
  final ShowMessageType? showMessage;
  final EdgeInsetsGeometry? padding;
  final User? user;
  final List<Widget> Function(Color?) actions;

  const LayoutStyle1({
    super.key,
    this.isLogin = false,
    this.blocks = const [],
    required this.getItems,
    this.user,
    this.footer,
    this.showMessage,
    this.padding,
    required this.actions,
  });

  @override
  Widget build(BuildContext context) {
    TranslateType translate = AppLocalizations.of(context)!.translate;

    String title = isLogin ? translate('profile_account_txt') : translate('profile_txt');

    return Scaffold(
      appBar: baseStyleAppBar(
        context,
        title: title,
        automaticallyImplyLeading: false,
        actions: actions(null),
      ),
      body: SingleChildScrollView(
        padding: padding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (isLogin) UserContent(user: user, type: UserContentType.container) else const ButtonSignin(),
            const SizedBox(height: 40),
            BlockItemList(blocks: blocks, getItems: getItems),
            if (footer is Widget) ...[
              const SizedBox(height: itemPaddingSmall),
              footer!,
            ],
            const SizedBox(height: itemPaddingLarge)
          ],
        ),
      ),
    );
  }
}
