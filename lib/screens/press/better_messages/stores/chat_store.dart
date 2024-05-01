import 'package:cirilla/service/helpers/request_helper.dart';
import 'package:mobx/mobx.dart';

import '../models/models.dart';

part 'chat_store.g.dart';

class BMChatStore = BMChatStoreBase with _$BMChatStore;

abstract class BMChatStoreBase with Store {
  final String? key;

  // Request helper instance
  final RequestHelper _requestHelper;

  // store for handling errors
  // final ErrorStore errorStore = ErrorStore();

  // constructor:---------------------------------------------------------------
  BMChatStoreBase(
      this._requestHelper, {
        this.key,
        BMConversation? conversation,
      }) {
    if (conversation != null) _conversation = conversation;
    _reaction();
  }

  // store variables:-----------------------------------------------------------
  @observable
  BMConversation? _conversation;

  @observable
  BMChat? _chat;

  @observable
  String _status = "loading";

  // computed:-------------------------------------------------------------------
  @computed
  BMConversation? get conversation => _conversation;

  @computed
  BMChat? get chat => _chat;

  @computed
  bool get loading => _status == "loading";

  @computed
  bool get error => _status == "error";

  // actions:-------------------------------------------------------------------
  @action
  Future<void> getChat() async {
    if (_conversation?.id != null) {
      final future = _requestHelper.getChatBM(id: _conversation?.id ?? 0, queryParameters: {"nocache": DateTime.now().millisecondsSinceEpoch});
      return future.then((data) {
        _status = "success";
        if (_chat?.unread != data?.unread || _chat?.messages?.length != data?.messages?.length) {
          _chat = data;
        }
      }).catchError((_) {
        _status = "error";
      });
    }
  }

  @action
  Future<void> createMessage({dynamic data}) async {
    if (_conversation?.id != null) {
      final future = _requestHelper.sendMessageChatBM(id: _conversation?.id ?? 0, data: data, queryParameters: {"nocache": DateTime.now().millisecondsSinceEpoch});
      return future.then((res) {
        List<BMMessage> messages = _chat?.messages ?? [];
        _chat = BMChat(
          id: _chat?.id,
          title: _chat?.title,
          participants: _chat?.participants,
          participantsCount: _chat?.participantsCount,
          messages: [
            if (res is BMMessage) res,
            if (messages.isNotEmpty) ...messages,
          ],
          unread: _chat?.unread,
        );
      });
    }
  }

  // @action
  // Future<void> readMessage() async {
  //   if (_conversation?.unreadCount != null && conversation!.unreadCount! > 0) {
  //     var formData = FormData.fromMap({
  //       "context": 'edit',
  //     });
  //     final future = _requestHelper.readMessage(
  //       id: _conversation?.id ?? 0,
  //       queryParameters: {
  //         "read": true,
  //       },
  //       data: formData,
  //     );
  //     return future.then((data) {
  //       _conversation = data;
  //     }).catchError((_) {});
  //   }
  // }

  // disposers:-----------------------------------------------------------------
  late List<ReactionDisposer> _disposers;

  void _reaction() {
    _disposers = [];
  }

  void dispose() {
    for (final d in _disposers) {
      d();
    }
  }
}
