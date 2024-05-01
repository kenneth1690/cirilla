import 'package:cirilla/models/models.dart';
import 'package:cirilla/types/types.dart';
import 'package:cirilla/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:cirilla/constants/styles.dart';

import '../profile/button_signin.dart';
import '../profile/user_content.dart';
import '../profile/block_item_list.dart';

class LayoutStyle2 extends StatelessWidget {
  final bool isLogin;
  final Widget? footer;
  final List blocks;
  final List Function(List) getItems;
  final ShowMessageType? showMessage;
  final EdgeInsetsGeometry? padding;
  final User? user;
  final List<Widget> Function(Color?) actions;

  const LayoutStyle2({
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
    ThemeData theme = Theme.of(context);

    Color colorAppbar = theme.colorScheme.onPrimary;

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          if (isLogin)
            buildAppbar(
              title: UserContent(
                user: user,
                type: UserContentType.container,
                padding: const EdgeInsetsDirectional.only(end: layoutPadding),
                backgroundColor: Colors.transparent,
                color: colorAppbar,
              ),
              actionsData: actions(colorAppbar),
              pad: itemPaddingSmall,
              toolbarHeight: 110,
              theme: theme,
            )
          else
            buildAppbar(
              title: Text(
                translate('profile_txt'),
                style: theme.appBarTheme.titleTextStyle?.copyWith(color: colorAppbar),
              ),
              actionsData: actions(colorAppbar),
              theme: theme,
              toolbarHeight: 80,
            ),
          SliverPadding(
            padding: padding ?? EdgeInsets.zero,
            sliver: SliverToBoxAdapter(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (!isLogin) ...[
                    ButtonSignin(
                      pad: itemPaddingMedium,
                      showMessage: showMessage,
                    ),
                    const SizedBox(height: 40),
                    // BlockItemList(blocks: logoutBlock),
                  ],
                  BlockItemList(blocks: blocks, getItems: getItems),
                  if (footer != null) ...[
                    const SizedBox(height: itemPaddingSmall),
                    footer!,
                  ],
                  const SizedBox(height: itemPaddingLarge),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  SliverAppBar buildAppbar({
    required Widget title,
    required List<Widget> actionsData,
    double pad = itemPadding,
    required ThemeData theme,
    required double toolbarHeight,
  }) {
    return SliverAppBar(
      toolbarHeight: toolbarHeight,
      flexibleSpace: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Padding(
            padding: EdgeInsetsDirectional.fromSTEB(20, 0, 0, pad),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(child: title),
                Row(mainAxisSize: MainAxisSize.min, children: actionsData),
              ],
            ),
          ),
          PreferredSize(
            preferredSize: const Size.fromHeight(24),
            child: Container(
              height: 24,
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(24),
                  topRight: Radius.circular(24),
                ),
                color: theme.scaffoldBackgroundColor,
              ),
            ),
          ),
        ],
      ),
      backgroundColor: theme.primaryColor,
    );
  }
}
