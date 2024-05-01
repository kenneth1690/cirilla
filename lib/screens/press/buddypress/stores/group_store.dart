import 'package:cirilla/service/helpers/request_helper.dart';
import 'package:cirilla/utils/debug.dart';
import 'package:dio/dio.dart';
import 'package:mobx/mobx.dart';

import '../models/models.dart';

part 'group_store.g.dart';

class BPGroupStore = BPGroupStoreBase with _$BPGroupStore;

abstract class BPGroupStoreBase with Store {
  final String? key;

  // Request helper instance
  final RequestHelper _requestHelper;
  CancelToken _token = CancelToken();

  // store for handling errors
  // final ErrorStore errorStore = ErrorStore();

  // constructor:---------------------------------------------------------------
  BPGroupStoreBase(
      this._requestHelper, {
        this.key,
        int? perPage,
        int? page,
        List<BPGroup>? include,
        List<BPGroup>? exclude,
        String? search,
        String? type,
      }) {
    if (page != null) {
      _nextPage = page;
      _initPage = page;
    }
    if (perPage != null) _perPage = perPage;
    if (include != null) _include = ObservableList<BPGroup>.of(include);
    if (exclude != null) _exclude = ObservableList<BPGroup>.of(exclude);
    if (search != null) _search = search;
    if (type != null) _type = type;
    _reaction();
  }

  // store variables:-----------------------------------------------------------
  static ObservableFuture<List<BPGroup>> emptyGroupsResponse = ObservableFuture.value([]);

  @observable
  ObservableFuture<List<BPGroup>?> fetchGroupsFuture = emptyGroupsResponse;

  @observable
  ObservableList<BPGroup> _groups = ObservableList<BPGroup>.of([]);

  @observable
  int _perPage = 10;

  @observable
  int _initPage = 1;

  @observable
  int _nextPage = 1;

  @observable
  bool _canLoadMore = true;

  @observable
  ObservableList<BPGroup> _include = ObservableList<BPGroup>.of([]);

  @observable
  ObservableList<BPGroup> _exclude = ObservableList<BPGroup>.of([]);

  @observable
  String _search = "";

  @observable
  String _type = "active";

  // computed:-------------------------------------------------------------------
  @computed
  bool get loading => fetchGroupsFuture.status == FutureStatus.pending;

  @observable
  bool pending = false;

  @computed
  int get nextPage => _nextPage;

  @computed
  ObservableList<BPGroup> get groups => _groups;

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
  Future<List<BPGroup>> getGroups({bool cancelPrevious = false}) async {
    if (cancelPrevious) {
      _token.cancel("cancel");
      _token = CancelToken();
    }
    if (pending) {
      return ObservableList<BPGroup>.of([]);
    }

    pending = true;

    Map<String, dynamic> qs = {
      "page": _nextPage,
      "per_page": _perPage,
      "include": _include.map((e) => e.id).toList().join(','),
      "exclude": _exclude.map((e) => e.id).toList().join(','),
      "search": _search,
      "type": _type,
      "populate_extras": true,
    };

    final future = _requestHelper.getGroups(queryParameters: qs, cancelToken: _token);
    fetchGroupsFuture = ObservableFuture(future);
    return future.then((data) {
      // Replace state in the first time or refresh
      if (_nextPage <= _initPage) {
        _groups = ObservableList<BPGroup>.of(data!);
      } else {
        // Add posts when load more page
        _groups.addAll(ObservableList<BPGroup>.of(data!));
      }

      // Check if can load more item
      if (data.length >= _perPage) {
        _nextPage++;
      } else {
        _canLoadMore = false;
      }

      pending = false;
      return _groups;
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
    _groups.clear();
    return getGroups(cancelPrevious: true);
  }

  @action
  void onChanged({List<BPGroup>? include, List<BPGroup>? exclude, String? search, String? type}) {
    if (include != null) {
      _include = ObservableList<BPGroup>.of(include);
    }
    if (exclude != null) {
      _exclude = ObservableList<BPGroup>.of(exclude);
    }
    if (search != null) {
      _search = search;
    }
    if (type != null) {
      _type = type;
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
