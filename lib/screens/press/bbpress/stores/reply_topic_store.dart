import 'package:cirilla/service/helpers/request_helper.dart';
import 'package:cirilla/utils/utils.dart';
import 'package:dio/dio.dart';
import 'package:mobx/mobx.dart';

import '../models/models.dart';

part 'reply_topic_store.g.dart';

class BBPReplyTopicStore = BBPReplyTopicStoreBase with _$BBPReplyTopicStore;

abstract class BBPReplyTopicStoreBase with Store {
  final String? key;

  // Request helper instance
  final RequestHelper _requestHelper;
  CancelToken _token = CancelToken();

  // constructor:---------------------------------------------------------------
  BBPReplyTopicStoreBase(
      this._requestHelper, {
        this.key,
        BBPTopic? topic,
        bool? enableUpdateTopic,
        int? perPage,
      }) {
    if (topic != null) _topic = topic;
    if (enableUpdateTopic != null) _enableUpdateTopic = enableUpdateTopic;
    if (perPage != null) _perPage = perPage;
    _reaction();
  }

  // store variables:-----------------------------------------------------------
  @observable
  BBPTopic? _topic;

  @observable
  bool _enableUpdateTopic = true;

  static ObservableFuture<Map> emptyRepliesResponse = ObservableFuture.value({});

  @observable
  ObservableFuture<Map?> fetchReplyFuture = emptyRepliesResponse;

  @observable
  ObservableList<BBPReply> _replies = ObservableList<BBPReply>.of([]);

  @observable
  int _perPage = 10;

  @observable
  int _nextPage = 1;

  @observable
  bool _canLoadMore = true;

  // computed:-------------------------------------------------------------------
  @computed
  BBPTopic? get topic => _topic;

  @computed
  bool get enableUpdateTopic => _enableUpdateTopic;

  @computed
  bool get loading => fetchReplyFuture.status == FutureStatus.pending;

  @observable
  bool pending = false;

  @computed
  int get nextPage => _nextPage;

  @computed
  ObservableList<BBPReply> get replies => _replies;

  @computed
  bool get canLoadMore => _canLoadMore;

  @computed
  int get perPage => _perPage;

  // actions:-------------------------------------------------------------------
  @action
  Future<List<BBPReply>> getReplies({bool cancelPrevious = false}) async {
    if (cancelPrevious) {
      _token.cancel("cancel");
      _token = CancelToken();
    }
    if (pending) {
      return ObservableList<BBPReply>.of([]);
    }

    pending = true;

    Map<String, dynamic> qs = {
      "page": _nextPage,
      "per_page": _perPage,
      "_embed": true,
    };

    final future = _requestHelper.getTopic(id: _topic?.id ?? 0, queryParameters: qs, cancelToken: _token);
    fetchReplyFuture = ObservableFuture(future);
    return future.then((res) {
      if (enableUpdateTopic && res is Map) {
        _topic = BBPTopic.fromJson(res.cast());
        _enableUpdateTopic = false;
      }

      List dataReplies = res?["replies"] ?? [];
      int dataNextPage = ConvertData.stringToInt(res?["next_page"]);

      List<BBPReply> data = dataReplies.map((m) => BBPReply.fromJson(m)).toList().cast<BBPReply>();

      // Replace state in the first time or refresh
      if (_nextPage <= 1) {
        _replies = ObservableList<BBPReply>.of(data);
      } else {
        // Add posts when load more page
        _replies.addAll(ObservableList<BBPReply>.of(data));
      }

      // Check if can load more item
      if (dataNextPage > _nextPage) {
        _nextPage = dataNextPage;
      } else {
        // Add posts end
        _replies.addAll(ObservableList<BBPReply>.of([
          BBPReply(
            id: ConvertData.stringToInt(res?["id"]),
            title: res?["title"],
            content: res?["content"],
            parent: 0,
            authorName: res?["author_name"],
            date: res?["post_date"],
          )
        ]));
        _canLoadMore = false;
      }

      pending = false;
      return _replies;
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
    _replies.clear();
    return getReplies(cancelPrevious: true);
  }

  @action
  Future<void> initQuery() {
    pending = false;
    _canLoadMore = true;
    _nextPage = 1;
    return getReplies(cancelPrevious: true);
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
