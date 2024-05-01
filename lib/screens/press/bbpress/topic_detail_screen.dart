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
import 'reply_create_screen.dart';
import 'stores/stores.dart';
import 'widgets/widgets.dart';

class BBPTopicDetailScreen extends StatefulWidget {
  static const routeName = '/bbpress-topic-detail';

  final SettingStore? store;
  final Map? args;

  const BBPTopicDetailScreen({
    super.key,
    this.store,
    this.args,
  });

  @override
  State<BBPTopicDetailScreen> createState() => _BBPTopicDetailScreenState();
}

class _BBPTopicDetailScreenState extends State<BBPTopicDetailScreen> with AppBarMixin, SnackMixin, LoadingMixin {
  late BBPReplyTopicStore _replyStore;

  @override
  void didChangeDependencies() {
    BBPTopic? topic;
    bool enableUpdateTopic = true;
    if (widget.args?['topic'] is BBPTopic) {
      topic = widget.args!['topic'];
      enableUpdateTopic = false;
    } else if (ConvertData.stringToInt(widget.args?["id"]) != 0) {
      topic = BBPTopic(
          id: ConvertData.stringToInt(widget.args?["id"])
      );
    }
    _replyStore = BBPReplyTopicStore(widget.store!.requestHelper, topic: topic, enableUpdateTopic: enableUpdateTopic)..getReplies();
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _replyStore.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    TranslateType translate = AppLocalizations.of(context)!.translate;

    return Observer(
      builder: (_) {
        if (_replyStore.loading && _replyStore.enableUpdateTopic) {
          return Scaffold(
            appBar: baseStyleAppBar(context, title: ""),
            body: Center(
              child: buildLoading(context, isLoading: _replyStore.loading),
            ),
          );
        }

        if (!_replyStore.loading && _replyStore.enableUpdateTopic) {
          return Scaffold(
            appBar: baseStyleAppBar(context, title: ""),
            body: Center(
              child: Text(translate("bbpress_topic_no")),
            ),
          );
        }

        return _ListReply(
          store: _replyStore,
        );
      },
    );
  }
}

class _ListReply extends StatefulWidget {

  final BBPReplyTopicStore store;

  const _ListReply({
    required this.store,
  });

  @override
  State<_ListReply> createState() => _ListReplyState();
}

class _ListReplyState extends State<_ListReply> with AppBarMixin, LoadingMixin {
  late AuthStore _authStore;
  final ScrollController _controller = ScrollController();
  BBPReply? _replySelected;

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
      widget.store.getReplies();
    }
  }

  void onReply() async {
    String? value = await showModalBottomSheet<String?>(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: borderRadiusBottomSheet,
      ),
      builder: (BuildContext context) {
        double height = MediaQuery.of(context).size.height;
        return Container(
          constraints: BoxConstraints(maxHeight:  height * 0.7),
          padding: const EdgeInsets.symmetric(vertical: 24),
          child: BBPReplyCreateScreen(
            data: _replySelected?.id != null
                ? ReplyData(
              idTopic: widget.store.topic?.id ?? 0,
              titleTopic: widget.store.topic?.title ?? "",
              idReply: _replySelected!.id,
            )
                : ReplyData(idTopic: widget.store.topic?.id ?? 0, titleTopic: widget.store.topic?.title ?? ""),
            email: _authStore.user?.userEmail,
            callback: () => Navigator.of(context).pop("OK"),
          ),
        );
      },
    );
    if (value == "OK") {
      widget.store.initQuery();
    }
    setState(() {
      _replySelected = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    TranslateType translate = AppLocalizations.of(context)!.translate;

    BBPTopic topic = widget.store.topic ?? BBPTopic();

    return Scaffold(
      appBar: baseStyleAppBar(
        context,
        title: translate("bbpress_topic_detail"),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            color: Theme.of(context).colorScheme.surface,
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
            child: Text(topic.title ?? "", style: Theme.of(context).textTheme.titleSmall),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 16),
            child: Text(translate("bbpress_replies"), style: Theme.of(context).textTheme.titleMedium),
          ),
          Expanded(
            child: Observer(
              builder: (_) {
                bool loading = widget.store.loading;
                List<BBPReply> replies = widget.store.replies;
                List<BBPReply> emptyReply = List.generate(widget.store.perPage, (index) => BBPReply()).toList();

                List<BBPReply> data = loading && replies.isEmpty ? emptyReply : replies;
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
                                (_, index) => Padding(
                                  padding: const EdgeInsets.only(bottom: 30),
                                  child: ReplyItemWidget(
                                    reply: data[index],
                                    onReply: () {
                                      setState(() {
                                        _replySelected = data[index].id != widget.store.topic?.id ? data[index] : null;
                                      });
                                      onReply();
                                    },
                                  ),
                                ),
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
                    if (loading && replies.isNotEmpty)
                      SliverToBoxAdapter(
                        child: buildLoading(context, isLoading: widget.store.canLoadMore),
                      ),
                  ],
                );
              },
            ),
          ),
          if (_authStore.isLogin)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
              child: ElevatedButton(
                onPressed: onReply,
                child: Text(translate("bbpress_reply")),
              ),
            )
        ],
      ),
    );
  }
}
