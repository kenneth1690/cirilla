import 'package:cirilla/models/models.dart';
import 'package:cirilla/service/service.dart';
import 'package:dio/dio.dart';
import 'package:mobx/mobx.dart';

part 'coupon_smart_store.g.dart';

class CouponSmartStore = CouponSmartBase with _$CouponSmartStore;

abstract class CouponSmartBase with Store {
  final RequestHelper _requestHelper;

  // Constructor: ------------------------------------------------------------------------------------------------------
  CouponSmartBase(this._requestHelper) {
    _init();
    _reaction();
  }
  Future<void> _init() async {}

  // Observable: -------------------------------------------------------------------------------------------------------
  @observable
  bool _loadingCoupon = false;

  @observable
  ObservableList<Coupon> _data = ObservableList<Coupon>.of([]);

  @computed
  bool get loadingCoupon => _loadingCoupon;

  @computed
  List<Coupon> get data => _data;

  // Action: -----------------------------------------------------------------------------------------------------------
  @action
  Future<void> getCoupons(Map<String, dynamic>? query) async {
    try {
      _loadingCoupon = true;
      List<Coupon> data = await _requestHelper.getCouponList(query: query);
      data.sort((a, b) {
        if (a.isInvalid == true && b.isInvalid != true) {
          return 1;
        }
        return 0;
      });
      _data = ObservableList<Coupon>.of(data);
      _loadingCoupon = false;
    } on DioException catch (_) {
      _loadingCoupon = false;
    }
  }

  // disposers:---------------------------------------------------------------------------------------------------------
  late List<ReactionDisposer> _disposers;

  void _reaction() {
    _disposers = [];
  }

  void dispose() {
    for (final d in _disposers) {
      d();
    }
  }
}
