import 'package:awesome_icons/awesome_icons.dart';
import 'package:cirilla/constants/constants.dart';
import 'package:cirilla/mixins/mixins.dart';
import 'package:cirilla/screens/screens.dart';
import 'package:cirilla/store/store.dart';
import 'package:cirilla/types/types.dart';
import 'package:cirilla/utils/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/provider.dart';

import 'widgets/widgets.dart';

import 'chat_create_screen.dart';

class BPMessageListScreen extends StatelessWidget with AppBarMixin {
  static const routeName = '/buddypress-message-list';

  final Map? args;
  final SettingStore? store;

  const BPMessageListScreen({
    super.key,
    this.args,
    this.store,
  });

  @override
  Widget build(BuildContext context) {
    TranslateType translate = AppLocalizations.of(context)!.translate;
    AuthStore authStore = Provider.of<AuthStore>(context);

    if (authStore.isLogin) {
      return _ListConversations(args: args, store: store);
    }

    String? name = get(args, ["name"]);
    return Scaffold(
      appBar: baseStyleAppBar(context, title: name?.isNotEmpty == true ? name! : translate("buddypress_message_list")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(translate("buddypress_required_login")),
            const SizedBox(height: 8),
            ElevatedButton(
              onPressed: () => Navigator.of(context).pushNamed(LoginScreen.routeName),
              child: Text(translate("buddypress_sign_in")),
            )
          ],
        ),
      ),
    );
  }
}

class _ListConversations extends StatefulWidget {

  final Map? args;
  final SettingStore? store;

  const _ListConversations({
    this.args,
    this.store,
  });

  @override
  State<_ListConversations> createState() => _ListConversationsState();
}

class _ListConversationsState extends State<_ListConversations>
    with AppBarMixin, LoadingMixin, TransitionMixin, SingleTickerProviderStateMixin {
  late BPConversationStore _conversationStore;

  TabController? _tabController;
  late BPMember? _member;

  @override
  void initState() {
    _tabController = TabController(vsync: this, length: 3);
    _member = get(widget.args, ["send"]) is BPMember ? get(widget.args, ["send"]) : null;
    super.initState();
  }

  @override
  void didChangeDependencies() {
    _conversationStore = BPConversationStore(
      widget.store!.requestHelper,
      box: "inbox",
    )..getConversations();
    super.didChangeDependencies();
  }

  void _onChanged(index) {
    late String box;
    switch (index) {
      case 1:
        box = "starred";
        break;
      case 2:
        box = "sentbox";
        break;
      default:
        box = "inbox";
    }
    if (box != _conversationStore.box) {
      _conversationStore.onChanged(box: box);
    }
  }

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
    if (_member?.id != null) {
      return BPChatCreateScreen(
        enablePrivateMessage: true,
        member: _member,
        callback: () {
          setState(() {
            _member = null;
          });
          if (_conversationStore.box != "sentbox") {
            _tabController?.animateTo(2);
            _onChanged(2);
          } else {
            _conversationStore.refresh();
          }
        }
      );
    }

    ThemeData theme = Theme.of(context);
    TranslateType translate = AppLocalizations.of(context)!.translate;

    String? name = get(widget.args, ["name"]);

    return Scaffold(
      appBar: AppBar(
        shadowColor: Colors.transparent,
        backgroundColor: theme.appBarTheme.backgroundColor,
        leading: leading(),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                PageRouteBuilder(
                  pageBuilder: (context, _, __) => BPChatCreateScreen(
                    callback: () => Navigator.pop(context, "OK"),
                  ),
                  transitionsBuilder: slideTransition,
                ),
              ).then((value) {
                if (value == "OK") {
                  if (_conversationStore.box != "sentbox") {
                    _tabController?.animateTo(2);
                    _onChanged(2);
                  } else {
                    _conversationStore.refresh();
                  }
                }
              });
            },
            icon: const Icon(FontAwesomeIcons.plusCircle, size: 20),
          ),
          const SizedBox(width: 8)
        ],
        centerTitle: true,
        title: Text(
          name?.isNotEmpty == true ? name! : translate("buddypress_message_list"),
          style: theme.appBarTheme.titleTextStyle,
        ),
        bottom: TabBar(
          onTap: _onChanged,
          labelPadding: EdgeInsets.zero,
          labelColor: theme.primaryColor,
          controller: _tabController,
          labelStyle: theme.textTheme.titleSmall,
          unselectedLabelColor: theme.textTheme.titleSmall?.color,
          indicatorWeight: 2,
          indicatorColor: theme.primaryColor,
          tabs: [
            buildTab(title: translate("buddypress_message_list_inbox")),
            buildTab(title: translate("buddypress_message_list_starred")),
            buildTab(title: translate("buddypress_message_list_sent")),
          ],
        ),
      ),
      // body: buildContent(),
      body: _ListConversation(
        store: _conversationStore,
      ),
    );
  }
}

class _ListConversation extends StatefulWidget {
  final BPConversationStore store;

  const _ListConversation({required this.store});

  @override
  State<_ListConversation> createState() => _ListConversationState();
}

class _ListConversationState extends State<_ListConversation> with LoadingMixin {
  final ScrollController _controller = ScrollController();

  @override
  void initState() {
    _controller.addListener(_onScroll);
    super.initState();
  }

  void _onScroll() {
    if (!_controller.hasClients || widget.store.loading || !widget.store.canLoadMore) return;
    final thresholdReached = _controller.position.extentAfter < endReachedThreshold;

    if (thresholdReached) {
      widget.store.getConversations();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Observer(
      builder: (_) {
        bool loading = widget.store.loading;
        List<BPConversation> conversations = widget.store.conversations;

        List<BPConversation> emptyConversation =
        List.generate(widget.store.perPage, (index) => BPConversation()).toList();

        List<BPConversation> data = loading && conversations.isEmpty ? emptyConversation : conversations;

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
                        (_, index) {
                      return ConversationItemWidget(
                        conversation: data[index],
                        enableCountUser: widget.store.box == "sentbox",
                      );
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
            if (loading && conversations.isNotEmpty)
              SliverToBoxAdapter(
                child: buildLoading(context, isLoading: widget.store.canLoadMore),
              ),
          ],
        );
      },
    );
  }
}
