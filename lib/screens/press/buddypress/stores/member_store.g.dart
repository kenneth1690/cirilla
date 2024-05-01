// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'member_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$BPMemberStore on BPMemberStoreBase, Store {
  Computed<bool>? _$loadingComputed;

  @override
  bool get loading => (_$loadingComputed ??= Computed<bool>(() => super.loading,
          name: 'BPMemberStoreBase.loading'))
      .value;
  Computed<int>? _$nextPageComputed;

  @override
  int get nextPage =>
      (_$nextPageComputed ??= Computed<int>(() => super.nextPage,
              name: 'BPMemberStoreBase.nextPage'))
          .value;
  Computed<ObservableList<BPMember>>? _$membersComputed;

  @override
  ObservableList<BPMember> get members => (_$membersComputed ??=
          Computed<ObservableList<BPMember>>(() => super.members,
              name: 'BPMemberStoreBase.members'))
      .value;
  Computed<bool>? _$canLoadMoreComputed;

  @override
  bool get canLoadMore =>
      (_$canLoadMoreComputed ??= Computed<bool>(() => super.canLoadMore,
              name: 'BPMemberStoreBase.canLoadMore'))
          .value;
  Computed<int>? _$perPageComputed;

  @override
  int get perPage => (_$perPageComputed ??=
          Computed<int>(() => super.perPage, name: 'BPMemberStoreBase.perPage'))
      .value;
  Computed<String>? _$searchComputed;

  @override
  String get search =>
      (_$searchComputed ??= Computed<String>(() => super.search,
              name: 'BPMemberStoreBase.search'))
          .value;
  Computed<String>? _$typeComputed;

  @override
  String get type => (_$typeComputed ??=
          Computed<String>(() => super.type, name: 'BPMemberStoreBase.type'))
      .value;

  late final _$fetchMembersFutureAtom =
      Atom(name: 'BPMemberStoreBase.fetchMembersFuture', context: context);

  @override
  ObservableFuture<List<BPMember>?> get fetchMembersFuture {
    _$fetchMembersFutureAtom.reportRead();
    return super.fetchMembersFuture;
  }

  @override
  set fetchMembersFuture(ObservableFuture<List<BPMember>?> value) {
    _$fetchMembersFutureAtom.reportWrite(value, super.fetchMembersFuture, () {
      super.fetchMembersFuture = value;
    });
  }

  late final _$_membersAtom =
      Atom(name: 'BPMemberStoreBase._members', context: context);

  @override
  ObservableList<BPMember> get _members {
    _$_membersAtom.reportRead();
    return super._members;
  }

  @override
  set _members(ObservableList<BPMember> value) {
    _$_membersAtom.reportWrite(value, super._members, () {
      super._members = value;
    });
  }

  late final _$_perPageAtom =
      Atom(name: 'BPMemberStoreBase._perPage', context: context);

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
      Atom(name: 'BPMemberStoreBase._initPage', context: context);

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
      Atom(name: 'BPMemberStoreBase._nextPage', context: context);

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
      Atom(name: 'BPMemberStoreBase._canLoadMore', context: context);

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
      Atom(name: 'BPMemberStoreBase._include', context: context);

  @override
  ObservableList<BPMember> get _include {
    _$_includeAtom.reportRead();
    return super._include;
  }

  @override
  set _include(ObservableList<BPMember> value) {
    _$_includeAtom.reportWrite(value, super._include, () {
      super._include = value;
    });
  }

  late final _$_excludeAtom =
      Atom(name: 'BPMemberStoreBase._exclude', context: context);

  @override
  ObservableList<BPMember> get _exclude {
    _$_excludeAtom.reportRead();
    return super._exclude;
  }

  @override
  set _exclude(ObservableList<BPMember> value) {
    _$_excludeAtom.reportWrite(value, super._exclude, () {
      super._exclude = value;
    });
  }

  late final _$_searchAtom =
      Atom(name: 'BPMemberStoreBase._search', context: context);

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
      Atom(name: 'BPMemberStoreBase._type', context: context);

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

  late final _$_userIdAtom =
      Atom(name: 'BPMemberStoreBase._userId', context: context);

  @override
  int? get _userId {
    _$_userIdAtom.reportRead();
    return super._userId;
  }

  @override
  set _userId(int? value) {
    _$_userIdAtom.reportWrite(value, super._userId, () {
      super._userId = value;
    });
  }

  late final _$pendingAtom =
      Atom(name: 'BPMemberStoreBase.pending', context: context);

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

  late final _$getMembersAsyncAction =
      AsyncAction('BPMemberStoreBase.getMembers', context: context);

  @override
  Future<List<BPMember>> getMembers({bool cancelPrevious = false}) {
    return _$getMembersAsyncAction
        .run(() => super.getMembers(cancelPrevious: cancelPrevious));
  }

  late final _$BPMemberStoreBaseActionController =
      ActionController(name: 'BPMemberStoreBase', context: context);

  @override
  Future<void> refresh() {
    final _$actionInfo = _$BPMemberStoreBaseActionController.startAction(
        name: 'BPMemberStoreBase.refresh');
    try {
      return super.refresh();
    } finally {
      _$BPMemberStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void onChanged(
      {List<BPMember>? include,
      List<BPMember>? exclude,
      String? search,
      String? type,
      List<BPMember>? members}) {
    final _$actionInfo = _$BPMemberStoreBaseActionController.startAction(
        name: 'BPMemberStoreBase.onChanged');
    try {
      return super.onChanged(
          include: include,
          exclude: exclude,
          search: search,
          type: type,
          members: members);
    } finally {
      _$BPMemberStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
fetchMembersFuture: ${fetchMembersFuture},
pending: ${pending},
loading: ${loading},
nextPage: ${nextPage},
members: ${members},
canLoadMore: ${canLoadMore},
perPage: ${perPage},
search: ${search},
type: ${type}
    ''';
  }
}
