// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'forum_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$BBPForumStore on BBPForumStoreBase, Store {
  Computed<bool>? _$loadingComputed;

  @override
  bool get loading => (_$loadingComputed ??= Computed<bool>(() => super.loading,
          name: 'BBPForumStoreBase.loading'))
      .value;
  Computed<int>? _$nextPageComputed;

  @override
  int get nextPage =>
      (_$nextPageComputed ??= Computed<int>(() => super.nextPage,
              name: 'BBPForumStoreBase.nextPage'))
          .value;
  Computed<ObservableList<BBPForum>>? _$membersComputed;

  @override
  ObservableList<BBPForum> get members => (_$membersComputed ??=
          Computed<ObservableList<BBPForum>>(() => super.members,
              name: 'BBPForumStoreBase.members'))
      .value;
  Computed<bool>? _$canLoadMoreComputed;

  @override
  bool get canLoadMore =>
      (_$canLoadMoreComputed ??= Computed<bool>(() => super.canLoadMore,
              name: 'BBPForumStoreBase.canLoadMore'))
          .value;
  Computed<int>? _$perPageComputed;

  @override
  int get perPage => (_$perPageComputed ??=
          Computed<int>(() => super.perPage, name: 'BBPForumStoreBase.perPage'))
      .value;

  late final _$fetchForumsFutureAtom =
      Atom(name: 'BBPForumStoreBase.fetchForumsFuture', context: context);

  @override
  ObservableFuture<List<BBPForum>?> get fetchForumsFuture {
    _$fetchForumsFutureAtom.reportRead();
    return super.fetchForumsFuture;
  }

  @override
  set fetchForumsFuture(ObservableFuture<List<BBPForum>?> value) {
    _$fetchForumsFutureAtom.reportWrite(value, super.fetchForumsFuture, () {
      super.fetchForumsFuture = value;
    });
  }

  late final _$_membersAtom =
      Atom(name: 'BBPForumStoreBase._members', context: context);

  @override
  ObservableList<BBPForum> get _members {
    _$_membersAtom.reportRead();
    return super._members;
  }

  @override
  set _members(ObservableList<BBPForum> value) {
    _$_membersAtom.reportWrite(value, super._members, () {
      super._members = value;
    });
  }

  late final _$_perPageAtom =
      Atom(name: 'BBPForumStoreBase._perPage', context: context);

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
      Atom(name: 'BBPForumStoreBase._nextPage', context: context);

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
      Atom(name: 'BBPForumStoreBase._canLoadMore', context: context);

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
      Atom(name: 'BBPForumStoreBase.pending', context: context);

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

  late final _$getForumsAsyncAction =
      AsyncAction('BBPForumStoreBase.getForums', context: context);

  @override
  Future<List<BBPForum>> getForums({bool cancelPrevious = false}) {
    return _$getForumsAsyncAction
        .run(() => super.getForums(cancelPrevious: cancelPrevious));
  }

  late final _$BBPForumStoreBaseActionController =
      ActionController(name: 'BBPForumStoreBase', context: context);

  @override
  Future<void> refresh() {
    final _$actionInfo = _$BBPForumStoreBaseActionController.startAction(
        name: 'BBPForumStoreBase.refresh');
    try {
      return super.refresh();
    } finally {
      _$BBPForumStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
fetchForumsFuture: ${fetchForumsFuture},
pending: ${pending},
loading: ${loading},
nextPage: ${nextPage},
members: ${members},
canLoadMore: ${canLoadMore},
perPage: ${perPage}
    ''';
  }
}
