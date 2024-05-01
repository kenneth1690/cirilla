import 'package:cirilla/constants/assets.dart';
import 'package:cirilla/mixins/mixins.dart';
import 'package:cirilla/models/models.dart';
import 'package:cirilla/store/store.dart';
import 'package:cirilla/types/types.dart';
import 'package:cirilla/utils/utils.dart';
import 'package:cirilla/widgets/widgets.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/provider.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as flutter_chat_types;

import 'models/models.dart';
import 'stores/stores.dart';
import 'widgets/widgets.dart';

class BPChatMessageScreen extends StatefulWidget {
  static const routeName = '/buddypress-chat-message';

  final Map? args;
  final SettingStore? store;

  const BPChatMessageScreen({
    super.key,
    this.store,
    this.args,
  });

  @override
  State<BPChatMessageScreen> createState() => _BPChatMessageScreenState();
}

class _BPChatMessageScreenState extends State<BPChatMessageScreen> with AppBarMixin, SnackMixin, LoadingMixin {
  late BPMessageStore _messageStore;
  late AuthStore _authStore;

  @override
  void didChangeDependencies() {
    _authStore = Provider.of<AuthStore>(context);

    dynamic data = widget.args?["conversation"];
    BPConversation? conversation = data is BPConversation ? data : null;

    _messageStore = BPMessageStore(widget.store!.requestHelper, conversation: conversation)
      ..getMessages()
      ..readMessage();
    super.didChangeDependencies();
  }

  int getIntDate(DateTime? date) {
    DateTime value = date ?? DateTime.now();
    return value.millisecondsSinceEpoch;
  }

  List<flutter_chat_types.Message> convertToChat(
      List<BPMessage>? data, int id, List<BPMember>? users, int unreadCount) {
    List<flutter_chat_types.Message> messages = [];
    if (data?.isNotEmpty == true) {
      List<BPMessage> dataReversed = data!.reversed.toList();
      int count = 0;
      for (BPMessage item in dataReversed) {
        BPMember? user = users?.firstWhereIndexedOrNull((_, r) => r.id == item.senderId);
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
            "text": unescape(item.message),
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

  /// Handle user submit chat content
  void _handleChat(flutter_chat_types.PartialText txt) async {
    try {
      Map<String, dynamic> data = {
        "context": "edit",
        "id": _messageStore.conversation?.id,
        "message": txt.text,
        "recipients": _messageStore.conversation?.recipients?.map((e) => e.id).toList() ?? []
      };
      List<BPMessage>? messages = await _messageStore.createMessage(
        data: data,
      );
      _messageStore.onChanged(messages: messages);
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

        BPConversation? conversation = _messageStore.conversation;
        BPMember? user = _messageStore.conversation?.recipients?.firstWhereIndexedOrNull((_, r) => r.id != idSelf);

        late Widget child;
        if (conversation?.id == null) {
          child = buildNotify(title: translate("buddypress_chat_message_empty_conversation"), theme: theme);
        } else if (_messageStore.loading) {
          child = buildNotify(loading: true, theme: theme);
        } else if (_messageStore.error) {
          child = buildNotify(title: translate("buddypress_chat_message_error"), theme: theme);
        } else {
          child = ChatContentWidget(
            data: convertToChat(
                _messageStore.messages, idSelf, conversation?.recipients ?? [], conversation?.unreadCount ?? 0),
            userId: userSelf?.id ?? "",
            handleChat: _handleChat,
          );
        }

        return ChatScaffoldWidget(
          appBar: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(30),
                child: CirillaCacheImage(
                  user?.avatar,
                  width: 60,
                  height: 60,
                ),
              ),
              const SizedBox(width: 10),
              Text(user?.name ?? "User"),
            ],
          ),
          messages: child,
        );
      },
    );
  }
}
