import 'package:cirilla/service/helpers/request_helper.dart';
import 'package:cirilla/utils/debug.dart';
import 'package:mobx/mobx.dart';

import '../models/models.dart';

part 'conversation_store.g.dart';

class BPConversationStore = BPConversationStoreBase with _$BPConversationStore;

abstract class BPConversationStoreBase with Store {
  final String? key;

  // Request helper instance
  final RequestHelper _requestHelper;

  // store for handling errors
  // final ErrorStore errorStore = ErrorStore();

  // constructor:---------------------------------------------------------------
  BPConversationStoreBase(
      this._requestHelper, {
        this.key,
        int? perPage,
        int? page,
        String? box,
      }) {
    if (page != null) _nextPage = page;
    if (perPage != null) _perPage = perPage;
    if (box != null) _box = box;
    _reaction();
  }

  // store variables:-----------------------------------------------------------
  static ObservableFuture<List<BPConversation>> emptyConversationResponse = ObservableFuture.value([]);

  @observable
  ObservableFuture<List<BPConversation>?> fetchConversationsFuture = emptyConversationResponse;

  @observable
  ObservableList<BPConversation> _conversations = ObservableList<BPConversation>.of([]);

  @observable
  String _box = "inbox";

  @observable
  int _perPage = 10;

  @observable
  int _nextPage = 1;

  @observable
  bool _canLoadMore = true;

  // computed:-------------------------------------------------------------------
  @computed
  bool get loading => fetchConversationsFuture.status == FutureStatus.pending;

  @computed
  ObservableList<BPConversation> get conversations => _conversations;

  @observable
  bool pending = false;

  @computed
  int get nextPage => _nextPage;

  @computed
  bool get canLoadMore => _canLoadMore;

  @computed
  int get perPage => _perPage;

  @computed
  String get box => _box;

  // actions:-------------------------------------------------------------------
  @action
  Future<List<BPConversation>?> getConversations() async {
    if (pending) {
      return ObservableList<BPConversation>.of([]);
    }

    pending = true;

    Map<String, dynamic> qs = {
      "page": _nextPage,
      "per_page": _perPage,
      "box": _box,
    };

    final future = _requestHelper.getConversations(queryParameters: qs);

    fetchConversationsFuture = ObservableFuture(future);

    return future.then((data) {
      // Replace state in the first time or refresh
      if (_nextPage <= 1) {
        _conversations = ObservableList<BPConversation>.of(data!);
      } else {
        // Add posts when load more page
        _conversations.addAll(ObservableList<BPConversation>.of(data!));
      }

      // Check if can load more item
      if (data.length >= _perPage) {
        _nextPage++;
      } else {
        _canLoadMore = false;
      }

      pending = false;
      return _conversations;
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
    _conversations.clear();
    return getConversations();
  }

  @action
  void onChanged({String? box}) {
    if (box != null) {
      _box = box;
    }
  }

  // disposers:-----------------------------------------------------------------
  late List<ReactionDisposer> _disposers;

  void _reaction() {
    _disposers = [
      reaction((_) => _box, (dynamic box) {
        refresh();
      }),
    ];
  }

  void dispose() {
    for (final d in _disposers) {
      d();
    }
  }
}
