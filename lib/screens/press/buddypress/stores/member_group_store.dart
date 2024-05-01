import 'package:cirilla/service/helpers/request_helper.dart';
import 'package:cirilla/utils/debug.dart';
import 'package:dio/dio.dart';
import 'package:mobx/mobx.dart';

import '../models/models.dart';

part 'member_group_store.g.dart';

class BPMemberGroupStore = BPMemberGroupStoreBase with _$BPMemberGroupStore;

abstract class BPMemberGroupStoreBase with Store {
  final String? key;

  // Request helper instance
  final RequestHelper _requestHelper;
  CancelToken _token = CancelToken();

  // store for handling errors
  // final ErrorStore errorStore = ErrorStore();

  // constructor:---------------------------------------------------------------
  BPMemberGroupStoreBase(
      this._requestHelper, {
        this.key,
        int? idGroup,
        int? perPage,
        int? page,
        List<BPMemberGroup>? include,
        List<BPMemberGroup>? exclude,
        String? search,
        bool? excludeAdmins,
      }) {
    if (idGroup != null) _idGroup = idGroup;
    if (page != null) {
      _nextPage = page;
      _initPage = page;
    }
    if (perPage != null) _perPage = perPage;
    if (include != null) _include = ObservableList<BPMemberGroup>.of(include);
    if (exclude != null) _exclude = ObservableList<BPMemberGroup>.of(exclude);
    if (search != null) _search = search;
    if (excludeAdmins != null) _excludeAdmins = excludeAdmins;
    _reaction();
  }

  // store variables:-----------------------------------------------------------
  @observable
  int? _idGroup;

  static ObservableFuture<List<BPMemberGroup>> emptyMemberGroupResponse = ObservableFuture.value([]);

  @observable
  ObservableFuture<List<BPMemberGroup>?> fetchMemberGroupFuture = emptyMemberGroupResponse;

  @observable
  ObservableList<BPMemberGroup> _members = ObservableList<BPMemberGroup>.of([]);

  @observable
  int _perPage = 10;

  @observable
  int _initPage = 1;

  @observable
  int _nextPage = 1;

  @observable
  bool _canLoadMore = true;

  @observable
  ObservableList<BPMemberGroup> _include = ObservableList<BPMemberGroup>.of([]);

  @observable
  ObservableList<BPMemberGroup> _exclude = ObservableList<BPMemberGroup>.of([]);

  @observable
  String _search = "";

  @observable
  bool _excludeAdmins = false;

  // computed:-------------------------------------------------------------------
  @computed
  bool get loading => fetchMemberGroupFuture.status == FutureStatus.pending;

  @observable
  bool pending = false;

  @computed
  int get nextPage => _nextPage;

  @computed
  ObservableList<BPMemberGroup> get members => _members;

  @computed
  bool get canLoadMore => _canLoadMore;

  @computed
  int get perPage => _perPage;

  @computed
  String get search => _search;

  // actions:-------------------------------------------------------------------
  @action
  Future<List<BPMemberGroup>> getMemberGroups({bool cancelPrevious = false}) async {
    if (cancelPrevious) {
      _token.cancel("cancel");
      _token = CancelToken();
    }
    if (pending) {
      return ObservableList<BPMemberGroup>.of([]);
    }

    pending = true;

    Map<String, dynamic> qs = {
      "page": _nextPage,
      "per_page": _perPage,
      "include": _include.map((e) => e.id).toList().join(','),
      "exclude": _exclude.map((e) => e.id).toList().join(','),
      "search": _search,
      "exclude_admins": _excludeAdmins,
    };

    final future = _requestHelper.getMemberGroups(id: _idGroup,queryParameters: qs, cancelToken: _token);
    fetchMemberGroupFuture = ObservableFuture(future);
    return future.then((data) {
      // Replace state in the first time or refresh
      if (_nextPage <= 1) {
        _members = ObservableList<BPMemberGroup>.of(data!);
      } else {
        // Add posts when load more page
        _members.addAll(ObservableList<BPMemberGroup>.of(data!));
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
    return getMemberGroups(cancelPrevious: true);
  }

  @action
  void onChanged({List<BPMemberGroup>? include, List<BPMemberGroup>? exclude, String? search}) {
    if (include != null) {
      _include = ObservableList<BPMemberGroup>.of(include);
    }
    if (exclude != null) {
      _exclude = ObservableList<BPMemberGroup>.of(exclude);
    }
    if (search != null) {
      _search = search;
    }
  }

  // disposers:-----------------------------------------------------------------
  late List<ReactionDisposer> _disposers;

  void _reaction() {
    _disposers = [
      reaction((_) => _search, (dynamic search) {
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
