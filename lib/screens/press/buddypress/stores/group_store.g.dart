// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'group_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$BPGroupStore on BPGroupStoreBase, Store {
  Computed<bool>? _$loadingComputed;

  @override
  bool get loading => (_$loadingComputed ??=
          Computed<bool>(() => super.loading, name: 'BPGroupStoreBase.loading'))
      .value;
  Computed<int>? _$nextPageComputed;

  @override
  int get nextPage =>
      (_$nextPageComputed ??= Computed<int>(() => super.nextPage,
              name: 'BPGroupStoreBase.nextPage'))
          .value;
  Computed<ObservableList<BPGroup>>? _$groupsComputed;

  @override
  ObservableList<BPGroup> get groups => (_$groupsComputed ??=
          Computed<ObservableList<BPGroup>>(() => super.groups,
              name: 'BPGroupStoreBase.groups'))
      .value;
  Computed<bool>? _$canLoadMoreComputed;

  @override
  bool get canLoadMore =>
      (_$canLoadMoreComputed ??= Computed<bool>(() => super.canLoadMore,
              name: 'BPGroupStoreBase.canLoadMore'))
          .value;
  Computed<int>? _$perPageComputed;

  @override
  int get perPage => (_$perPageComputed ??=
          Computed<int>(() => super.perPage, name: 'BPGroupStoreBase.perPage'))
      .value;
  Computed<String>? _$searchComputed;

  @override
  String get search => (_$searchComputed ??=
          Computed<String>(() => super.search, name: 'BPGroupStoreBase.search'))
      .value;
  Computed<String>? _$typeComputed;

  @override
  String get type => (_$typeComputed ??=
          Computed<String>(() => super.type, name: 'BPGroupStoreBase.type'))
      .value;

  late final _$fetchGroupsFutureAtom =
      Atom(name: 'BPGroupStoreBase.fetchGroupsFuture', context: context);

  @override
  ObservableFuture<List<BPGroup>?> get fetchGroupsFuture {
    _$fetchGroupsFutureAtom.reportRead();
    return super.fetchGroupsFuture;
  }

  @override
  set fetchGroupsFuture(ObservableFuture<List<BPGroup>?> value) {
    _$fetchGroupsFutureAtom.reportWrite(value, super.fetchGroupsFuture, () {
      super.fetchGroupsFuture = value;
    });
  }

  late final _$_groupsAtom =
      Atom(name: 'BPGroupStoreBase._groups', context: context);

  @override
  ObservableList<BPGroup> get _groups {
    _$_groupsAtom.reportRead();
    return super._groups;
  }

  @override
  set _groups(ObservableList<BPGroup> value) {
    _$_groupsAtom.reportWrite(value, super._groups, () {
      super._groups = value;
    });
  }

  late final _$_perPageAtom =
      Atom(name: 'BPGroupStoreBase._perPage', context: context);

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
      Atom(name: 'BPGroupStoreBase._initPage', context: context);

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
      Atom(name: 'BPGroupStoreBase._nextPage', context: context);

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
      Atom(name: 'BPGroupStoreBase._canLoadMore', context: context);

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
      Atom(name: 'BPGroupStoreBase._include', context: context);

  @override
  ObservableList<BPGroup> get _include {
    _$_includeAtom.reportRead();
    return super._include;
  }

  @override
  set _include(ObservableList<BPGroup> value) {
    _$_includeAtom.reportWrite(value, super._include, () {
      super._include = value;
    });
  }

  late final _$_excludeAtom =
      Atom(name: 'BPGroupStoreBase._exclude', context: context);

  @override
  ObservableList<BPGroup> get _exclude {
    _$_excludeAtom.reportRead();
    return super._exclude;
  }

  @override
  set _exclude(ObservableList<BPGroup> value) {
    _$_excludeAtom.reportWrite(value, super._exclude, () {
      super._exclude = value;
    });
  }

  late final _$_searchAtom =
      Atom(name: 'BPGroupStoreBase._search', context: context);

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

  late final _$_typeAtom =
      Atom(name: 'BPGroupStoreBase._type', context: context);

  @override
  String get _type {
    _$_typeAtom.reportRead();
    return super._type;
  }

  @override
  set _type(String value) {
    _$_typeAtom.reportWrite(value, super._type, () {
      super._type = value;
    });
  }

  late final _$pendingAtom =
      Atom(name: 'BPGroupStoreBase.pending', context: context);

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

  late final _$getGroupsAsyncAction =
      AsyncAction('BPGroupStoreBase.getGroups', context: context);

  @override
  Future<List<BPGroup>> getGroups({bool cancelPrevious = false}) {
    return _$getGroupsAsyncAction
        .run(() => super.getGroups(cancelPrevious: cancelPrevious));
  }

  late final _$BPGroupStoreBaseActionController =
      ActionController(name: 'BPGroupStoreBase', context: context);

  @override
  Future<void> refresh() {
    final _$actionInfo = _$BPGroupStoreBaseActionController.startAction(
        name: 'BPGroupStoreBase.refresh');
    try {
      return super.refresh();
    } finally {
      _$BPGroupStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void onChanged(
      {List<BPGroup>? include,
      List<BPGroup>? exclude,
      String? search,
      String? type}) {
    final _$actionInfo = _$BPGroupStoreBaseActionController.startAction(
        name: 'BPGroupStoreBase.onChanged');
    try {
      return super.onChanged(
          include: include, exclude: exclude, search: search, type: type);
    } finally {
      _$BPGroupStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
fetchGroupsFuture: ${fetchGroupsFuture},
pending: ${pending},
loading: ${loading},
nextPage: ${nextPage},
groups: ${groups},
canLoadMore: ${canLoadMore},
perPage: ${perPage},
search: ${search},
type: ${type}
    ''';
  }
}
