import 'dart:async';

import 'package:awesome_icons/awesome_icons.dart';
import 'package:cirilla/mixins/mixins.dart';
import 'package:cirilla/screens/screens.dart';
import 'package:cirilla/store/store.dart';
import 'package:cirilla/types/types.dart';
import 'package:cirilla/utils/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/provider.dart';

import 'message_chat_screen.dart';
import 'message_create_screen.dart';
import 'widgets/widgets.dart';

class BMMessageListScreen extends StatelessWidget with AppBarMixin {
  static const routeName = '/bm-message-list';

  final Map? args;
  final SettingStore? store;

  const BMMessageListScreen({
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
            ),
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

class _ListConversationsState extends State<_ListConversations> with AppBarMixin, LoadingMixin, TransitionMixin {
  late BMConversationStore _conversationStore;

  late BPMember? _member;

  late Timer _timer;

  @override
  void initState() {
    _member = get(widget.args, ["send"]) is BPMember ? get(widget.args, ["send"]) : null;

    super.initState();
  }

  @override
  void didChangeDependencies() {
    _conversationStore = BMConversationStore(widget.store!.requestHelper,)..getConversations();
    _timer = Timer.periodic(const Duration(seconds: 9), (_) {
      _conversationStore.getConversations(true);
    });
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _timer.cancel();
    _conversationStore.dispose();
    super.dispose();
  }

  void _goChat(BMConversation conversation) {
    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (context, _, __) => BMMessageChatScreen(
          conversation: conversation,
          store: widget.store,
        ),
        transitionsBuilder: slideTransition,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {

    TranslateType translate = AppLocalizations.of(context)!.translate;

    String? name = get(widget.args, ["name"]);

    return Observer(
      builder: (_) {
        bool loading = _conversationStore.loading;
        List<BMConversation> conversations = _conversationStore.conversations;

        if (_member?.id != null) {
          if (loading && _conversationStore.enableRealtime == false) {
            return Scaffold(
              appBar: baseStyleAppBar(context, title: ""),
              body: Center(
                child: entryLoading(context),
              )
            );
          }

          return BMMessageCreateScreen(
            enablePrivateMessage: true,
            member: _member,
            conversations: conversations,
            callback: (BMConversation? conversation) {
              if (conversation != null) {
                _goChat(conversation);
              }
              _conversationStore.getConversations();
              setState(() {
                _member = null;
              });
            },
          );
        }

        List<BMConversation> emptyConversation =
        List.generate(10, (index) => BMConversation()).toList();

        List<BMConversation> data = loading && conversations.isEmpty ? emptyConversation : conversations;

        return Scaffold(
          appBar: baseStyleAppBar(context,
            title: name?.isNotEmpty == true ? name! : translate("buddypress_message_list"),
            actions: [
              IconButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    PageRouteBuilder(
                      pageBuilder: (context, _, __) => BMMessageCreateScreen(
                        conversations: conversations,
                        callback: (BMConversation? conversation) => Navigator.pop(context, conversation ?? "OK"),
                      ),
                      transitionsBuilder: slideTransition,
                    ),
                  ).then((value) {
                    if (value is BMConversation) {
                      _goChat(value);
                    } else if (value == "OK") {
                      _conversationStore.getConversations();
                    }
                  });
                },
                icon: const Icon(FontAwesomeIcons.plusCircle, size: 20),
              )
            ],
          ),
          body: CustomScrollView(
            slivers: [
              CupertinoSliverRefreshControl(
                onRefresh: _conversationStore.getConversations,
                builder: buildAppRefreshIndicator,
              ),
              if (data.isNotEmpty)
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
                  sliver: SliverList(
                    delegate: SliverChildBuilderDelegate(
                          (_, index) {
                        return BMConversationItemWidget(
                          conversation: data[index],
                          onTap: () => _goChat(data[index]),
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
            ],
          ),
        );
      },
    );
  }
}