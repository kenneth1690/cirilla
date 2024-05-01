// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'conversation_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$BPConversationStore on BPConversationStoreBase, Store {
  Computed<bool>? _$loadingComputed;

  @override
  bool get loading => (_$loadingComputed ??= Computed<bool>(() => super.loading,
          name: 'BPConversationStoreBase.loading'))
      .value;
  Computed<ObservableList<BPConversation>>? _$conversationsComputed;

  @override
  ObservableList<BPConversation> get conversations =>
      (_$conversationsComputed ??= Computed<ObservableList<BPConversation>>(
              () => super.conversations,
              name: 'BPConversationStoreBase.conversations'))
          .value;
  Computed<int>? _$nextPageComputed;

  @override
  int get nextPage =>
      (_$nextPageComputed ??= Computed<int>(() => super.nextPage,
              name: 'BPConversationStoreBase.nextPage'))
          .value;
  Computed<bool>? _$canLoadMoreComputed;

  @override
  bool get canLoadMore =>
      (_$canLoadMoreComputed ??= Computed<bool>(() => super.canLoadMore,
              name: 'BPConversationStoreBase.canLoadMore'))
          .value;
  Computed<int>? _$perPageComputed;

  @override
  int get perPage => (_$perPageComputed ??= Computed<int>(() => super.perPage,
          name: 'BPConversationStoreBase.perPage'))
      .value;
  Computed<String>? _$boxComputed;

  @override
  String get box => (_$boxComputed ??= Computed<String>(() => super.box,
          name: 'BPConversationStoreBase.box'))
      .value;

  late final _$fetchConversationsFutureAtom = Atom(
      name: 'BPConversationStoreBase.fetchConversationsFuture',
      context: context);

  @override
  ObservableFuture<List<BPConversation>?> get fetchConversationsFuture {
    _$fetchConversationsFutureAtom.reportRead();
    return super.fetchConversationsFuture;
  }

  @override
  set fetchConversationsFuture(ObservableFuture<List<BPConversation>?> value) {
    _$fetchConversationsFutureAtom
        .reportWrite(value, super.fetchConversationsFuture, () {
      super.fetchConversationsFuture = value;
    });
  }

  late final _$_conversationsAtom =
      Atom(name: 'BPConversationStoreBase._conversations', context: context);

  @override
  ObservableList<BPConversation> get _conversations {
    _$_conversationsAtom.reportRead();
    return super._conversations;
  }

  @override
  set _conversations(ObservableList<BPConversation> value) {
    _$_conversationsAtom.reportWrite(value, super._conversations, () {
      super._conversations = value;
    });
  }

  late final _$_boxAtom =
      Atom(name: 'BPConversationStoreBase._box', context: context);

  @override
  String get _box {
    _$_boxAtom.reportRead();
    return super._box;
  }

  @override
  set _box(String value) {
    _$_boxAtom.reportWrite(value, super._box, () {
      super._box = value;
    });
  }

  late final _$_perPageAtom =
      Atom(name: 'BPConversationStoreBase._perPage', context: context);

  @override
  int get _perPage {
    _$_perPageAtom.reportRead();
    return super._perPage;
  }

  @override
  set _perPage(int value) {
    _$_perPageAtom.reportWrite(value, super._perPage, () {
      super._perPage = value;
    });
  }

  late final _$_nextPageAtom =
      Atom(name: 'BPConversationStoreBase._nextPage', context: context);

  @override
  int get _nextPage {
    _$_nextPageAtom.reportRead();
    return super._nextPage;
  }

  @override
  set _nextPage(int value) {
    _$_nextPageAtom.reportWrite(value, super._nextPage, () {
      super._nextPage = value;
    });
  }

  late final _$_canLoadMoreAtom =
      Atom(name: 'BPConversationStoreBase._canLoadMore', context: context);

  @override
  bool get _canLoadMore {
    _$_canLoadMoreAtom.reportRead();
    return super._canLoadMore;
  }

  @override
  set _canLoadMore(bool value) {
    _$_canLoadMoreAtom.reportWrite(value, super._canLoadMore, () {
      super._canLoadMore = value;
    });
  }

  late final _$pendingAtom =
      Atom(name: 'BPConversationStoreBase.pending', context: context);

  @override
  bool get pending {
    _$pendingAtom.reportRead();
    return super.pending;
  }

  @override
  set pending(bool value) {
    _$pendingAtom.reportWrite(value, super.pending, () {
      super.pending = value;
    });
  }

  late final _$getConversationsAsyncAction =
      AsyncAction('BPConversationStoreBase.getConversations', context: context);

  @override
  Future<List<BPConversation>?> getConversations() {
    return _$getConversationsAsyncAction.run(() => super.getConversations());
  }

  late final _$BPConversationStoreBaseActionController =
      ActionController(name: 'BPConversationStoreBase', context: context);

  @override
  Future<void> refresh() {
    final _$actionInfo = _$BPConversationStoreBaseActionController.startAction(
        name: 'BPConversationStoreBase.refresh');
    try {
      return super.refresh();
    } finally {
      _$BPConversationStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void onChanged({String? box}) {
    final _$actionInfo = _$BPConversationStoreBaseActionController.startAction(
        name: 'BPConversationStoreBase.onChanged');
    try {
      return super.onChanged(box: box);
    } finally {
      _$BPConversationStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
fetchConversationsFuture: ${fetchConversationsFuture},
pending: ${pending},
loading: ${loading},
conversations: ${conversations},
nextPage: ${nextPage},
canLoadMore: ${canLoadMore},
perPage: ${perPage},
box: ${box}
    ''';
  }
}
