import 'package:cirilla/constants/constants.dart';
import 'package:cirilla/mixins/mixins.dart';
import 'package:cirilla/screens/press/constants.dart';
import 'package:cirilla/store/store.dart';
import 'package:cirilla/types/types.dart';
import 'package:cirilla/utils/utils.dart';
import 'package:feather_icons/feather_icons.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ui/ui.dart';

import '../../better_messages/better_messages.dart';
import '../buddypress.dart';
import '../mixins/mixins.dart';
import '../widgets/widgets.dart';

class MemberAppbarStyle2Widget extends StatefulWidget {
  final BPMember? member;
  final String? banner;
  final Function(int? id, String slug)? callback;
  final bool enableMentionName;
  final bool enablePublishMessage;
  final bool enablePrivateMessage;

  const MemberAppbarStyle2Widget({
    Key? key,
    required this.member,
    this.banner,
    this.callback,
    this.enableMentionName = true,
    this.enablePublishMessage = true,
    this.enablePrivateMessage = true,
  }) : super(key: key);

  @override
  State<MemberAppbarStyle2Widget> createState() => _MemberAppbarStyle2WidgetState();
}

class _MemberAppbarStyle2WidgetState extends State<MemberAppbarStyle2Widget>
    with AppBarMixin, BPMemberMixin, LoadingMixin, TransitionMixin {
  final _popupMenu = GlobalKey<PopupMenuButtonState>();

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    TranslateType translate = AppLocalizations.of(context)!.translate;

    AuthStore authStore = Provider.of<AuthStore>(context);
    SettingStore settingStore = Provider.of<SettingStore>(context);

    double width = MediaQuery.of(context).size.width;
    double height = (width * 219) / 375;

    double heightPlus = 32;

    Widget positionInfo = Positioned(
      bottom: 0,
      left: 20,
      right: 20,
      child: buildMember(
        context,
        member: widget.member,
        color: theme.cardColor,
        padding: paddingHorizontal.add(paddingVerticalLarge),
        radius: 8,
        boxShadow: initBoxShadow,
        translate: translate,
      ),
    );

    double heightView = height + heightPlus;

    return SliverPersistentHeader(
      pinned: false,
      floating: false,
      delegate: StickyTabBarDelegate(
        child: Stack(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(bottom: heightPlus),
              child: buildBanner(
                banner: widget.banner,
                shimmerWidth: double.infinity,
                shimmerHeight: double.infinity,
                loading: false,
              ),
            ),
            Container(
              decoration: overlayContainer,
              margin: EdgeInsets.only(bottom: heightPlus),
            ),
            positionInfo,
            Positioned(
              child: Column(
                children: [
                  AppBar(
                    title: Text(
                      widget.member?.name ?? "",
                      style: theme.appBarTheme.titleTextStyle!.copyWith(color: Colors.white),
                    ),
                    centerTitle: true,
                    leading: leading(color: Colors.white),
                    backgroundColor: Colors.transparent,
                    elevation: 0,
                    actions: [
                      if (authStore.isLogin && authStore.user?.id != "${widget.member?.id}")
                        MemberButtonFriendSlugWidget(
                          id: widget.member?.id,
                          slug: widget.member?.friendshipStatusSlug ?? "not_friends",
                          callback: widget.callback,
                          onRenderChild: (String title, Function onClick, bool loading) {
                            return PopupMenuButton<int>(
                              key: _popupMenu,
                              // Callback that sets the selected popup menu item.
                              onSelected: (int item) {
                                if (item == 1) {
                                  if (!loading) {
                                    onClick();
                                  }
                                } else {
                                  Navigator.push(
                                    context,
                                    PageRouteBuilder(
                                      pageBuilder: (context, _, __) {
                                        switch (item) {
                                          case 3:
                                            if (messagePlugin == "BetterMessages") {
                                              return BMMessageListScreen(
                                                store: settingStore,
                                                args: {
                                                  "send": widget.member,
                                                },
                                              );
                                            }
                                            return BPMessageListScreen(
                                              store: settingStore,
                                              args: {
                                                "send": widget.member,
                                              },
                                            );
                                          default:
                                            return BPActivityListScreen(
                                              store: settingStore,
                                              args: {
                                                "mentionName": widget.member?.mentionName,
                                              },
                                            );
                                        }
                                      },
                                      transitionsBuilder: slideTransition,
                                    ),
                                  );
                                }
                              },
                              itemBuilder: (BuildContext context) => <PopupMenuEntry<int>>[
                                PopupMenuItem<int>(
                                  value: 1,
                                  child: loading ? Center(child: iOSLoading(context, size: 10)) : Text(title),
                                ),
                                if (widget.enablePublishMessage)
                                  PopupMenuItem<int>(
                                    value: 2,
                                    child: Text(translate("buddypress_publish_message")),
                                  ),
                                if (widget.enablePrivateMessage)
                                  PopupMenuItem<int>(
                                    value: 3,
                                    child: Text(translate("buddypress_private_message")),
                                  ),
                              ],
                              position: PopupMenuPosition.under,
                              offset: const Offset(0, 12),
                              child: IconButton(
                                onPressed: () => _popupMenu.currentState?.showButtonMenu(),
                                icon: const Icon(FeatherIcons.moreHorizontal, size: 22, color: Colors.white),
                              ),
                            );
                          },
                        ),
                      const SizedBox(width: 8),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
        height: heightView,
      ),
    );
  }

  Widget buildMember(
    BuildContext context, {
    BPMember? member,
    EdgeInsetsGeometry? padding,
    Color? color,
    Color? colorName,
    List<BoxShadow>? boxShadow,
    double? radius,
    required TranslateType translate,
  }) {
    ThemeData theme = Theme.of(context);

    return Container(
      padding: padding,
      decoration: BoxDecoration(color: color, boxShadow: boxShadow, borderRadius: BorderRadius.circular(radius ?? 0)),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (widget.enableMentionName) buildMentionName(data: member, theme: theme),
                buildDate(data: member, theme: theme, translate: translate),
              ],
            ),
          ),
          const SizedBox(width: 16),
          buildImage(data: member, shimmerSize: 60),
        ],
      ),
    );
  }
}
