import 'package:awesome_icons/awesome_icons.dart';
import 'package:cirilla/constants/constants.dart';
import 'package:cirilla/mixins/mixins.dart';
import 'package:cirilla/store/store.dart';
import 'package:cirilla/types/types.dart';
import 'package:cirilla/utils/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/provider.dart';

import 'models/models.dart';
import 'stores/stores.dart';
import 'topic_create_screen.dart';
import 'widgets/widgets.dart';

class BBPForumDetailScreen extends StatefulWidget {
  static const routeName = '/bbpress-forum-detail';

  final SettingStore? store;
  final Map? args;

  const BBPForumDetailScreen({
    super.key,
    this.store,
    this.args,
  });

  @override
  State<BBPForumDetailScreen> createState() => _BBPForumDetailScreenState();
}

class _BBPForumDetailScreenState extends State<BBPForumDetailScreen> with AppBarMixin, SnackMixin, LoadingMixin {
  late BBPTopicForumStore _topicStore;

  @override
  void didChangeDependencies() {
    BBPForum? forum;
    bool enableUpdateForum = true;
    if (widget.args?['forum'] is BBPForum) {
      forum = widget.args!['forum'];
      enableUpdateForum = false;
    } else if (ConvertData.stringToInt(widget.args?["id"]) != 0) {
      forum = BBPForum(
        id: ConvertData.stringToInt(widget.args?["id"])
      );
    }
    _topicStore = BBPTopicForumStore(widget.store!.requestHelper, forum: forum, enableUpdateForum: enableUpdateForum);
    if (forum?.type != "category") {
      _topicStore.getTopics();
    }

    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _topicStore.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    TranslateType translate = AppLocalizations.of(context)!.translate;

    return Observer(
      builder: (_) {
        if (_topicStore.loading && _topicStore.enableUpdateForum) {
          return Scaffold(
            appBar: baseStyleAppBar(context, title: ""),
            body: Center(
              child: buildLoading(context, isLoading: _topicStore.loading),
            ),
          );
        }

        if (!_topicStore.loading && _topicStore.enableUpdateForum) {
          return Scaffold(
            appBar: baseStyleAppBar(context, title: ""),
            body: Center(
              child: Text(translate("bbpress_forum_no")),
            ),
          );
        }

        return _ListTopic(
          store: _topicStore,
        );
      },
    );
  }
}

class _ListTopic extends StatefulWidget {

  final BBPTopicForumStore store;

  const _ListTopic({
    required this.store,
  });

  @override
  State<_ListTopic> createState() => _ListTopicState();
}

class _ListTopicState extends State<_ListTopic> with AppBarMixin, LoadingMixin, TransitionMixin {
  late AuthStore _authStore;
  final ScrollController _controller = ScrollController();

  @override
  void initState() {
    _controller.addListener(_onScroll);
    super.initState();
  }

  @override
  void didChangeDependencies() {
    _authStore = Provider.of<AuthStore>(context);
    super.didChangeDependencies();
  }

  void _onScroll() {
    if (!_controller.hasClients || widget.store.loading || !widget.store.canLoadMore) return;
    final thresholdReached = _controller.position.extentAfter < endReachedThreshold;

    if (thresholdReached) {
      widget.store.getTopics();
    }
  }

  @override
  Widget build(BuildContext context) {
    TranslateType translate = AppLocalizations.of(context)!.translate;

    BBPForum forum = widget.store.forum ?? BBPForum();
    return Scaffold(
      appBar: baseStyleAppBar(
          context,
          title: translate("bbpress_forum_detail"),
          actions: [
            if (_authStore.isLogin && forum.type != "category") IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  PageRouteBuilder(
                    pageBuilder: (context, _, __) => BBPTopicCreateScreen(
                      forum: forum,
                      email: _authStore.user?.userEmail,
                      callback: () => Navigator.pop(context, "OK"),
                    ),
                    transitionsBuilder: slideTransition,
                  ),
                ).then((value) {
                  if (value == "OK") {
                    widget.store.initQuery();
                  }
                });
              },
              icon: const Icon(FontAwesomeIcons.plusCircle, size: 20),
            ),
            const SizedBox(width: 4),
          ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            color: Theme.of(context).colorScheme.surface,
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
            child: Text(forum.title ?? "", style: Theme.of(context).textTheme.titleSmall),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 8),
            child: Text(translate("bbpress_topics"), style: Theme.of(context).textTheme.titleMedium),
          ),
          Expanded(
            child: Observer(
              builder: (_) {
                bool loading = widget.store.loading;
                List<BBPTopic> topics = widget.store.topics;
                List<BBPTopic> emptyTopic = List.generate(widget.store.perPage, (index) => BBPTopic()).toList();

                List<BBPTopic> data = loading && topics.isEmpty ? emptyTopic : topics;
                return CustomScrollView(
                  controller: _controller,
                  slivers: [
                    CupertinoSliverRefreshControl(
                      onRefresh: widget.store.refresh,
                      builder: buildAppRefreshIndicator,
                    ),
                    if (data.isNotEmpty)
                      SliverPadding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        sliver: SliverList(
                          delegate: SliverChildBuilderDelegate(
                                (_, index) => TopicItemWidget(topic: data[index]),
                            childCount: data.length,
                          ),
                        ),
                      )
                    else
                      SliverToBoxAdapter(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 50),
                          child: Center(
                            child: Text(translate("buddypress_empty")),
                          ),
                        ),
                      ),
                    if (loading && topics.isNotEmpty)
                      SliverToBoxAdapter(
                        child: buildLoading(context, isLoading: widget.store.canLoadMore),
                      ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}