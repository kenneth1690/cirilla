import 'dart:async';

import 'package:cirilla/constants/assets.dart';
import 'package:cirilla/mixins/mixins.dart';
import 'package:cirilla/models/models.dart';
import 'package:cirilla/store/store.dart';
import 'package:cirilla/types/types.dart';
import 'package:cirilla/utils/utils.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/provider.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as flutter_chat_types;

import '../buddypress/widgets/widgets.dart';
import 'mixins/mixins.dart';
import 'models/models.dart';
import 'participant_message_chat_screen.dart';
import 'stores/stores.dart';

class BMMessageChatScreen extends StatefulWidget {
  final BMConversation conversation;
  final SettingStore? store;

  const BMMessageChatScreen({
    super.key,
    this.store,
    required this.conversation,
  });

  @override
  State<BMMessageChatScreen> createState() => _BMMessageChatScreenState();
}

class _BMMessageChatScreenState extends State<BMMessageChatScreen>
    with AppBarMixin, SnackMixin, LoadingMixin, TransitionMixin, BMConversationMixin {
  late AuthStore _authStore;

  late BMChatStore _chatStore;
  late Timer _timer;

  @override
  void didChangeDependencies() {
    _authStore = Provider.of<AuthStore>(context);

    _chatStore = BMChatStore(widget.store!.requestHelper, conversation: widget.conversation)
      ..getChat();

    _timer = Timer.periodic(const Duration(seconds: 5), (_) {
      _chatStore.getChat();
    });
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _timer.cancel();
    _chatStore.dispose();
    super.dispose();
  }

  int getIntDate(String? date) {
    DateTime value = date?.isNotEmpty == true ? DateTime.parse(date!) : DateTime.now();
    return value.millisecondsSinceEpoch;
  }

  List<flutter_chat_types.Message> convertToChat(BMChat? chat, int id) {
    List<flutter_chat_types.Message> messages = [];
    List<BMMessage> data = chat?.messages ?? [];
    int unreadCount = chat?.unread ?? 0;

    if (data.isNotEmpty == true) {
      int count = 0;
      for (BMMessage item in data) {
        BMUser? user = chat?.participants?.firstWhereIndexedOrNull((_, r) => r.id == item.senderId);
        String status = id != user?.id && count < unreadCount ? 'sent' : 'seen';
        messages.add(flutter_chat_types.Message.fromJson(
          {
            "author": {
              "firstName": user?.name,
              "id": "${user?.id}",
              "imageUrl": user?.avatar ?? Assets.noImageUrl,
            },
            "createdAt": getIntDate(item.date),
            "id": item.id.toString(),
            "status": status,
            "text": "<div>${unescape(item.message)}</div>",
            "type": "text"
          },
        ));
        if (status == "sent") {
          count++;
        }
      }
    }
    return messages.toList();
  }

  AppBar buildAppbar({
    required Widget title,
    required ThemeData theme,
  }) {
    return AppBar(
      shadowColor: Colors.transparent,
      backgroundColor: theme.appBarTheme.backgroundColor,
      // actionsIconTheme: IconThemeData(size: 22, opacity: 0),
      leading: leading(),
      centerTitle: true,
      title: title,
    );
  }

  Widget buildNotify({String? title, bool loading = false, required ThemeData theme}) {
    return Container(
      color: theme.scaffoldBackgroundColor,
      child: Center(
        // buildLoadingOverlay
        child: loading ? entryLoading(context) : Text(title ?? ""),
      ),
    );
  }

  Widget buildViewAppbar(ThemeData theme, TranslateType translate) {
    return Row(
      children: [
        buildImage(context, data: widget.conversation, loading: false),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              buildUser(context, data: widget.conversation, theme: theme, loading: false),
              buildTitle(data: widget.conversation, theme: theme, loading: false),
              if (widget.conversation.participantsCount != null && widget.conversation.participantsCount! > 2)
                Text(translate("bm_participants_count", {"count": "${widget.conversation.participantsCount}"}), style: theme.textTheme.labelSmall)
            ],
          ),
        ),
        const SizedBox(width: 8),
        if (widget.conversation.participantsCount != null && widget.conversation.participantsCount! > 2) ...[
          const SizedBox(width: 8),
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                PageRouteBuilder(
                  pageBuilder: (context, _, __) => BMParticipantMessageChatScreen(
                    participants: widget.conversation.participants ?? [],
                  ),
                  transitionsBuilder: slideTransition,
                ),
              );
              // BMParticipantMessageChatScreen
            },
            icon: const Icon(Icons.supervisor_account, size: 22),
          ),
        ],
        const SizedBox(width: 12),
      ],
    );
  }

  /// Handle user submit chat content
  void _handleChat(flutter_chat_types.PartialText txt) async {
    try {
      Map<String, dynamic> data = {
        "message": txt.text,
        "meta": {}
      };
      await _chatStore.createMessage(
        data: data,
      );
    } catch (e) {
      if (mounted) showError(context, e);
    }
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    TranslateType translate = AppLocalizations.of(context)!.translate;

    return Observer(
      builder: (_) {
        User? userSelf = _authStore.user;
        int idSelf = ConvertData.stringToInt(userSelf?.id);

        late Widget child;
        if (_chatStore.loading) {
          child = buildNotify(loading: true, theme: theme);
        } else if (_chatStore.error) {
          child = buildNotify(title: translate("buddypress_chat_message_error"), theme: theme);
        } else {
          child = ChatContentWidget(
            data: convertToChat(_chatStore.chat, idSelf),
            userId: userSelf?.id ?? "",
            handleChat: _handleChat,
          );
        }

        return ChatScaffoldWidget(
          appBar: buildViewAppbar(theme, translate),
          messages: child,
        );
      },
    );
  }
}
