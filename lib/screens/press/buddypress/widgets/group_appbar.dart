import 'package:cirilla/constants/constants.dart';
import 'package:cirilla/mixins/mixins.dart';
import 'package:cirilla/types/types.dart';
import 'package:cirilla/utils/utils.dart';
import 'package:feather_icons/feather_icons.dart';
import 'package:flutter/material.dart';
import 'package:ui/ui.dart';

import '../group_detail_info_screen.dart';
import '../group_detail_member_screen.dart';
import '../models/models.dart';
import '../mixins/mixins.dart';

class GroupAppbarWidget extends StatefulWidget {

  final BPGroup? group;

  const GroupAppbarWidget({
    Key? key,
    required this.group,
  }) : super(key: key);

  @override
  State<GroupAppbarWidget> createState() => _GroupAppbarWidgetState();
}

class _GroupAppbarWidgetState extends State<GroupAppbarWidget> with AppBarMixin, TransitionMixin, BPGroupMixin {
  final _popupMenu = GlobalKey<PopupMenuButtonState>();

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    TranslateType translate = AppLocalizations.of(context)!.translate;

    double width = MediaQuery.of(context).size.width;
    double height = (width * 219) / 375;

    double heightPlus = 32;

    Widget positionInfo = Positioned(
      bottom: 0,
      left: 20,
      right: 20,
      child: buildGroup(
        context,
        group: widget.group,
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
              child: buildBanner(data: widget.group),
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
                      translate("buddypress_group"),
                      style: theme.appBarTheme.titleTextStyle!.copyWith(color: Colors.white),
                    ),
                    centerTitle: true,
                    leading: leading(color: Colors.white),
                    backgroundColor: Colors.transparent,
                    elevation: 0,
                    actions: [Container()],
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
  Widget buildGroup(
      BuildContext context, {
        BPGroup? group,
        EdgeInsetsGeometry? padding,
        Color? color,
        Color? colorName,
        List<BoxShadow>? boxShadow,
        double? radius,
        required TranslateType translate,
      }
      ) {
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
                buildName(data: group, theme: theme),
                buildStatus(data: widget.group, theme: theme, translate: translate),
                const SizedBox(height: 8),
                buildAction(
                  context,
                  data: group,
                  child: Wrap(
                    spacing: 12,
                    runSpacing: 8,
                    children: [
                      // SizedBox(
                      //   height: 34,
                      //   child: ElevatedButton(
                      //     onPressed: () {},
                      //     style: ElevatedButton.styleFrom(
                      //       foregroundColor: theme.textTheme.titleMedium?.color,
                      //       backgroundColor: theme.colorScheme.surface,
                      //       textStyle: theme.textTheme.bodySmall,
                      //     ),
                      //     child: Row(
                      //       mainAxisSize: MainAxisSize.min,
                      //       children: [
                      //         const Icon(FeatherIcons.checkCircle, size: 14),
                      //         const SizedBox(width: 8),
                      //         Text(group?.status == "private" ? "Request member": 'Join'),
                      //       ],
                      //     ),
                      //   ),
                      // ),

                      PopupMenuButton<int>(
                        key: _popupMenu,
                        // Callback that sets the selected popup menu item.
                        onSelected: (int item) {
                          Navigator.push(
                            context,
                            PageRouteBuilder(
                              pageBuilder: (context, _, __) {
                                switch (item) {
                                  case 2:
                                    return BPMemberGroupDetailMemberScreen(
                                      group: widget.group,
                                    );
                                  default:
                                    return BPGroupDetailInfoScreen(
                                      group: widget.group,
                                    );
                                }
                              },
                              transitionsBuilder: slideTransition,
                            ),
                          );
                        },
                        itemBuilder: (BuildContext context) => <PopupMenuEntry<int>>[
                          PopupMenuItem<int>(
                            value: 1,
                            child: Text(translate("buddypress_info")),
                          ),
                          PopupMenuItem<int>(
                            value: 2,
                            child: Text(translate("buddypress_members")),
                          ),
                          // const PopupMenuItem<int>(
                          //   value: 3,
                          //   child: Text('Manage'),
                          // ),
                        ],
                        position: PopupMenuPosition.under,
                        offset: const Offset(0, 12),
                        child: SizedBox(
                          height: 34,
                          child: ElevatedButton(
                            onPressed: () => _popupMenu.currentState?.showButtonMenu(),
                            // onPressed: null,
                            style: ElevatedButton.styleFrom(textStyle: theme.textTheme.bodySmall),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(FeatherIcons.moreHorizontal, size: 14),
                                const SizedBox(width: 8),
                                Text(translate("buddypress_more")),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          buildAvatar(data: group, shimmerSize: 60),
        ],
      ),
    );
  }
}