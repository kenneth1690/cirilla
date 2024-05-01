import 'package:cirilla/service/helpers/request_helper.dart';
import 'package:cirilla/utils/debug.dart';
import 'package:dio/dio.dart';
import 'package:mobx/mobx.dart';

import '../models/models.dart';

part 'forum_store.g.dart';

class BBPForumStore = BBPForumStoreBase with _$BBPForumStore;

abstract class BBPForumStoreBase with Store {
  final String? key;

  // Request helper instance
  final RequestHelper _requestHelper;
  CancelToken _token = CancelToken();

  // constructor:---------------------------------------------------------------
  BBPForumStoreBase(
      this._requestHelper, {
        this.key,
        int? perPage,
        int? page,
      }) {
    if (page != null) _nextPage = page;
    if (perPage != null) _perPage = perPage;
    _reaction();
  }

  // store variables:-----------------------------------------------------------
  static ObservableFuture<List<BBPForum>> emptyForumsResponse = ObservableFuture.value([]);

  @observable
  ObservableFuture<List<BBPForum>?> fetchForumsFuture = emptyForumsResponse;

  @observable
  ObservableList<BBPForum> _members = ObservableList<BBPForum>.of([]);

  @observable
  int _perPage = 10;

  @observable
  int _nextPage = 1;

  @observable
  bool _canLoadMore = true;

  // computed:-------------------------------------------------------------------
  @computed
  bool get loading => fetchForumsFuture.status == FutureStatus.pending;

  @observable
  bool pending = false;

  @computed
  int get nextPage => _nextPage;

  @computed
  ObservableList<BBPForum> get members => _members;

  @computed
  bool get canLoadMore => _canLoadMore;

  @computed
  int get perPage => _perPage;

  // actions:-------------------------------------------------------------------
  @action
  Future<List<BBPForum>> getForums({bool cancelPrevious = false}) async {
    if (cancelPrevious) {
      _token.cancel("cancel");
      _token = CancelToken();
    }
    if (pending) {
      return ObservableList<BBPForum>.of([]);
    }

    pending = true;

    Map<String, dynamic> qs = {
      "page": _nextPage,
      "per_page": _perPage,
    };

    final future = _requestHelper.getForums(queryParameters: qs, cancelToken: _token);
    fetchForumsFuture = ObservableFuture(future);
    return future.then((data) {
      // Replace state in the first time or refresh
      if (_nextPage <= 1) {
        _members = ObservableList<BBPForum>.of(data!);
      } else {
        // Add posts when load more page
        _members.addAll(ObservableList<BBPForum>.of(data!));
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
    _nextPage = 1;
    _members.clear();
    return getForums(cancelPrevious: true);
  }

  // disposers:-----------------------------------------------------------------
  late List<ReactionDisposer> _disposers;

  void _reaction() {
    _disposers = [];
  }

  void dispose() {
    for (final d in _disposers) {
      d();
    }
    _token.cancel("cancel");
  }
}
