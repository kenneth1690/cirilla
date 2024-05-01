// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'member_group_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$BPMemberGroupStore on BPMemberGroupStoreBase, Store {
  Computed<bool>? _$loadingComputed;

  @override
  bool get loading => (_$loadingComputed ??= Computed<bool>(() => super.loading,
          name: 'BPMemberGroupStoreBase.loading'))
      .value;
  Computed<int>? _$nextPageComputed;

  @override
  int get nextPage =>
      (_$nextPageComputed ??= Computed<int>(() => super.nextPage,
              name: 'BPMemberGroupStoreBase.nextPage'))
          .value;
  Computed<ObservableList<BPMemberGroup>>? _$membersComputed;

  @override
  ObservableList<BPMemberGroup> get members => (_$membersComputed ??=
          Computed<ObservableList<BPMemberGroup>>(() => super.members,
              name: 'BPMemberGroupStoreBase.members'))
      .value;
  Computed<bool>? _$canLoadMoreComputed;

  @override
  bool get canLoadMore =>
      (_$canLoadMoreComputed ??= Computed<bool>(() => super.canLoadMore,
              name: 'BPMemberGroupStoreBase.canLoadMore'))
          .value;
  Computed<int>? _$perPageComputed;

  @override
  int get perPage => (_$perPageComputed ??= Computed<int>(() => super.perPage,
          name: 'BPMemberGroupStoreBase.perPage'))
      .value;
  Computed<String>? _$searchComputed;

  @override
  String get search =>
      (_$searchComputed ??= Computed<String>(() => super.search,
              name: 'BPMemberGroupStoreBase.search'))
          .value;

  late final _$_idGroupAtom =
      Atom(name: 'BPMemberGroupStoreBase._idGroup', context: context);

  @override
  int? get _idGroup {
    _$_idGroupAtom.reportRead();
    return super._idGroup;
  }

  @override
  set _idGroup(int? value) {
    _$_idGroupAtom.reportWrite(value, super._idGroup, () {
      super._idGroup = value;
    });
  }

  late final _$fetchMemberGroupFutureAtom = Atom(
      name: 'BPMemberGroupStoreBase.fetchMemberGroupFuture', context: context);

  @override
  ObservableFuture<List<BPMemberGroup>?> get fetchMemberGroupFuture {
    _$fetchMemberGroupFutureAtom.reportRead();
    return super.fetchMemberGroupFuture;
  }

  @override
  set fetchMemberGroupFuture(ObservableFuture<List<BPMemberGroup>?> value) {
    _$fetchMemberGroupFutureAtom
        .reportWrite(value, super.fetchMemberGroupFuture, () {
      super.fetchMemberGroupFuture = value;
    });
  }

  late final _$_membersAtom =
      Atom(name: 'BPMemberGroupStoreBase._members', context: context);

  @override
  ObservableList<BPMemberGroup> get _members {
    _$_membersAtom.reportRead();
    return super._members;
  }

  @override
  set _members(ObservableList<BPMemberGroup> value) {
    _$_membersAtom.reportWrite(value, super._members, () {
      super._members = value;
    });
  }

  late final _$_perPageAtom =
      Atom(name: 'BPMemberGroupStoreBase._perPage', context: context);

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

  late final _$_initPageAtom =
      Atom(name: 'BPMemberGroupStoreBase._initPage', context: context);

  @override
  int get _initPage {
    _$_initPageAtom.reportRead();
    return super._initPage;
  }

  @override
  set _initPage(int value) {
    _$_initPageAtom.reportWrite(value, super._initPage, () {
      super._initPage = value;
    });
  }

  late final _$_nextPageAtom =
      Atom(name: 'BPMemberGroupStoreBase._nextPage', context: context);

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
      Atom(name: 'BPMemberGroupStoreBase._canLoadMore', context: context);

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

  late final _$_includeAtom =
      Atom(name: 'BPMemberGroupStoreBase._include', context: context);

  @override
  ObservableList<BPMemberGroup> get _include {
    _$_includeAtom.reportRead();
    return super._include;
  }

  @override
  set _include(ObservableList<BPMemberGroup> value) {
    _$_includeAtom.reportWrite(value, super._include, () {
      super._include = value;
    });
  }

  late final _$_excludeAtom =
      Atom(name: 'BPMemberGroupStoreBase._exclude', context: context);

  @override
  ObservableList<BPMemberGroup> get _exclude {
    _$_excludeAtom.reportRead();
    return super._exclude;
  }

  @override
  set _exclude(ObservableList<BPMemberGroup> value) {
    _$_excludeAtom.reportWrite(value, super._exclude, () {
      super._exclude = value;
    });
  }

  late final _$_searchAtom =
      Atom(name: 'BPMemberGroupStoreBase._search', context: context);

  @override
  String get _search {
    _$_searchAtom.reportRead();
    return super._search;
  }

  @override
  set _search(String value) {
    _$_searchAtom.reportWrite(value, super._search, () {
      super._search = value;
    });
  }

  late final _$_excludeAdminsAtom =
      Atom(name: 'BPMemberGroupStoreBase._excludeAdmins', context: context);

  @override
  bool get _excludeAdmins {
    _$_excludeAdminsAtom.reportRead();
    return super._excludeAdmins;
  }

  @override
  set _excludeAdmins(bool value) {
    _$_excludeAdminsAtom.reportWrite(value, super._excludeAdmins, () {
      super._excludeAdmins = value;
    });
  }

  late final _$pendingAtom =
      Atom(name: 'BPMemberGroupStoreBase.pending', context: context);

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

  late final _$getMemberGroupsAsyncAction =
      AsyncAction('BPMemberGroupStoreBase.getMemberGroups', context: context);

  @override
  Future<List<BPMemberGroup>> getMemberGroups({bool cancelPrevious = false}) {
    return _$getMemberGroupsAsyncAction
        .run(() => super.getMemberGroups(cancelPrevious: cancelPrevious));
  }

  late final _$BPMemberGroupStoreBaseActionController =
      ActionController(name: 'BPMemberGroupStoreBase', context: context);

  @override
  Future<void> refresh() {
    final _$actionInfo = _$BPMemberGroupStoreBaseActionController.startAction(
        name: 'BPMemberGroupStoreBase.refresh');
    try {
      return super.refresh();
    } finally {
      _$BPMemberGroupStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void onChanged(
      {List<BPMemberGroup>? include,
      List<BPMemberGroup>? exclude,
      String? search}) {
    final _$actionInfo = _$BPMemberGroupStoreBaseActionController.startAction(
        name: 'BPMemberGroupStoreBase.onChanged');
    try {
      return super
          .onChanged(include: include, exclude: exclude, search: search);
    } finally {
      _$BPMemberGroupStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
fetchMemberGroupFuture: ${fetchMemberGroupFuture},
pending: ${pending},
loading: ${loading},
nextPage: ${nextPage},
members: ${members},
canLoadMore: ${canLoadMore},
perPage: ${perPage},
search: ${search}
    ''';
  }
}
