import 'package:cirilla/service/helpers/request_helper.dart';
import 'package:cirilla/utils/debug.dart';
import 'package:dio/dio.dart';
import 'package:mobx/mobx.dart';

import '../models/models.dart';

part 'activity_store.g.dart';

class BPActivityStore = BPActivityStoreBase with _$BPActivityStore;

abstract class BPActivityStoreBase with Store {
  final String? key;

  // Request helper instance
  final RequestHelper _requestHelper;
  CancelToken _token = CancelToken();

  // constructor:---------------------------------------------------------------
  BPActivityStoreBase(
      this._requestHelper, {
        this.key,
        String? type,
        int? perPage,
        int? page,
        List<BPActivity>? include,
        List<BPActivity>? exclude,
        String? search,
        String? displayComments,
        int? groupId,
        int? userId,
      }) {
    if (page != null) {
      _nextPage = page;
      _initPage = page;
    }
    if (perPage != null) _perPage = perPage;
    if (include != null) _include = ObservableList<BPActivity>.of(include);
    if (exclude != null) _exclude = ObservableList<BPActivity>.of(exclude);
    if (search != null) _search = search;
    if (displayComments != null) _displayComments = displayComments;
    if (type != null) _type = type;
    if (groupId != null) _groupId = groupId;
    if (userId != null) _userId = userId;
    _reaction();
  }

  // store variables:-----------------------------------------------------------
  static ObservableFuture<List<BPActivity>> emptyActivitiesResponse = ObservableFuture.value([]);

  @observable
  ObservableFuture<List<BPActivity>?> fetchActivitiesFuture = emptyActivitiesResponse;

  @observable
  ObservableList<BPActivity> _activities = ObservableList<BPActivity>.of([]);

  @observable
  int _perPage = 10;

  @observable
  int _initPage = 1;

  @observable
  int _nextPage = 1;

  @observable
  bool _canLoadMore = true;

  @observable
  ObservableList<BPActivity> _include = ObservableList<BPActivity>.of([]);

  @observable
  ObservableList<BPActivity> _exclude = ObservableList<BPActivity>.of([]);

  @observable
  String _type = "all";

  @observable
  String _search = "";

  @observable
  int? _groupId;

  @observable
  int? _userId;

  @observable
  String? _displayComments;

  // computed:-------------------------------------------------------------------
  @computed
  bool get loading => fetchActivitiesFuture.status == FutureStatus.pending;

  @observable
  bool pending = false;

  @computed
  int get nextPage => _nextPage;

  @computed
  ObservableList<BPActivity> get activities => _activities;

  @computed
  bool get canLoadMore => _canLoadMore;

  @computed
  int get perPage => _perPage;

  @computed
  String get search => _search;

  @computed
  String get type => _type;

  @computed
  String? get displayComments => _displayComments;

  @computed
  int? get groupId => _groupId;

  @computed
  int? get userId => _userId;

  // actions:-------------------------------------------------------------------
  @action
  Future<List<BPActivity>> getActivities({bool cancelPrevious = false}) async {
    if (cancelPrevious) {
      _token.cancel("cancel");
      _token = CancelToken();
    }
    if (pending) {
      return ObservableList<BPActivity>.of([]);
    }

    pending = true;

    Map<String, dynamic> qs = {
      "page": _nextPage,
      "per_page": _perPage,
      if (_include.isNotEmpty) "include": _include.map((e) => e.id).toList().join(','),
      if (_exclude.isNotEmpty)  "exclude": _exclude.map((e) => e.id).toList().join(','),
      if (_type != "all") "type": _type,
      if (_search.isNotEmpty) "search": _search,
      if (_displayComments?.isNotEmpty == true) "display_comments": _displayComments,
      if (_groupId != null) "group_id": _groupId,
      if (_userId != null) "user_id": _userId,
      "app-builder-decode": true,
    };

    final future = _requestHelper.getActivities(queryParameters: qs, cancelToken: _token);
    fetchActivitiesFuture = ObservableFuture(future);
    return future.then((data) {
      // Replace state in the first time or refresh
      if (_nextPage <= _initPage) {
        _activities = ObservableList<BPActivity>.of(data!);
      } else {
        // Add posts when load more page
        _activities.addAll(ObservableList<BPActivity>.of(data!));
      }

      // Check if can load more item
      if (data.length >= _perPage) {
        _nextPage++;
      } else {
        _canLoadMore = false;
      }

      pending = false;
      return _activities;
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
    _activities.clear();
    return getActivities(cancelPrevious: true);
  }

  @action
  Future<void> initQuery() {
    pending = false;
    _canLoadMore = true;
    _nextPage = 1;
    return getActivities(cancelPrevious: true);
  }

  @action
  void onChanged({List<BPActivity>? include, List<BPActivity>? exclude, String? search, String? type}) {
    if (include != null) {
      _include = ObservableList<BPActivity>.of(include);
    }
    if (exclude != null) {
      _exclude = ObservableList<BPActivity>.of(exclude);
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
