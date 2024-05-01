import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:cirilla/models/models.dart';
import 'package:cirilla/types/types.dart';
import 'package:cirilla/utils/utils.dart';
import 'package:cirilla/constants/styles.dart';
import 'package:ui/ui.dart';

import '../profile/user_content.dart';
import '../profile/block_item_list.dart';

class LayoutStyle3 extends StatelessWidget {
  final bool isLogin;
  final Widget? footer;
  final List blocks;
  final List Function(List) getItems;
  final ShowMessageType? showMessage;
  final EdgeInsetsGeometry? padding;
  final User? user;
  final List<Widget> Function(Color?) actions;

  const LayoutStyle3({
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

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          buildAppbar(
            title: isLogin ? translate('profile_account_txt') : translate('profile_txt'),
            actions: actions(theme.colorScheme.onPrimary),
            content: isLogin
                ? UserContent(
                    user: user,
                    type: UserContentType.emerge,
                  )
                : const UserContentEmergeNoGuest(),
            theme: theme,
          ),
          SliverPadding(
            padding: padding ?? EdgeInsets.zero,
            sliver: SliverToBoxAdapter(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
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
    required String title,
    required Widget content,
    required ThemeData theme,
    List<Widget>? actions,
  }) {
    return SliverAppBar(
      toolbarHeight: 235,
      flexibleSpace: Stack(
        clipBehavior: Clip.none,
        children: [
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              height: 35,
              color: theme.scaffoldBackgroundColor,
            ),
          ),
          Positioned(
            bottom: 35,
            left: 0,
            right: 0,
            child: Transform.rotate(
              angle: -math.pi,
              child: ClipPath(
                clipper: CurveInConvex(),
                child: Container(
                  width: double.infinity,
                  height: 35,
                  color: theme.scaffoldBackgroundColor,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsetsDirectional.fromSTEB(20, 0, 0, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      child: Text(
                        title,
                        style: theme.textTheme.headlineSmall
                            ?.copyWith(color: theme.colorScheme.onPrimary, fontWeight: FontWeight.w600),
                      ),
                    ),
                    if (actions?.isNotEmpty == true)
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: actions!,
                      )
                  ],
                ),
                const SizedBox(height: 56),
                Padding(
                  padding: const EdgeInsetsDirectional.only(end: 20),
                  child: Center(
                    child: Container(
                      constraints: const BoxConstraints(maxWidth: 400),
                      child: content,
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
      backgroundColor: theme.primaryColor,
    );
  }
}
