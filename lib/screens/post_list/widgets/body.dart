import 'package:cirilla/constants/constants.dart';
import 'package:cirilla/constants/strings.dart';
import 'package:cirilla/mixins/mixins.dart';
import 'package:cirilla/models/models.dart';
import 'package:cirilla/screens/search/search_feature.dart';
import 'package:cirilla/store/store.dart';
import 'package:cirilla/types/types.dart';
import 'package:cirilla/utils/utils.dart';
import 'package:cirilla/widgets/cirilla_icon_builder.dart';
import 'package:feather_icons/feather_icons.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:ui/notification/notification_screen.dart';
import 'package:ui/ui.dart';

import 'item.dart';

class Body extends StatefulWidget {
  final PostStore? store;
  final Widget? sort;
  final Widget? refine;
  final bool? loading;
  final List layout;
  final Map<String, dynamic>? configs;
  final Map<String, dynamic>? styles;
  final String? title;

  const Body({
    Key? key,
    required this.layout,
    this.store,
    this.sort,
    this.refine,
    this.loading,
    this.configs,
    this.styles,
    this.title,
  }) : super(key: key);

  @override
  State<Body> createState() => _BodyState();
}

class _BodyState extends State<Body> with LoadingMixin, AppBarMixin, Utility, HeaderListMixin, NavigationMixin {
  // final PostSearchDelegate _delegate = PostSearchDelegate();

  late int type;
  final ScrollController _controller = ScrollController();

  @override
  void initState() {
    super.initState();
    int visitActive = widget.layout.isNotEmpty ? widget.layout.indexWhere((e) => get(e, ["active"], false) == true) : 0;
    type = visitActive > -1 ? visitActive : widget.layout.length - 1;
    _controller.addListener(_onScroll);
  }

  @override
  void didUpdateWidget(covariant Body oldWidget) {
    if (!listEquals(oldWidget.layout, widget.layout)) {
      int visitActive =
          widget.layout.isNotEmpty ? widget.layout.indexWhere((e) => get(e, ["active"], false) == true) : 0;
      setState(() {
        type = visitActive > -1 ? visitActive : widget.layout.length - 1;
      });
    }
    super.didUpdateWidget(oldWidget);
  }

  void updateType(int value) {
    setState(() {
      type = value;
    });
  }

  void _onScroll() {
    if (!_controller.hasClients || widget.loading! || !widget.store!.canLoadMore) return;
    final thresholdReached = _controller.position.extentAfter < endReachedThreshold;

    if (thresholdReached) {
      widget.store!.getPosts();
    }
  }

  void removeSelectedCategory(PostCategory category) {
    List<PostCategory?> selected = List<PostCategory?>.of(widget.store!.categorySelected);
    selected.removeWhere((element) => element!.id == category.id);
    widget.store!.onChanged(categorySelected: selected);
  }

  void removeSelectedTag(PostTag tag) {
    List<PostTag?> selected = List<PostTag?>.of(widget.store!.tagSelected);
    selected.removeWhere((element) => element!.id == tag.id);
    widget.store!.onChanged(tagSelected: selected);
  }

  void clearAll() {
    widget.store!.onChanged(tagSelected: [], categorySelected: []);
  }

  Widget buildAppbar(BuildContext context, {required TranslateType translate}) {
    bool enableAppbarSearch = get(widget.configs, ['enableAppbarSearch'], true);
    bool? enableCenterTitle = get(widget.configs, ['enableCenterTitle'], true);
    String? appBarType = get(widget.configs, ['appBarType'], Strings.appbarFloating);
    // bool extendBodyBehindAppBar = get(widget.configs, ['extendBodyBehindAppBar'], true);

    Widget title = Text(widget.title ?? translate('post_list_txt'));

    List<Widget>? actions = enableAppbarSearch
        ? [
            const Padding(
              padding: EdgeInsetsDirectional.symmetric(horizontal: 8),
              child: SizedBox(
                width: 40,
                child: SearchFeature(
                  enableSearchPost: true,
                  child: Icon(FeatherIcons.search, size: 20),
                ),
              ),
            )
          ]
        : null;
    return SliverAppBar(
      leading: leading(),
      title: title,
      floating: appBarType == Strings.appbarFloating,
      elevation: 0,
      primary: true,
      centerTitle: enableCenterTitle,
      actions: actions,
    );
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    MediaQueryData mediaQuery = MediaQuery.of(context);
    TranslateType translate = AppLocalizations.of(context)!.translate;

    List<Post> posts = widget.store!.posts;

    bool isFilter = widget.store!.categorySelected.isNotEmpty || widget.store!.tagSelected.isNotEmpty;

    // width item
    double padHorizontal = layoutPadding;
    double widthItem = mediaQuery.size.width - 2 * padHorizontal;

    return CustomScrollView(
      physics: const BouncingScrollPhysics(),
      controller: _controller,
      slivers: <Widget>[
        buildAppbar(context, translate: translate),
        SliverPersistentHeader(
          pinned: false,
          floating: true,
          delegate: StickyTabBarDelegate(
            child: buildHeader(context, translate: translate, layout: widget.layout),
          ),
        ),
        if (isFilter)
          SliverPadding(
            padding: const EdgeInsets.only(top: 24),
            sliver: SliverPersistentHeader(
              pinned: false,
              floating: true,
              delegate: StickyTabBarDelegate(
                child: Container(
                  alignment: Alignment.centerLeft,
                  child: ListView(
                    padding: const EdgeInsetsDirectional.only(start: 20, end: 12),
                    scrollDirection: Axis.horizontal,
                    children: [
                      InputChip(
                        label: Text(translate('product_clear_all')),
                        deleteIcon: const Icon(FeatherIcons.x, size: 16),
                        onPressed: clearAll,
                        labelPadding: EdgeInsets.zero,
                        padding: paddingHorizontalMedium,
                        backgroundColor: Colors.transparent,
                        labelStyle: theme.textTheme.bodySmall
                            ?.copyWith(fontWeight: FontWeight.w500, color: theme.textTheme.titleMedium?.color),
                        side: BorderSide(width: 2, color: theme.dividerColor),
                        elevation: 0,
                        shadowColor: Colors.transparent,
                      ),
                      const SizedBox(width: 8),
                      ...List.generate(widget.store!.categorySelected.length, (index) {
                        PostCategory cat = widget.store!.categorySelected[index]!;

                        return Padding(
                          padding: const EdgeInsetsDirectional.only(end: 8),
                          child: InputChip(
                            label: Row(
                              children: [
                                Text(cat.name!),
                                const SizedBox(width: 8),
                                const Icon(Icons.clear, size: 14),
                              ],
                            ),
                            onPressed: () => removeSelectedCategory(cat),
                            labelPadding: EdgeInsets.zero,
                            padding: paddingHorizontalMedium,
                            backgroundColor: theme.colorScheme.surface,
                            labelStyle: theme.textTheme.bodySmall
                                ?.copyWith(fontWeight: FontWeight.w500, color: theme.textTheme.titleMedium?.color),
                            side: BorderSide(width: 2, color: theme.dividerColor),
                            elevation: 0,
                            shadowColor: Colors.transparent,
                          ),
                        );
                      }).toList(),
                      ...List.generate(widget.store!.tagSelected.length, (index) {
                        PostTag tag = widget.store!.tagSelected[index]!;
                        return Padding(
                          padding: const EdgeInsetsDirectional.only(end: 8),
                          child: InputChip(
                            label: Row(
                              children: [
                                Text(tag.name!),
                                const SizedBox(width: 8),
                                const Icon(Icons.clear, size: 14),
                              ],
                            ),
                            onPressed: () => removeSelectedTag(tag),
                            labelPadding: EdgeInsets.zero,
                            padding: paddingHorizontalMedium,
                            backgroundColor: theme.colorScheme.surface,
                            labelStyle: theme.textTheme.bodySmall
                                ?.copyWith(fontWeight: FontWeight.w500, color: theme.textTheme.titleMedium?.color),
                            side: BorderSide(width: 2, color: theme.dividerColor),
                            elevation: 0,
                            shadowColor: Colors.transparent,
                          ),
                        );
                      }).toList(),
                    ],
                  ),
                ),
                height: 34,
              ),
            ),
          ),
        CupertinoSliverRefreshControl(
          onRefresh: widget.store!.refresh,
          builder: buildAppRefreshIndicator,
        ),
        if (widget.layout.isNotEmpty) ...[
          SliverPadding(
            padding: paddingVerticalLarge.copyWith(left: padHorizontal, right: padHorizontal),
            sliver: widget.loading != true && posts.isEmpty
                ? SliverToBoxAdapter(
                    child: NotificationScreen(
                      title: Text(
                        translate('post'),
                        style: Theme.of(context).textTheme.titleLarge,
                        textAlign: TextAlign.center,
                      ),
                      content: Text(
                        translate('post_no_posts_were_found_matching'),
                        style: Theme.of(context).textTheme.bodyMedium,
                        textAlign: TextAlign.center,
                      ),
                      iconData: FeatherIcons.rss,
                      textButton: Text(translate('post_category')),
                      onPressed: () => navigate(context, {
                        "type": "tab",
                        "router": "/",
                        "args": {"key": "screens_category"}
                      }),
                    ),
                  )
                : SliverList(
                    // Use a delegate to build items as they're scrolled on screen.
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        Map? template = get(widget.layout[type], ["data", "template"]);
                        return ItemPost(
                          index: index,
                          post: widget.loading! && posts.isEmpty ? Post() : posts[index],
                          template: template,
                          styles: widget.styles,
                          width: widthItem,
                        );
                      },
                      childCount: widget.loading! && posts.isEmpty ? 10 : posts.length,
                    ),
                  ),
          ),
          if (widget.loading! && posts.isNotEmpty)
            SliverToBoxAdapter(
              child: buildLoading(context, isLoading: widget.store!.canLoadMore),
            ),
        ]
      ],
    );
  }

  Widget buildHeader(BuildContext context, {required TranslateType translate, required List layout}) {
    List<IconData> iconLayout = layout
        .map((l) {
          Map? icon = get(l, [
            "data",
            'icon'
          ], {
            "name": "square",
            "type": "feather",
          });
          return getIconData(data: icon) ?? FeatherIcons.square;
        })
        .toList()
        .cast<IconData>();
    return buildBoxHeader(
      context,
      left: Row(
        children: [
          buildButtonIcon(context, icon: FeatherIcons.barChart2, title: translate('product_list_sort'), onPressed: () {
            showModalBottomSheet(
              // isScrollControlled: true,
              context: context,
              shape: const RoundedRectangleBorder(borderRadius: borderRadiusExtraLarge),
              builder: (context) {
                // Using Wrap makes the bottom sheet height the height of the content.
                // Otherwise, the height will be half the height of the screen.
                return widget.sort!;
              },
            );
          }),
          const SizedBox(width: 8),
          buildButtonIcon(
            context,
            icon: FeatherIcons.sliders,
            title: translate('product_list_refine'),
            onPressed: () async {
              Map<String, dynamic>? data = await showModalBottomSheet<Map<String, dynamic>>(
                isScrollControlled: true,
                context: context,
                shape: const RoundedRectangleBorder(borderRadius: borderRadiusExtraLarge),
                builder: (context) {
                  // Using Wrap makes the bottom sheet height the height of the content.
                  // Otherwise, the height will be half the height of the screen.
                  return widget.refine!;
                },
              );
              if (data == null) return;

              widget.store!.onChanged(
                categorySelected: data['categories'],
                tagSelected: data['tags'],
              );
            },
          ),
        ],
      ),
      right: iconLayout.isNotEmpty
          ? buildGroupButtonIcon(
              context,
              icons: iconLayout,
              visitSelect: type,
              onChange: (int value) => setState(() {
                type = value;
              }),
            )
          : null,
    );
  }
}
