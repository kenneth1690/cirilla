import 'package:cirilla/service/helpers/request_helper.dart';
import 'package:dio/dio.dart';
import 'package:mobx/mobx.dart';

import '../models/models.dart';

part 'message_store.g.dart';

class BPMessageStore = BPMessageStoreBase with _$BPMessageStore;

abstract class BPMessageStoreBase with Store {
  final String? key;

  // Request helper instance
  final RequestHelper _requestHelper;

  // store for handling errors
  // final ErrorStore errorStore = ErrorStore();

  // constructor:---------------------------------------------------------------
  BPMessageStoreBase(
      this._requestHelper, {
        this.key,
        BPConversation? conversation,
      }) {
    if (conversation != null) _conversation = conversation;
    _reaction();
  }

  // store variables:-----------------------------------------------------------
  @observable
  BPConversation? _conversation;

  @observable
  ObservableList<BPMessage> _messages = ObservableList<BPMessage>.of([]);

  @observable
  String _status = "init";

  // computed:-------------------------------------------------------------------
  @computed
  BPConversation? get conversation => _conversation;

  @computed
  ObservableList<BPMessage> get messages => _messages;

  @computed
  bool get loading => _status == "loading";

  @computed
  bool get error => _status == "error";

  // actions:-------------------------------------------------------------------
  @action
  Future<void> getMessages() async {
    if (_conversation?.id != null) {
      _status = "loading";
      final future = _requestHelper.getMessages(id: _conversation?.id ?? 0);
      return future.then((data) {
        _status = "success";
        _messages = ObservableList<BPMessage>.of(data ?? [] as List<BPMessage>);
      }).catchError((_) {
        _status = "error";
      });
    }
  }

  @action
  Future<List<BPMessage>?> createMessage({Map<String, dynamic>? data}) async {
    var formData = FormData.fromMap(data!);
    return _requestHelper.createMessage(data: formData, queryParameters: {'app-builder-decode': true});
  }

  @action
  Future<void> readMessage() async {
    if (_conversation?.unreadCount != null && conversation!.unreadCount! > 0) {
      var formData = FormData.fromMap({
        "context": 'edit',
      });
      final future = _requestHelper.readMessage(
        id: _conversation?.id ?? 0,
        queryParameters: {
          "read": true,
        },
        data: formData,
      );
      return future.then((data) {
        _conversation = data;
      }).catchError((_) {});
    }
  }

  @action
  void onChanged({List<BPMessage>? messages}) {
    if (messages != null) {
      _messages = ObservableList<BPMessage>.of(messages);
    }
  }

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
