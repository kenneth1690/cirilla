import 'package:cirilla/constants/constants.dart';
import 'package:cirilla/mixins/mixins.dart';
import 'package:cirilla/store/store.dart';
import 'package:cirilla/types/types.dart';
import 'package:cirilla/utils/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';

import '../bbpress/bbpress.dart';

class BPForumListScreen extends StatefulWidget {
  static const routeName = '/buddypress-forum-list';

  final SettingStore? store;

  const BPForumListScreen({
    super.key,
    this.store,
  });

  @override
  State<BPForumListScreen> createState() => _BPForumListScreenState();
}

class _BPForumListScreenState extends State<BPForumListScreen> with AppBarMixin {

  Widget buildTab({required String title}) {
    return Container(
      height: 40,
      alignment: Alignment.center,
      child: Text(
        title,
        style: const TextStyle(fontSize: 16),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    TranslateType translate = AppLocalizations.of(context)!.translate;

    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: AppBar(
          shadowColor: Colors.transparent,
          backgroundColor: theme.appBarTheme.backgroundColor,
          leading: leading(),
          centerTitle: true,
          title: Text(
            translate("buddypress_forums"),
            style: theme.appBarTheme.titleTextStyle,
          ),
          bottom: TabBar(
            isScrollable: true,
            labelPadding: const EdgeInsets.symmetric(horizontal: 20),
            labelColor: theme.primaryColor,
            labelStyle: theme.textTheme.titleSmall,
            unselectedLabelColor: theme.textTheme.titleSmall?.color,
            indicatorWeight: 2,
            indicatorColor: theme.primaryColor,
            tabs: [
              buildTab(title: translate("buddypress_forums_topic_started")),
              buildTab(title: translate("buddypress_forums_reply_created")),
              buildTab(title: translate("buddypress_forums_engagement")),
              buildTab(title: translate("buddypress_forums_favorite")),
            ],
          ),
        ),
        body: TabBarView(
          physics: const NeverScrollableScrollPhysics(),
          children: [
            _ListTopic(
              store: widget.store,
            ),
            _ListTopic(
              store: widget.store,
            ),
            _ListTopic(
              store: widget.store,
            ),
            _ListTopic(
              store: widget.store,
            ),
          ],
        ),
      ),
    );
  }
}

class _ListTopic extends StatefulWidget {
  final SettingStore? store;

  const _ListTopic({this.store});

  @override
  State<_ListTopic> createState() => _ListTopicState();
}

class _ListTopicState extends State<_ListTopic> with LoadingMixin {
  final ScrollController _controller = ScrollController();
  late BBPTopicStore _topicStore;

  @override
  void initState() {
    _topicStore = BBPTopicStore(
      widget.store!.requestHelper,
    )..getTopics();
    _controller.addListener(_onScroll);
    super.initState();
  }

  void _onScroll() {
    if (!_controller.hasClients || _topicStore.loading || !_topicStore.canLoadMore) return;
    final thresholdReached = _controller.position.extentAfter < endReachedThreshold;

    if (thresholdReached) {
      _topicStore.getTopics();
    }
  }

  @override
  void dispose() {
    _topicStore.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Observer(
      builder: (_) {
        bool loading = _topicStore.loading;
        List<BBPTopic> topics = _topicStore.topics;

        List<BBPTopic> emptyTopic =
        List.generate(_topicStore.perPage, (index) => BBPTopic()).toList();

        List<BBPTopic> data = loading && topics.isEmpty ? emptyTopic : topics;

        return CustomScrollView(
          controller: _controller,
          slivers: [
            CupertinoSliverRefreshControl(
              onRefresh: _topicStore.refresh,
              builder: buildAppRefreshIndicator,
            ),
            if (data.isNotEmpty)
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate(
                        (_, index) {
                      return TopicItemWidget(topic: data[index]);
                    },
                    childCount: data.length,
                  ),
                ),
              )
            else
              SliverPadding(
                padding: const EdgeInsets.symmetric(vertical: 50),
                sliver: SliverToBoxAdapter(
                  child: Center(
                    child: Text(AppLocalizations.of(context)!.translate("buddypress_empty")),
                  ),
                ),
              ),
            if (loading && topics.isNotEmpty)
              SliverToBoxAdapter(
                child: buildLoading(context, isLoading: _topicStore.canLoadMore),
              ),
          ],
        );
      },
    );
  }
}
