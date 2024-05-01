// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'coupon_smart_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$CouponSmartStore on CouponSmartBase, Store {
  Computed<bool>? _$loadingCouponComputed;

  @override
  bool get loadingCoupon =>
      (_$loadingCouponComputed ??= Computed<bool>(() => super.loadingCoupon,
              name: 'CouponSmartBase.loadingCoupon'))
          .value;
  Computed<List<Coupon>>? _$dataComputed;

  @override
  List<Coupon> get data =>
      (_$dataComputed ??= Computed<List<Coupon>>(() => super.data,
              name: 'CouponSmartBase.data'))
          .value;

  late final _$_loadingCouponAtom =
      Atom(name: 'CouponSmartBase._loadingCoupon', context: context);

  @override
  bool get _loadingCoupon {
    _$_loadingCouponAtom.reportRead();
    return super._loadingCoupon;
  }

  @override
  set _loadingCoupon(bool value) {
    _$_loadingCouponAtom.reportWrite(value, super._loadingCoupon, () {
      super._loadingCoupon = value;
    });
  }

  late final _$_dataAtom =
      Atom(name: 'CouponSmartBase._data', context: context);

  @override
  ObservableList<Coupon> get _data {
    _$_dataAtom.reportRead();
    return super._data;
  }

  @override
  set _data(ObservableList<Coupon> value) {
    _$_dataAtom.reportWrite(value, super._data, () {
      super._data = value;
    });
  }

  late final _$getCouponsAsyncAction =
      AsyncAction('CouponSmartBase.getCoupons', context: context);

  @override
  Future<void> getCoupons(Map<String, dynamic>? query) {
    return _$getCouponsAsyncAction.run(() => super.getCoupons(query));
  }

  @override
  String toString() {
    return '''
loadingCoupon: ${loadingCoupon},
data: ${data}
    ''';
  }
}
