import 'package:cirilla/models/cart/cart.dart';
import 'package:cirilla/service/helpers/persist_helper.dart';
import 'package:cirilla/service/helpers/request_helper.dart';
import 'package:cirilla/store/auth/auth_store.dart';
import 'package:cirilla/store/cart/checkout_store.dart';
import 'package:cirilla/store/cart/coupon_smart_store.dart';
import 'package:cirilla/store/cart/payment_store.dart';
import 'package:cirilla/utils/debug.dart';
import 'package:dio/dio.dart';
import 'package:mobx/mobx.dart';

part 'cart_store.g.dart';

class CartStore = CartStoreBase with _$CartStore;

abstract class CartStoreBase with Store {
  late PaymentStore paymentStore;
  late CheckoutStore checkoutStore;
  late CouponSmartStore couponSmartStore;

  final PersistHelper _persistHelper;
  final RequestHelper _requestHelper;
  final AuthStore _authStore;

  final CancelToken _token = CancelToken();

  @observable
  bool _loading = false;

  @observable
  bool _loadingShipping = false;

  @observable
  bool _loadingAddCart = false;

  @observable
  bool _loadingCoupon = false;

  @observable
  String? _cartKey;

  @observable
  String? _cartNonce;

  @observable
  CartData? _cartData;

  @observable
  bool _canLoadMore = true;

  @observable
  bool _loadingRemoveCart = false;

  @computed
  bool get canLoadMore => _canLoadMore;

  @computed
  bool get loading => _loading;

  @computed
  bool get loadingShipping => _loadingShipping;

  @computed
  bool get loadingAddCart => _loadingAddCart;

  @computed
  bool get loadingCoupon => _loadingCoupon;

  @computed
  CartData? get cartData => _cartData;

  @computed
  int? get count => _cartData != null ? _cartData!.itemsCount : 0;

  @computed
  String? get cartKey => _cartKey;

  @computed
  bool get loadingRemoveCart => _loadingRemoveCart;

  // Action: -----------------------------------------------------------------------------------------------------------
  @action
  Future<void> setCartKey(String? cartKey) async {
    if (cartKey != '' && cartKey != null) {
      _cartKey ??= cartKey;
      if (_cartKey != _persistHelper.getCartKey()) {
        await _persistHelper.saveCartKey(_cartKey!);
      }
    }
  }

  @action
  Future<void> mergeCart({bool? isLogin}) async {
    await getCart();
  }

  @action
  Future<void> getCart([loading = true]) async {
    _loading = loading;
    try {
      Map<String, dynamic> params = await _preParamsCart();

      dynamic res = await _requestHelper.getCart(
        params: params,
        cancelToken: _token,
      );
      _cartData = CartData.fromJson(res.data);
      _cartNonce = "${res.headers.value('Nonce')}";
      _cartKey =  "${res.headers.value('Cart-Token')}";

      _loading = false;
      _canLoadMore = false;
    } on DioException {
      _loading = false;
      _canLoadMore = false;
      rethrow;
    }
  }

  @action
  Future<void> refresh() async {
    _canLoadMore = true;
    return getCart();
  }

  @action
  Future<void> updateQuantity({String? key, int? quantity, required int index}) async {
    // String? currency = await _persistHelper.getCurrency();
    try {
      if (key != null) {
        Map<String, dynamic> queryParameters = await _preParamsCart({
          'key': key,
          'quantity': quantity ?? 1,
          'cart_key': _cartKey,
        });

        Map<String, dynamic> header = await _preHeaderCart();

        Map<String, dynamic> json = await _requestHelper.updateQuantity(
          queryParameters: queryParameters,
          header: header,
        );
        _cartData = CartData.fromJson(json);
      }
    } on DioException {
      rethrow;
    }
  }

  @action
  Future<void> selectShipping({int? packageId, String? rateId}) async {
    try {
      String? currency = await _persistHelper.getCurrency();
      if (packageId != null && rateId != null) {
        _loadingShipping = true;
        Map<String, dynamic> json = await _requestHelper.selectShipping(
          cartKey: _cartKey,
          queryParameters: {
            'package_id': packageId,
            'rate_id': rateId,
            if (currency != null && currency != '') 'currency': currency,
          },
        );
        _cartData = CartData.fromJson(json);
        _loadingShipping = false;
      }
    } on DioException {
      _loadingShipping = false;
      rethrow;
    }
  }

  @action
  Future<void> updateCustomerCart({Map<String, dynamic>? data}) async {
    try {
      Map<String, dynamic> params = await _preParamsCart();
      Map<String, dynamic> header = await _preHeaderCart();
      Map<String, dynamic> json = await _requestHelper.updateCustomerCart(
        params: params,
        data: data,
        header: header,
      );
      _cartData = CartData.fromJson(json);
    } on DioException {
      rethrow;
    }
  }

  @action
  Future<void> applyCoupon({required String code}) async {
    _loadingCoupon = true;
    try {
      Map<String, dynamic> params = await _preParamsCart({
        'code': code,
      });
      Map<String, dynamic> header = await _preHeaderCart();
      Map<String, dynamic> json = await _requestHelper.applyCoupon(
        params: params,
        header: header,
      );
      _cartData = CartData.fromJson(json);
      _loadingCoupon = false;
    } on DioException {
      _loadingCoupon = false;
      rethrow;
    }
  }

  @action
  Future<void> removeCoupon({required String code}) async {
    _loading = true;
    try {
      Map<String, dynamic> params = await _preParamsCart({
        'code': code,
      });
      Map<String, dynamic> header = await _preHeaderCart();
      Map<String, dynamic> json = await _requestHelper.removeCoupon(
        params: params,
        header: header,
      );
      _cartData = CartData.fromJson(json);
      _loading = false;
    } on DioException {
      _loading = false;
      rethrow;
    }
  }

  @action
  Future<void> removeCart({String? key}) async {
    try {
      if (key != null) {
        _loadingRemoveCart = true;
        Map<String, dynamic> params = await _preParamsCart({
          'cart_key': _cartKey,
        });
        Map<String, dynamic> header = await _preHeaderCart();

        Map<String, dynamic> json = await _requestHelper.removeCart(
          params: params,
          data: {
            'key': key,
          },
          header: header,
        );
        _cartData = CartData.fromJson(json);
        _loadingRemoveCart = false;
      }
    } on DioException {
      _loadingRemoveCart = false;
      rethrow;
    }
  }

  ///
  /// clean cart contents when language change
  ///
  /// https://wpml.org/documentation/related-projects/woocommerce-multilingual/clearing-cart-contents-when-language-or-currency-change/
  ///
  @action
  Future<void> cleanCart() async {
    try {
      Map<String, dynamic> params = await _preParamsCart();
      Map<String, dynamic> header = await _preHeaderCart();
      await _requestHelper.cleanCart(
        params: params,
        header: header,
      );
      _cartKey = null;
      _cartNonce = null;
      _cartData = null;
    } on DioException {
      rethrow;
    }
  }

  @action
  Future<Map<String, dynamic>> addToCart(Map<String, dynamic> data) async {
    try {
      _loadingAddCart = true;
      // String? currency = await _persistHelper.getCurrency();

      Map<String, dynamic> cartData = Map<String, dynamic>.of(data);

      Map<String, dynamic> params = await _preParamsCart();
      Map<String, dynamic>? header = await _preHeaderCart();

      Map<String, dynamic> json = await _requestHelper.addToCart(
        params: params,
        data: cartData,
        header: header,
      );
      _cartData = CartData.fromJson(json);

      _loadingAddCart = false;
      return json;
    } on DioException {
      _loadingAddCart = false;
      rethrow;
    }
  }

  // Constructor: ------------------------------------------------------------------------------------------------------
  CartStoreBase(this._persistHelper, this._requestHelper, this._authStore) {
    _init();
    _reaction();
    paymentStore = PaymentStore(_requestHelper);
    checkoutStore = CheckoutStore(_persistHelper, _requestHelper, this as CartStore);
    couponSmartStore = CouponSmartStore(_requestHelper);
  }

  Future _init() async {
    await _restore();
    try {
      await getCart();
    } catch (e) {
      avoidPrint('GetCart - cancel.');
    }
  }

  Future<void> _restore() async {}

  // disposers:---------------------------------------------------------------------------------------------------------
  late List<ReactionDisposer> _disposers;

  void _reaction() {
    _disposers = [
      reaction((_) => _authStore.isLogin, (dynamic isLogin) => mergeCart(isLogin: isLogin)),
    ];
  }

  void dispose() {
    for (final d in _disposers) {
      d();
    }
    _token.cancel('Cancel get cart.');
  }

  /// Pre cart header
  Future<Map<String, dynamic>> _preHeaderCart([Map<String, dynamic> defaultParams = const {}]) async {
    if (_cartNonce == null) {
      await getCart();
    }
    Map<String, dynamic> header = {
      'Nonce': _cartNonce,
      ...defaultParams,
    };
    return header;
  }

  /// Pre cart params
  Future<Map<String, dynamic>> _preParamsCart([Map<String, dynamic> defaultParams = const {}]) async {
    String? currency = await _persistHelper.getCurrency();
    Map<String, dynamic> params = {
      if (_authStore.isLogin) 'app-builder-decode': 'true',
      if (currency != null && currency != '') 'currency': currency,
      ...defaultParams,
    };
    return params;
  }
}
