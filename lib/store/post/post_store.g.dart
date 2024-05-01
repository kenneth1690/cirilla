// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'post_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$PostStore on PostStoreBase, Store {
  Computed<String>? _$postTypeComputed;

  @override
  String get postType =>
      (_$postTypeComputed ??= Computed<String>(() => super.postType,
              name: 'PostStoreBase.postType'))
          .value;
  Computed<PostCategoryStore?>? _$postCategoryStoreComputed;

  @override
  PostCategoryStore? get postCategoryStore => (_$postCategoryStoreComputed ??=
          Computed<PostCategoryStore?>(() => super.postCategoryStore,
              name: 'PostStoreBase.postCategoryStore'))
      .value;
  Computed<PostTagStore?>? _$postTagStoreComputed;

  @override
  PostTagStore? get postTagStore => (_$postTagStoreComputed ??=
          Computed<PostTagStore?>(() => super.postTagStore,
              name: 'PostStoreBase.postTagStore'))
      .value;
  Computed<bool>? _$loadingComputed;

  @override
  bool get loading => (_$loadingComputed ??=
          Computed<bool>(() => super.loading, name: 'PostStoreBase.loading'))
      .value;
  Computed<int>? _$nextPageComputed;

  @override
  int get nextPage => (_$nextPageComputed ??=
          Computed<int>(() => super.nextPage, name: 'PostStoreBase.nextPage'))
      .value;
  Computed<ObservableList<Post>>? _$postsComputed;

  @override
  ObservableList<Post> get posts =>
      (_$postsComputed ??= Computed<ObservableList<Post>>(() => super.posts,
              name: 'PostStoreBase.posts'))
          .value;
  Computed<bool>? _$canLoadMoreComputed;

  @override
  bool get canLoadMore =>
      (_$canLoadMoreComputed ??= Computed<bool>(() => super.canLoadMore,
              name: 'PostStoreBase.canLoadMore'))
          .value;
  Computed<Map<dynamic, dynamic>>? _$sortComputed;

  @override
  Map<dynamic, dynamic> get sort =>
      (_$sortComputed ??= Computed<Map<dynamic, dynamic>>(() => super.sort,
              name: 'PostStoreBase.sort'))
          .value;
  Computed<int>? _$perPageComputed;

  @override
  int get perPage => (_$perPageComputed ??=
          Computed<int>(() => super.perPage, name: 'PostStoreBase.perPage'))
      .value;
  Computed<ObservableList<PostTag?>>? _$tagSelectedComputed;

  @override
  ObservableList<PostTag?> get tagSelected => (_$tagSelectedComputed ??=
          Computed<ObservableList<PostTag?>>(() => super.tagSelected,
              name: 'PostStoreBase.tagSelected'))
      .value;

  late final _$fetchPostsFutureAtom =
      Atom(name: 'PostStoreBase.fetchPostsFuture', context: context);

  @override
  ObservableFuture<List<Post>?> get fetchPostsFuture {
    _$fetchPostsFutureAtom.reportRead();
    return super.fetchPostsFuture;
  }

  @override
  set fetchPostsFuture(ObservableFuture<List<Post>?> value) {
    _$fetchPostsFutureAtom.reportWrite(value, super.fetchPostsFuture, () {
      super.fetchPostsFuture = value;
    });
  }

  late final _$_postsAtom =
      Atom(name: 'PostStoreBase._posts', context: context);

  @override
  ObservableList<Post> get _posts {
    _$_postsAtom.reportRead();
    return super._posts;
  }

  @override
  set _posts(ObservableList<Post> value) {
    _$_postsAtom.reportWrite(value, super._posts, () {
      super._posts = value;
    });
  }

  late final _$successAtom =
      Atom(name: 'PostStoreBase.success', context: context);

  @override
  bool get success {
    _$successAtom.reportRead();
    return super.success;
  }

  @override
  set success(bool value) {
    _$successAtom.reportWrite(value, super.success, () {
      super.success = value;
    });
  }

  late final _$_postTypeAtom =
      Atom(name: 'PostStoreBase._postType', context: context);

  @override
  String get _postType {
    _$_postTypeAtom.reportRead();
    return super._postType;
  }

  @override
  set _postType(String value) {
    _$_postTypeAtom.reportWrite(value, super._postType, () {
      super._postType = value;
    });
  }

  late final _$_perPageAtom =
      Atom(name: 'PostStoreBase._perPage', context: context);

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

  late final _$_langAtom = Atom(name: 'PostStoreBase._lang', context: context);

  @override
  String? get _lang {
    _$_langAtom.reportRead();
    return super._lang;
  }

  @override
  set _lang(String? value) {
    _$_langAtom.reportWrite(value, super._lang, () {
      super._lang = value;
    });
  }

  late final _$_nextPageAtom =
      Atom(name: 'PostStoreBase._nextPage', context: context);

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
      Atom(name: 'PostStoreBase._canLoadMore', context: context);

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

  late final _$_searchAtom =
      Atom(name: 'PostStoreBase._search', context: context);

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

  late final _$_sortAtom = Atom(name: 'PostStoreBase._sort', context: context);

  @override
  Map<dynamic, dynamic> get _sort {
    _$_sortAtom.reportRead();
    return super._sort;
  }

  @override
  set _sort(Map<dynamic, dynamic> value) {
    _$_sortAtom.reportWrite(value, super._sort, () {
      super._sort = value;
    });
  }

  late final _$_categorySelectedAtom =
      Atom(name: 'PostStoreBase._categorySelected', context: context);

  @override
  ObservableList<PostCategory?> get _categorySelected {
    _$_categorySelectedAtom.reportRead();
    return super._categorySelected;
  }

  @override
  set _categorySelected(ObservableList<PostCategory?> value) {
    _$_categorySelectedAtom.reportWrite(value, super._categorySelected, () {
      super._categorySelected = value;
    });
  }

  late final _$_tagSelectedAtom =
      Atom(name: 'PostStoreBase._tagSelected', context: context);

  @override
  ObservableList<PostTag?> get _tagSelected {
    _$_tagSelectedAtom.reportRead();
    return super._tagSelected;
  }

  @override
  set _tagSelected(ObservableList<PostTag?> value) {
    _$_tagSelectedAtom.reportWrite(value, super._tagSelected, () {
      super._tagSelected = value;
    });
  }

  late final _$_authorsAtom =
      Atom(name: 'PostStoreBase._authors', context: context);

  @override
  ObservableList<int?> get _authors {
    _$_authorsAtom.reportRead();
    return super._authors;
  }

  @override
  set _authors(ObservableList<int?> value) {
    _$_authorsAtom.reportWrite(value, super._authors, () {
      super._authors = value;
    });
  }

  late final _$_includeAtom =
      Atom(name: 'PostStoreBase._include', context: context);

  @override
  ObservableList<Post> get _include {
    _$_includeAtom.reportRead();
    return super._include;
  }

  @override
  set _include(ObservableList<Post> value) {
    _$_includeAtom.reportWrite(value, super._include, () {
      super._include = value;
    });
  }

  late final _$_excludeAtom =
      Atom(name: 'PostStoreBase._exclude', context: context);

  @override
  ObservableList<Post> get _exclude {
    _$_excludeAtom.reportRead();
    return super._exclude;
  }

  @override
  set _exclude(ObservableList<Post> value) {
    _$_excludeAtom.reportWrite(value, super._exclude, () {
      super._exclude = value;
    });
  }

  late final _$pendingAtom =
      Atom(name: 'PostStoreBase.pending', context: context);

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

  late final _$getPostsAsyncAction =
      AsyncAction('PostStoreBase.getPosts', context: context);

  @override
  Future<List<Post>> getPosts() {
    return _$getPostsAsyncAction.run(() => super.getPosts());
  }

  late final _$searchAsyncAction =
      AsyncAction('PostStoreBase.search', context: context);

  @override
  Future<List<PostSearch>?> search(
      {Map<String, dynamic>? queryParameters, CancelToken? cancelToken}) {
    return _$searchAsyncAction.run(() => super
        .search(queryParameters: queryParameters, cancelToken: cancelToken));
  }

  late final _$PostStoreBaseActionController =
      ActionController(name: 'PostStoreBase', context: context);

  @override
  Future<void> refresh() {
    final _$actionInfo = _$PostStoreBaseActionController.startAction(
        name: 'PostStoreBase.refresh');
    try {
      return super.refresh();
    } finally {
      _$PostStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void onChanged(
      {Map<dynamic, dynamic>? sort,
      String? search,
      List<PostCategory?>? categorySelected,
      List<PostTag?>? tagSelected,
      bool silent = false}) {
    final _$actionInfo = _$PostStoreBaseActionController.startAction(
        name: 'PostStoreBase.onChanged');
    try {
      return super.onChanged(
          sort: sort,
          search: search,
          categorySelected: categorySelected,
          tagSelected: tagSelected,
          silent: silent);
    } finally {
      _$PostStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
fetchPostsFuture: ${fetchPostsFuture},
success: ${success},
pending: ${pending},
postType: ${postType},
postCategoryStore: ${postCategoryStore},
postTagStore: ${postTagStore},
loading: ${loading},
nextPage: ${nextPage},
posts: ${posts},
canLoadMore: ${canLoadMore},
sort: ${sort},
perPage: ${perPage},
tagSelected: ${tagSelected}
    ''';
  }
}
