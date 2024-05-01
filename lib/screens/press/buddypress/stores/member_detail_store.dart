import 'package:cirilla/service/helpers/request_helper.dart';
import 'package:dio/dio.dart';
import 'package:mobx/mobx.dart';

import '../models/models.dart';

part 'member_detail_store.g.dart';

class BPMemberDetailStore = BPMemberDetailStoreBase with _$BPMemberDetailStore;

abstract class BPMemberDetailStoreBase with Store {
  // Request helper instance
  final RequestHelper _requestHelper;
  final CancelToken _token = CancelToken();

  // constructor:---------------------------------------------------------------
  BPMemberDetailStoreBase(
    this._requestHelper, {
    required int id,
    BPMember? member,
  }) {
    _id = id;
    if (member != null) {
      _member = member;
    }
    _reaction();
  }

  // store variables:-----------------------------------------------------------

  @observable
  int? _id;

  @observable
  BPMember? _member;

  @observable
  String? _banner;

  @observable
  bool _loading = true;

  @observable
  String? _errorMessage;

  // computed:-------------------------------------------------------------------
  @computed
  bool get loading => _loading;

  @computed
  BPMember? get member => _member;

  @computed
  String? get banner => _banner;

  @computed
  String? get errorMessage => _errorMessage;

  // actions:-------------------------------------------------------------------
  @action
  Future<void> getData() async {
    try {
      _errorMessage = null;
      if (_member?.id == null && _id != 0) {
        Map<String, dynamic> qs = {
          "populate_extras": true,
          "app-builder-decode": true,
        };

        _member = await _requestHelper.getMember(id: _id ?? 0, queryParameters: qs, cancelToken: _token);
      }
      _banner = await _requestHelper
          .getBannerMember(
            id: _id ?? 0,
            queryParameters: {
              "app-builder-decode": true,
            },
            cancelToken: _token,
          )
          .onError((_, __) => null);
      _loading = false;
    } on DioException catch (e) {
      _loading = false;
      _errorMessage = e.response != null && e.response?.data != null ? e.response?.data['message'] : e.message;
    }
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
