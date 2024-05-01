import 'package:cirilla/service/helpers/request_helper.dart';
import 'package:cirilla/utils/debug.dart';
import 'package:dio/dio.dart';
import 'package:mobx/mobx.dart';

import '../models/models.dart';

part 'member_required_friend_store.g.dart';

class BPMemberRequiredFriendStore = BPMemberRequiredFriendStoreBase with _$BPMemberRequiredFriendStore;

abstract class BPMemberRequiredFriendStoreBase with Store {
  final String? key;

  // Request helper instance
  final RequestHelper _requestHelper;
  CancelToken _token = CancelToken();

  // constructor:---------------------------------------------------------------
  BPMemberRequiredFriendStoreBase(
      this._requestHelper, {
        this.key,
        int? perPage,
        int? page,
        int? id,
      }) {
    if (page != null) {
      _initPage = page;
      _nextPage = page;
    }
    if (perPage != null) _perPage = perPage;
    if (id != null) _id = id;
    _reaction();
  }

  // store variables:-----------------------------------------------------------

  @observable
  ObservableList<BPMember> _members = ObservableList<BPMember>.of([]);

  @observable
  int? _id;

  @observable
  int _perPage = 10;

  @observable
  int _initPage = 1;

  @observable
  int _nextPage = 1;

  @observable
  bool _loading = true;

  @observable
  bool _canLoadMore = true;

  // computed:-------------------------------------------------------------------
  @computed
  bool get loading => _loading;

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

  // actions:-------------------------------------------------------------------
  @action
  Future<void> getMembers({bool cancelPrevious = false}) async {
    try {
      if (cancelPrevious) {
        _token.cancel("cancel");
        _token = CancelToken();
      }
      if (!pending) {
        _loading = true;
        pending = true;

        Map<String, dynamic> qsRequestFriend = {
          "context": "view",
          "page": _nextPage,
          "per_page": _perPage,
          "is_confirmed": 0,
          "friend_id": _id,
          "user_id": _id,
          "app-builder-decode": true,
        };

        List<int>? ids = await _requestHelper.getFriends(queryParameters: qsRequestFriend, cancelToken: _token);

        Map<String, dynamic> qs = {
          "context": "view",
          "include": ids?.join(',') ?? "",
          "populate_extras": true,
          "app-builder-decode": true,
        };

        List<BPMember>? data = await _requestHelper.getMembers(queryParameters: qs, cancelToken: _token);

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
        _loading = false;
      }

    } on DioException catch (e) {
      pending = false;
      _canLoadMore = false;
      _loading = false;
      avoidPrint(e);
    }
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
  void onChanged({List<BPMember>? members}) {
    if (members != null) {
      _members = ObservableList<BPMember>.of(members);
    }
  }

  // disposers:-----------------------------------------------------------------
  late List<ReactionDisposer> _disposers;

  void _reaction() {
    _disposers = [
    ];
  }

  void dispose() {
    for (final d in _disposers) {
      d();
    }
    _token.cancel("cancel");
  }
}
