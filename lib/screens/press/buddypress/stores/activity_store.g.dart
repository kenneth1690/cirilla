// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'activity_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$BPActivityStore on BPActivityStoreBase, Store {
  Computed<bool>? _$loadingComputed;

  @override
  bool get loading => (_$loadingComputed ??= Computed<bool>(() => super.loading,
          name: 'BPActivityStoreBase.loading'))
      .value;
  Computed<int>? _$nextPageComputed;

  @override
  int get nextPage =>
      (_$nextPageComputed ??= Computed<int>(() => super.nextPage,
              name: 'BPActivityStoreBase.nextPage'))
          .value;
  Computed<ObservableList<BPActivity>>? _$activitiesComputed;

  @override
  ObservableList<BPActivity> get activities => (_$activitiesComputed ??=
          Computed<ObservableList<BPActivity>>(() => super.activities,
              name: 'BPActivityStoreBase.activities'))
      .value;
  Computed<bool>? _$canLoadMoreComputed;

  @override
  bool get canLoadMore =>
      (_$canLoadMoreComputed ??= Computed<bool>(() => super.canLoadMore,
              name: 'BPActivityStoreBase.canLoadMore'))
          .value;
  Computed<int>? _$perPageComputed;

  @override
  int get perPage => (_$perPageComputed ??= Computed<int>(() => super.perPage,
          name: 'BPActivityStoreBase.perPage'))
      .value;
  Computed<String>? _$searchComputed;

  @override
  String get search =>
      (_$searchComputed ??= Computed<String>(() => super.search,
              name: 'BPActivityStoreBase.search'))
          .value;
  Computed<String>? _$typeComputed;

  @override
  String get type => (_$typeComputed ??=
          Computed<String>(() => super.type, name: 'BPActivityStoreBase.type'))
      .value;
  Computed<String?>? _$displayCommentsComputed;

  @override
  String? get displayComments => (_$displayCommentsComputed ??=
          Computed<String?>(() => super.displayComments,
              name: 'BPActivityStoreBase.displayComments'))
      .value;
  Computed<int?>? _$groupIdComputed;

  @override
  int? get groupId => (_$groupIdComputed ??= Computed<int?>(() => super.groupId,
          name: 'BPActivityStoreBase.groupId'))
      .value;
  Computed<int?>? _$userIdComputed;

  @override
  int? get userId => (_$userIdComputed ??= Computed<int?>(() => super.userId,
          name: 'BPActivityStoreBase.userId'))
      .value;

  late final _$fetchActivitiesFutureAtom =
      Atom(name: 'BPActivityStoreBase.fetchActivitiesFuture', context: context);

  @override
  ObservableFuture<List<BPActivity>?> get fetchActivitiesFuture {
    _$fetchActivitiesFutureAtom.reportRead();
    return super.fetchActivitiesFuture;
  }

  @override
  set fetchActivitiesFuture(ObservableFuture<List<BPActivity>?> value) {
    _$fetchActivitiesFutureAtom.reportWrite(value, super.fetchActivitiesFuture,
        () {
      super.fetchActivitiesFuture = value;
    });
  }

  late final _$_activitiesAtom =
      Atom(name: 'BPActivityStoreBase._activities', context: context);

  @override
  ObservableList<BPActivity> get _activities {
    _$_activitiesAtom.reportRead();
    return super._activities;
  }

  @override
  set _activities(ObservableList<BPActivity> value) {
    _$_activitiesAtom.reportWrite(value, super._activities, () {
      super._activities = value;
    });
  }

  late final _$_perPageAtom =
      Atom(name: 'BPActivityStoreBase._perPage', context: context);

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
      Atom(name: 'BPActivityStoreBase._initPage', context: context);

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
      Atom(name: 'BPActivityStoreBase._nextPage', context: context);

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
      Atom(name: 'BPActivityStoreBase._canLoadMore', context: context);

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
      Atom(name: 'BPActivityStoreBase._include', context: context);

  @override
  ObservableList<BPActivity> get _include {
    _$_includeAtom.reportRead();
    return super._include;
  }

  @override
  set _include(ObservableList<BPActivity> value) {
    _$_includeAtom.reportWrite(value, super._include, () {
      super._include = value;
    });
  }

  late final _$_excludeAtom =
      Atom(name: 'BPActivityStoreBase._exclude', context: context);

  @override
  ObservableList<BPActivity> get _exclude {
    _$_excludeAtom.reportRead();
    return super._exclude;
  }

  @override
  set _exclude(ObservableList<BPActivity> value) {
    _$_excludeAtom.reportWrite(value, super._exclude, () {
      super._exclude = value;
    });
  }

  late final _$_typeAtom =
      Atom(name: 'BPActivityStoreBase._type', context: context);

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

  late final _$_searchAtom =
      Atom(name: 'BPActivityStoreBase._search', context: context);

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

  late final _$_groupIdAtom =
      Atom(name: 'BPActivityStoreBase._groupId', context: context);

  @override
  int? get _groupId {
    _$_groupIdAtom.reportRead();
    return super._groupId;
  }

  @override
  set _groupId(int? value) {
    _$_groupIdAtom.reportWrite(value, super._groupId, () {
      super._groupId = value;
    });
  }

  late final _$_userIdAtom =
      Atom(name: 'BPActivityStoreBase._userId', context: context);

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

  late final _$_displayCommentsAtom =
      Atom(name: 'BPActivityStoreBase._displayComments', context: context);

  @override
  String? get _displayComments {
    _$_displayCommentsAtom.reportRead();
    return super._displayComments;
  }

  @override
  set _displayComments(String? value) {
    _$_displayCommentsAtom.reportWrite(value, super._displayComments, () {
      super._displayComments = value;
    });
  }

  late final _$pendingAtom =
      Atom(name: 'BPActivityStoreBase.pending', context: context);

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

  late final _$getActivitiesAsyncAction =
      AsyncAction('BPActivityStoreBase.getActivities', context: context);

  @override
  Future<List<BPActivity>> getActivities({bool cancelPrevious = false}) {
    return _$getActivitiesAsyncAction
        .run(() => super.getActivities(cancelPrevious: cancelPrevious));
  }

  late final _$BPActivityStoreBaseActionController =
      ActionController(name: 'BPActivityStoreBase', context: context);

  @override
  Future<void> refresh() {
    final _$actionInfo = _$BPActivityStoreBaseActionController.startAction(
        name: 'BPActivityStoreBase.refresh');
    try {
      return super.refresh();
    } finally {
      _$BPActivityStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  Future<void> initQuery() {
    final _$actionInfo = _$BPActivityStoreBaseActionController.startAction(
        name: 'BPActivityStoreBase.initQuery');
    try {
      return super.initQuery();
    } finally {
      _$BPActivityStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void onChanged(
      {List<BPActivity>? include,
      List<BPActivity>? exclude,
      String? search,
      String? type}) {
    final _$actionInfo = _$BPActivityStoreBaseActionController.startAction(
        name: 'BPActivityStoreBase.onChanged');
    try {
      return super.onChanged(
          include: include, exclude: exclude, search: search, type: type);
    } finally {
      _$BPActivityStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
fetchActivitiesFuture: ${fetchActivitiesFuture},
pending: ${pending},
loading: ${loading},
nextPage: ${nextPage},
activities: ${activities},
canLoadMore: ${canLoadMore},
perPage: ${perPage},
search: ${search},
type: ${type},
displayComments: ${displayComments},
groupId: ${groupId},
userId: ${userId}
    ''';
  }
}
