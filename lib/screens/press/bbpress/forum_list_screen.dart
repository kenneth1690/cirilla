import 'package:cirilla/constants/constants.dart';
import 'package:cirilla/mixins/mixins.dart';
import 'package:cirilla/store/store.dart';
import 'package:cirilla/types/types.dart';
import 'package:cirilla/utils/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';

import 'models/models.dart';
import 'stores/stores.dart';
import 'widgets/widgets.dart';

class BBPForumListScreen extends StatefulWidget {
  static const routeName = '/bbpress-forum-list';

  final SettingStore? store;

  const BBPForumListScreen({
    super.key,
    this.store,
  });

  @override
  State<BBPForumListScreen> createState() => _BBPForumListScreenState();
}

class _BBPForumListScreenState extends State<BBPForumListScreen> with AppBarMixin, LoadingMixin {
  late BBPForumStore _forumStore;
  final ScrollController _controller = ScrollController();

  @override
  void initState() {
    _controller.addListener(_onScroll);
    super.initState();
  }

  @override
  void didChangeDependencies() {
    _forumStore = BBPForumStore(widget.store!.requestHelper)..getForums();
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _forumStore.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (!_controller.hasClients || _forumStore.loading || !_forumStore.canLoadMore) return;
    final thresholdReached = _controller.position.extentAfter < endReachedThreshold;

    if (thresholdReached) {
      _forumStore.getForums();
    }
  }

  @override
  Widget build(BuildContext context) {
    TranslateType translate = AppLocalizations.of(context)!.translate;

    return Scaffold(
      appBar: baseStyleAppBar(context, title: translate("bbpress_forum_list")),
      body: Observer(
        builder: (_) {
          bool loading = _forumStore.loading;
          List<BBPForum> forums = _forumStore.members;
          List<BBPForum> emptyForum = List.generate(_forumStore.perPage, (index) => BBPForum()).toList();

          List<BBPForum> data = loading && forums.isEmpty ? emptyForum : forums;
          return CustomScrollView(
            controller: _controller,
            slivers: [
              CupertinoSliverRefreshControl(
                onRefresh: _forumStore.refresh,
                builder: buildAppRefreshIndicator,
              ),
              if (data.isNotEmpty)
                SliverPadding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  sliver: SliverList(
                    delegate: SliverChildBuilderDelegate(
                          (_, index) => ForumItemWidget(forum: data[index]),
                      childCount: data.length,
                    ),
                  ),
                )
              else
                SliverToBoxAdapter(
                  child: Center(
                    child: Text(translate("buddypress_empty")),
                  ),
                ),
              if (loading && forums.isNotEmpty)
                SliverToBoxAdapter(
                  child: buildLoading(context, isLoading: _forumStore.canLoadMore),
                ),
            ],
          );
        },
      ),
    );
  }
}
