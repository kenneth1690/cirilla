import 'package:cirilla/models/models.dart';
import 'package:cirilla/types/types.dart';
import 'package:cirilla/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:cirilla/constants/styles.dart';

import '../profile/user_content.dart';
import '../profile/button_signin.dart';
import '../profile/block_item_carousel.dart';

class LayoutStyle4 extends StatelessWidget {
  final bool isLogin;
  final Widget? footer;
  final List blocks;
  final List Function(List) getItems;
  final ShowMessageType? showMessage;
  final EdgeInsetsGeometry? padding;
  final User? user;
  final List<Widget> Function(Color?)   actions;

  const LayoutStyle4({
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

    return Scaffold(
      appBar: AppBar(
        title: isLogin ? UserContent(user: user) : Text(translate('profile_txt')),
        automaticallyImplyLeading: false,
        actions:actions(null),
        centerTitle: !isLogin,
        shadowColor: Colors.transparent,
        titleSpacing: layoutPadding,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: padding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (isLogin) ...[
              const Divider(thickness: 6, height: itemPadding),
              const SizedBox(height: itemPaddingMedium),
            ] else ...[
              ButtonSignin(
                pad: itemPaddingMedium,
                showMessage: showMessage,
              ),
              const SizedBox(height: itemPaddingExtraLarge),
              const Divider(thickness: 6, height: itemPadding),
              const SizedBox(height: itemPaddingMedium),
            ],
            BlockItemCarousel(
              blocks: blocks,
              getItems: getItems,
              separator: const Column(
                children: [
                  SizedBox(height: itemPaddingMedium),
                  Divider(thickness: 6, height: itemPadding),
                  SizedBox(height: itemPaddingSmall),
                ],
              ),
              padding: const EdgeInsets.symmetric(horizontal: itemPaddingSmall),
            ),
            const SizedBox(height: itemPaddingMedium),
            const Divider(thickness: 6, height: itemPadding),
            const SizedBox(height: itemPaddingSmall),
            if (footer != null) footer!,
          ],
        ),
      ),
    );
  }
}
