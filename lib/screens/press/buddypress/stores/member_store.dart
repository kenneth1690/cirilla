import 'package:cirilla/service/helpers/request_helper.dart';
import 'package:cirilla/utils/debug.dart';
import 'package:dio/dio.dart';
import 'package:mobx/mobx.dart';

import '../models/models.dart';

part 'member_store.g.dart';

class BPMemberStore = BPMemberStoreBase with _$BPMemberStore;

abstract class BPMemberStoreBase with Store {
  final String? key;

  // Request helper instance
  final RequestHelper _requestHelper;
  CancelToken _token = CancelToken();

  // constructor:---------------------------------------------------------------
  BPMemberStoreBase(
      this._requestHelper, {
        this.key,
        int? perPage,
        int? page,
        List<BPMember>? include,
        List<BPMember>? exclude,
        String? search,
        String? type,
        int? userId,
      }) {
    if (page != null) {
      _initPage = page;
      _nextPage = page;
    }
    if (perPage != null) _perPage = perPage;
    if (include != null) _include = ObservableList<BPMember>.of(include);
    if (exclude != null) _exclude = ObservableList<BPMember>.of(exclude);
    if (search != null) _search = search;
    if (type != null) _type = type;
    if (userId != null) _userId = userId;
    _reaction();
  }

  // store variables:-----------------------------------------------------------
  static ObservableFuture<List<BPMember>> emptyMembersResponse = ObservableFuture.value([]);

  @observable
  ObservableFuture<List<BPMember>?> fetchMembersFuture = emptyMembersResponse;

  @observable
  ObservableList<BPMember> _members = ObservableList<BPMember>.of([]);

  @observable
  int _perPage = 10;

  @observable
  int _initPage = 1;

  @observable
  int _nextPage = 1;

  @observable
  bool _canLoadMore = true;

  @observable
  ObservableList<BPMember> _include = ObservableList<BPMember>.of([]);

  @observable
  ObservableList<BPMember> _exclude = ObservableList<BPMember>.of([]);

  @observable
  String _search = "";

  @observable
  String _type = "active";

  @observable
  int? _userId;

  // computed:-------------------------------------------------------------------
  @computed
  bool get loading => fetchMembersFuture.status == FutureStatus.pending;

  @observable
  bool pending = false;

  @computed
  int get nextPage => _nextPage;

  @computed
  ObservableList<BPMember> get members => _members;

  @computed
  bool get canLoadMore => _canLoadMore;

  @computed
  int get perPage => _perPage;

  @computed
  String get search => _search;

  @computed
  String get type => _type;

  // actions:-------------------------------------------------------------------
  @action
  Future<List<BPMember>> getMembers({bool cancelPrevious = false}) async {
    if (cancelPrevious) {
      _token.cancel("cancel");
      _token = CancelToken();
    }
    if (pending) {
      return ObservableList<BPMember>.of([]);
    }

    pending = true;

    Map<String, dynamic> qs = {
      "context": "view",
      "page": _nextPage,
      "per_page": _perPage,
      "type": _type,
      if (_include.isNotEmpty) "include": _include.map((e) => e.id).toList().join(','),
      if (_exclude.isNotEmpty) "exclude": _exclude.map((e) => e.id).toList().join(','),
      if (_search.isNotEmpty) "search": _search,
      if (_userId!= null) "user_id": _userId,
      "populate_extras": true,
      "app-builder-decode": true,
    };

    final future = _requestHelper.getMembers(queryParameters: qs, cancelToken: _token);
    fetchMembersFuture = ObservableFuture(future);
    return future.then((data) {
      // Replace state in the first time or refresh
      if (_nextPage <= _initPage) {
        _members = ObservableList<BPMember>.of(data!);
      } else {
        // Add posts when load more page
        _members.addAll(ObservableList<BPMember>.of(data!));
      }

      // Check if can load more item
      if (data.length >= _perPage) {
        _nextPage++;
      } else {
        _canLoadMore = false;
      }

      pending = false;
      return _members;
    }).catchError((error) {
      pending = false;
      _canLoadMore = false;
      avoidPrint(error);
      throw error;
    });
  }

  @action
  Future<void> refresh() {
    pending = false;
    _canLoadMore = true;
    _nextPage = _initPage;
    _members.clear();
    return getMembers(cancelPrevious: true);
  }

  @action
  void onChanged({List<BPMember>? include, List<BPMember>? exclude, String? search,  String? type, List<BPMember>? members}) {
    if (include != null) {
      _include = ObservableList<BPMember>.of(include);
    }
    if (exclude != null) {
      _exclude = ObservableList<BPMember>.of(exclude);
    }
    if (search != null) {
      _search = search;
    }
    if (type != null) {
      _type = type;
    }
    if (members != null) {
      _members = ObservableList<BPMember>.of(members);
    }
  }

  // disposers:-----------------------------------------------------------------
  late List<ReactionDisposer> _disposers;

  void _reaction() {
    _disposers = [
      reaction((_) => _search, (dynamic search) {
        refresh();
      }),
      reaction((_) => _type, (dynamic type) {
        refresh();
      }),
    ];
  }

  void dispose() {
    for (final d in _disposers) {
      d();
    }
    _token.cancel("cancel");
  }
}
