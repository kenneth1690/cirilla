// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'message_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$BPMessageStore on BPMessageStoreBase, Store {
  Computed<BPConversation?>? _$conversationComputed;

  @override
  BPConversation? get conversation => (_$conversationComputed ??=
          Computed<BPConversation?>(() => super.conversation,
              name: 'BPMessageStoreBase.conversation'))
      .value;
  Computed<ObservableList<BPMessage>>? _$messagesComputed;

  @override
  ObservableList<BPMessage> get messages => (_$messagesComputed ??=
          Computed<ObservableList<BPMessage>>(() => super.messages,
              name: 'BPMessageStoreBase.messages'))
      .value;
  Computed<bool>? _$loadingComputed;

  @override
  bool get loading => (_$loadingComputed ??= Computed<bool>(() => super.loading,
          name: 'BPMessageStoreBase.loading'))
      .value;
  Computed<bool>? _$errorComputed;

  @override
  bool get error => (_$errorComputed ??=
          Computed<bool>(() => super.error, name: 'BPMessageStoreBase.error'))
      .value;

  late final _$_conversationAtom =
      Atom(name: 'BPMessageStoreBase._conversation', context: context);

  @override
  BPConversation? get _conversation {
    _$_conversationAtom.reportRead();
    return super._conversation;
  }

  @override
  set _conversation(BPConversation? value) {
    _$_conversationAtom.reportWrite(value, super._conversation, () {
      super._conversation = value;
    });
  }

  late final _$_messagesAtom =
      Atom(name: 'BPMessageStoreBase._messages', context: context);

  @override
  ObservableList<BPMessage> get _messages {
    _$_messagesAtom.reportRead();
    return super._messages;
  }

  @override
  set _messages(ObservableList<BPMessage> value) {
    _$_messagesAtom.reportWrite(value, super._messages, () {
      super._messages = value;
    });
  }

  late final _$_statusAtom =
      Atom(name: 'BPMessageStoreBase._status', context: context);

  @override
  String get _status {
    _$_statusAtom.reportRead();
    return super._status;
  }

  @override
  set _status(String value) {
    _$_statusAtom.reportWrite(value, super._status, () {
      super._status = value;
    });
  }

  late final _$getMessagesAsyncAction =
      AsyncAction('BPMessageStoreBase.getMessages', context: context);

  @override
  Future<void> getMessages() {
    return _$getMessagesAsyncAction.run(() => super.getMessages());
  }

  late final _$createMessageAsyncAction =
      AsyncAction('BPMessageStoreBase.createMessage', context: context);

  @override
  Future<List<BPMessage>?> createMessage({Map<String, dynamic>? data}) {
    return _$createMessageAsyncAction
        .run(() => super.createMessage(data: data));
  }

  late final _$readMessageAsyncAction =
      AsyncAction('BPMessageStoreBase.readMessage', context: context);

  @override
  Future<void> readMessage() {
    return _$readMessageAsyncAction.run(() => super.readMessage());
  }

  late final _$BPMessageStoreBaseActionController =
      ActionController(name: 'BPMessageStoreBase', context: context);

  @override
  void onChanged({List<BPMessage>? messages}) {
    final _$actionInfo = _$BPMessageStoreBaseActionController.startAction(
        name: 'BPMessageStoreBase.onChanged');
    try {
      return super.onChanged(messages: messages);
    } finally {
      _$BPMessageStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
conversation: ${conversation},
messages: ${messages},
loading: ${loading},
error: ${error}
    ''';
  }
}
