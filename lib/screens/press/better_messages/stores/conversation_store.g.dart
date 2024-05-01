// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'conversation_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$BMConversationStore on BMConversationStoreBase, Store {
  Computed<bool>? _$loadingComputed;

  @override
  bool get loading => (_$loadingComputed ??= Computed<bool>(() => super.loading,
          name: 'BMConversationStoreBase.loading'))
      .value;
  Computed<ObservableList<BMConversation>>? _$conversationsComputed;

  @override
  ObservableList<BMConversation> get conversations =>
      (_$conversationsComputed ??= Computed<ObservableList<BMConversation>>(
              () => super.conversations,
              name: 'BMConversationStoreBase.conversations'))
          .value;
  Computed<bool>? _$enableRealtimeComputed;

  @override
  bool get enableRealtime =>
      (_$enableRealtimeComputed ??= Computed<bool>(() => super.enableRealtime,
              name: 'BMConversationStoreBase.enableRealtime'))
          .value;

  late final _$fetchConversationsFutureAtom = Atom(
      name: 'BMConversationStoreBase.fetchConversationsFuture',
      context: context);

  @override
  ObservableFuture<List<BMConversation>?> get fetchConversationsFuture {
    _$fetchConversationsFutureAtom.reportRead();
    return super.fetchConversationsFuture;
  }

  @override
  set fetchConversationsFuture(ObservableFuture<List<BMConversation>?> value) {
    _$fetchConversationsFutureAtom
        .reportWrite(value, super.fetchConversationsFuture, () {
      super.fetchConversationsFuture = value;
    });
  }

  late final _$_conversationsAtom =
      Atom(name: 'BMConversationStoreBase._conversations', context: context);

  @override
  ObservableList<BMConversation> get _conversations {
    _$_conversationsAtom.reportRead();
    return super._conversations;
  }

  @override
  set _conversations(ObservableList<BMConversation> value) {
    _$_conversationsAtom.reportWrite(value, super._conversations, () {
      super._conversations = value;
    });
  }

  late final _$_pendingAtom =
      Atom(name: 'BMConversationStoreBase._pending', context: context);

  @override
  bool get _pending {
    _$_pendingAtom.reportRead();
    return super._pending;
  }

  @override
  set _pending(bool value) {
    _$_pendingAtom.reportWrite(value, super._pending, () {
      super._pending = value;
    });
  }

  late final _$_enableRealtimeAtom =
      Atom(name: 'BMConversationStoreBase._enableRealtime', context: context);

  @override
  bool get _enableRealtime {
    _$_enableRealtimeAtom.reportRead();
    return super._enableRealtime;
  }

  @override
  set _enableRealtime(bool value) {
    _$_enableRealtimeAtom.reportWrite(value, super._enableRealtime, () {
      super._enableRealtime = value;
    });
  }

  late final _$getConversationsAsyncAction =
      AsyncAction('BMConversationStoreBase.getConversations', context: context);

  @override
  Future<List<BMConversation>?> getConversations(
      [bool enableRealtime = false]) {
    return _$getConversationsAsyncAction
        .run(() => super.getConversations(enableRealtime));
  }

  @override
  String toString() {
    return '''
fetchConversationsFuture: ${fetchConversationsFuture},
loading: ${loading},
conversations: ${conversations},
enableRealtime: ${enableRealtime}
    ''';
  }
}
