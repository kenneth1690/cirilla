// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'member_required_friend_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$BPMemberRequiredFriendStore on BPMemberRequiredFriendStoreBase, Store {
  Computed<bool>? _$loadingComputed;

  @override
  bool get loading => (_$loadingComputed ??= Computed<bool>(() => super.loading,
          name: 'BPMemberRequiredFriendStoreBase.loading'))
      .value;
  Computed<int>? _$nextPageComputed;

  @override
  int get nextPage =>
      (_$nextPageComputed ??= Computed<int>(() => super.nextPage,
              name: 'BPMemberRequiredFriendStoreBase.nextPage'))
          .value;
  Computed<ObservableList<BPMember>>? _$membersComputed;

  @override
  ObservableList<BPMember> get members => (_$membersComputed ??=
          Computed<ObservableList<BPMember>>(() => super.members,
              name: 'BPMemberRequiredFriendStoreBase.members'))
      .value;
  Computed<bool>? _$canLoadMoreComputed;

  @override
  bool get canLoadMore =>
      (_$canLoadMoreComputed ??= Computed<bool>(() => super.canLoadMore,
              name: 'BPMemberRequiredFriendStoreBase.canLoadMore'))
          .value;
  Computed<int>? _$perPageComputed;

  @override
  int get perPage => (_$perPageComputed ??= Computed<int>(() => super.perPage,
          name: 'BPMemberRequiredFriendStoreBase.perPage'))
      .value;

  late final _$_membersAtom =
      Atom(name: 'BPMemberRequiredFriendStoreBase._members', context: context);

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

  late final _$_idAtom =
      Atom(name: 'BPMemberRequiredFriendStoreBase._id', context: context);

  @override
  int? get _id {
    _$_idAtom.reportRead();
    return super._id;
  }

  @override
  set _id(int? value) {
    _$_idAtom.reportWrite(value, super._id, () {
      super._id = value;
    });
  }

  late final _$_perPageAtom =
      Atom(name: 'BPMemberRequiredFriendStoreBase._perPage', context: context);

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
      Atom(name: 'BPMemberRequiredFriendStoreBase._initPage', context: context);

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
      Atom(name: 'BPMemberRequiredFriendStoreBase._nextPage', context: context);

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

  late final _$_loadingAtom =
      Atom(name: 'BPMemberRequiredFriendStoreBase._loading', context: context);

  @override
  bool get _loading {
    _$_loadingAtom.reportRead();
    return super._loading;
  }

  @override
  set _loading(bool value) {
    _$_loadingAtom.reportWrite(value, super._loading, () {
      super._loading = value;
    });
  }

  late final _$_canLoadMoreAtom = Atom(
      name: 'BPMemberRequiredFriendStoreBase._canLoadMore', context: context);

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
      Atom(name: 'BPMemberRequiredFriendStoreBase.pending', context: context);

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

  late final _$getMembersAsyncAction = AsyncAction(
      'BPMemberRequiredFriendStoreBase.getMembers',
      context: context);

  @override
  Future<void> getMembers({bool cancelPrevious = false}) {
    return _$getMembersAsyncAction
        .run(() => super.getMembers(cancelPrevious: cancelPrevious));
  }

  late final _$BPMemberRequiredFriendStoreBaseActionController =
      ActionController(
          name: 'BPMemberRequiredFriendStoreBase', context: context);

  @override
  Future<void> refresh() {
    final _$actionInfo = _$BPMemberRequiredFriendStoreBaseActionController
        .startAction(name: 'BPMemberRequiredFriendStoreBase.refresh');
    try {
      return super.refresh();
    } finally {
      _$BPMemberRequiredFriendStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void onChanged({List<BPMember>? members}) {
    final _$actionInfo = _$BPMemberRequiredFriendStoreBaseActionController
        .startAction(name: 'BPMemberRequiredFriendStoreBase.onChanged');
    try {
      return super.onChanged(members: members);
    } finally {
      _$BPMemberRequiredFriendStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
pending: ${pending},
loading: ${loading},
nextPage: ${nextPage},
members: ${members},
canLoadMore: ${canLoadMore},
perPage: ${perPage}
    ''';
  }
}
