// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$BMChatStore on BMChatStoreBase, Store {
  Computed<BMConversation?>? _$conversationComputed;

  @override
  BMConversation? get conversation => (_$conversationComputed ??=
          Computed<BMConversation?>(() => super.conversation,
              name: 'BMChatStoreBase.conversation'))
      .value;
  Computed<BMChat?>? _$chatComputed;

  @override
  BMChat? get chat => (_$chatComputed ??=
          Computed<BMChat?>(() => super.chat, name: 'BMChatStoreBase.chat'))
      .value;
  Computed<bool>? _$loadingComputed;

  @override
  bool get loading => (_$loadingComputed ??=
          Computed<bool>(() => super.loading, name: 'BMChatStoreBase.loading'))
      .value;
  Computed<bool>? _$errorComputed;

  @override
  bool get error => (_$errorComputed ??=
          Computed<bool>(() => super.error, name: 'BMChatStoreBase.error'))
      .value;

  late final _$_conversationAtom =
      Atom(name: 'BMChatStoreBase._conversation', context: context);

  @override
  BMConversation? get _conversation {
    _$_conversationAtom.reportRead();
    return super._conversation;
  }

  @override
  set _conversation(BMConversation? value) {
    _$_conversationAtom.reportWrite(value, super._conversation, () {
      super._conversation = value;
    });
  }

  late final _$_chatAtom =
      Atom(name: 'BMChatStoreBase._chat', context: context);

  @override
  BMChat? get _chat {
    _$_chatAtom.reportRead();
    return super._chat;
  }

  @override
  set _chat(BMChat? value) {
    _$_chatAtom.reportWrite(value, super._chat, () {
      super._chat = value;
    });
  }

  late final _$_statusAtom =
      Atom(name: 'BMChatStoreBase._status', context: context);

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

  late final _$getChatAsyncAction =
      AsyncAction('BMChatStoreBase.getChat', context: context);

  @override
  Future<void> getChat() {
    return _$getChatAsyncAction.run(() => super.getChat());
  }

  late final _$createMessageAsyncAction =
      AsyncAction('BMChatStoreBase.createMessage', context: context);

  @override
  Future<void> createMessage({dynamic data}) {
    return _$createMessageAsyncAction
        .run(() => super.createMessage(data: data));
  }

  @override
  String toString() {
    return '''
conversation: ${conversation},
chat: ${chat},
loading: ${loading},
error: ${error}
    ''';
  }
}
