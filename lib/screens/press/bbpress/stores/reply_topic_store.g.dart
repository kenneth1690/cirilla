// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'reply_topic_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$BBPReplyTopicStore on BBPReplyTopicStoreBase, Store {
  Computed<BBPTopic?>? _$topicComputed;

  @override
  BBPTopic? get topic =>
      (_$topicComputed ??= Computed<BBPTopic?>(() => super.topic,
              name: 'BBPReplyTopicStoreBase.topic'))
          .value;
  Computed<bool>? _$enableUpdateTopicComputed;

  @override
  bool get enableUpdateTopic => (_$enableUpdateTopicComputed ??= Computed<bool>(
          () => super.enableUpdateTopic,
          name: 'BBPReplyTopicStoreBase.enableUpdateTopic'))
      .value;
  Computed<bool>? _$loadingComputed;

  @override
  bool get loading => (_$loadingComputed ??= Computed<bool>(() => super.loading,
          name: 'BBPReplyTopicStoreBase.loading'))
      .value;
  Computed<int>? _$nextPageComputed;

  @override
  int get nextPage =>
      (_$nextPageComputed ??= Computed<int>(() => super.nextPage,
              name: 'BBPReplyTopicStoreBase.nextPage'))
          .value;
  Computed<ObservableList<BBPReply>>? _$repliesComputed;

  @override
  ObservableList<BBPReply> get replies => (_$repliesComputed ??=
          Computed<ObservableList<BBPReply>>(() => super.replies,
              name: 'BBPReplyTopicStoreBase.replies'))
      .value;
  Computed<bool>? _$canLoadMoreComputed;

  @override
  bool get canLoadMore =>
      (_$canLoadMoreComputed ??= Computed<bool>(() => super.canLoadMore,
              name: 'BBPReplyTopicStoreBase.canLoadMore'))
          .value;
  Computed<int>? _$perPageComputed;

  @override
  int get perPage => (_$perPageComputed ??= Computed<int>(() => super.perPage,
          name: 'BBPReplyTopicStoreBase.perPage'))
      .value;

  late final _$_topicAtom =
      Atom(name: 'BBPReplyTopicStoreBase._topic', context: context);

  @override
  BBPTopic? get _topic {
    _$_topicAtom.reportRead();
    return super._topic;
  }

  @override
  set _topic(BBPTopic? value) {
    _$_topicAtom.reportWrite(value, super._topic, () {
      super._topic = value;
    });
  }

  late final _$_enableUpdateTopicAtom =
      Atom(name: 'BBPReplyTopicStoreBase._enableUpdateTopic', context: context);

  @override
  bool get _enableUpdateTopic {
    _$_enableUpdateTopicAtom.reportRead();
    return super._enableUpdateTopic;
  }

  @override
  set _enableUpdateTopic(bool value) {
    _$_enableUpdateTopicAtom.reportWrite(value, super._enableUpdateTopic, () {
      super._enableUpdateTopic = value;
    });
  }

  late final _$fetchReplyFutureAtom =
      Atom(name: 'BBPReplyTopicStoreBase.fetchReplyFuture', context: context);

  @override
  ObservableFuture<Map<dynamic, dynamic>?> get fetchReplyFuture {
    _$fetchReplyFutureAtom.reportRead();
    return super.fetchReplyFuture;
  }

  @override
  set fetchReplyFuture(ObservableFuture<Map<dynamic, dynamic>?> value) {
    _$fetchReplyFutureAtom.reportWrite(value, super.fetchReplyFuture, () {
      super.fetchReplyFuture = value;
    });
  }

  late final _$_repliesAtom =
      Atom(name: 'BBPReplyTopicStoreBase._replies', context: context);

  @override
  ObservableList<BBPReply> get _replies {
    _$_repliesAtom.reportRead();
    return super._replies;
  }

  @override
  set _replies(ObservableList<BBPReply> value) {
    _$_repliesAtom.reportWrite(value, super._replies, () {
      super._replies = value;
    });
  }

  late final _$_perPageAtom =
      Atom(name: 'BBPReplyTopicStoreBase._perPage', context: context);

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
      Atom(name: 'BBPReplyTopicStoreBase._nextPage', context: context);

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
      Atom(name: 'BBPReplyTopicStoreBase._canLoadMore', context: context);

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
      Atom(name: 'BBPReplyTopicStoreBase.pending', context: context);

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

  late final _$getRepliesAsyncAction =
      AsyncAction('BBPReplyTopicStoreBase.getReplies', context: context);

  @override
  Future<List<BBPReply>> getReplies({bool cancelPrevious = false}) {
    return _$getRepliesAsyncAction
        .run(() => super.getReplies(cancelPrevious: cancelPrevious));
  }

  late final _$BBPReplyTopicStoreBaseActionController =
      ActionController(name: 'BBPReplyTopicStoreBase', context: context);

  @override
  Future<void> refresh() {
    final _$actionInfo = _$BBPReplyTopicStoreBaseActionController.startAction(
        name: 'BBPReplyTopicStoreBase.refresh');
    try {
      return super.refresh();
    } finally {
      _$BBPReplyTopicStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  Future<void> initQuery() {
    final _$actionInfo = _$BBPReplyTopicStoreBaseActionController.startAction(
        name: 'BBPReplyTopicStoreBase.initQuery');
    try {
      return super.initQuery();
    } finally {
      _$BBPReplyTopicStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
fetchReplyFuture: ${fetchReplyFuture},
pending: ${pending},
topic: ${topic},
enableUpdateTopic: ${enableUpdateTopic},
loading: ${loading},
nextPage: ${nextPage},
replies: ${replies},
canLoadMore: ${canLoadMore},
perPage: ${perPage}
    ''';
  }
}
