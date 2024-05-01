// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'wishlist_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$WishListStore on WishListStoreBase, Store {
  Computed<ObservableList<String>>? _$dataComputed;

  @override
  ObservableList<String> get data =>
      (_$dataComputed ??= Computed<ObservableList<String>>(() => super.data,
              name: 'WishListStoreBase.data'))
          .value;
  Computed<int>? _$countComputed;

  @override
  int get count => (_$countComputed ??=
          Computed<int>(() => super.count, name: 'WishListStoreBase.count'))
      .value;
  Computed<ObservableList<dynamic>>? _$dataWishlistProductComputed;

  @override
  ObservableList<dynamic> get dataWishlistProduct =>
      (_$dataWishlistProductComputed ??= Computed<ObservableList<dynamic>>(
              () => super.dataWishlistProduct,
              name: 'WishListStoreBase.dataWishlistProduct'))
          .value;
  Computed<bool?>? _$enableWishlistPluginComputed;

  @override
  bool? get enableWishlistPlugin => (_$enableWishlistPluginComputed ??=
          Computed<bool?>(() => super.enableWishlistPlugin,
              name: 'WishListStoreBase.enableWishlistPlugin'))
      .value;

  late final _$_dataAtom =
      Atom(name: 'WishListStoreBase._data', context: context);

  @override
  ObservableList<String> get _data {
    _$_dataAtom.reportRead();
    return super._data;
  }

  @override
  set _data(ObservableList<String> value) {
    _$_dataAtom.reportWrite(value, super._data, () {
      super._data = value;
    });
  }

  late final _$fetchProductsFutureAtom =
      Atom(name: 'WishListStoreBase.fetchProductsFuture', context: context);

  @override
  ObservableFuture<dynamic> get fetchProductsFuture {
    _$fetchProductsFutureAtom.reportRead();
    return super.fetchProductsFuture;
  }

  @override
  set fetchProductsFuture(ObservableFuture<dynamic> value) {
    _$fetchProductsFutureAtom.reportWrite(value, super.fetchProductsFuture, () {
      super.fetchProductsFuture = value;
    });
  }

  late final _$_dataWishlistProductAtom =
      Atom(name: 'WishListStoreBase._dataWishlistProduct', context: context);

  @override
  ObservableList<dynamic> get _dataWishlistProduct {
    _$_dataWishlistProductAtom.reportRead();
    return super._dataWishlistProduct;
  }

  @override
  set _dataWishlistProduct(ObservableList<dynamic> value) {
    _$_dataWishlistProductAtom.reportWrite(value, super._dataWishlistProduct,
        () {
      super._dataWishlistProduct = value;
    });
  }

  late final _$offsetPageAtom =
      Atom(name: 'WishListStoreBase.offsetPage', context: context);

  @override
  int get offsetPage {
    _$offsetPageAtom.reportRead();
    return super.offsetPage;
  }

  @override
  set offsetPage(int value) {
    _$offsetPageAtom.reportWrite(value, super.offsetPage, () {
      super.offsetPage = value;
    });
  }

  late final _$nxPageAtom =
      Atom(name: 'WishListStoreBase.nxPage', context: context);

  @override
  int get nxPage {
    _$nxPageAtom.reportRead();
    return super.nxPage;
  }

  @override
  set nxPage(int value) {
    _$nxPageAtom.reportWrite(value, super.nxPage, () {
      super.nxPage = value;
    });
  }

  late final _$countPageAtom =
      Atom(name: 'WishListStoreBase.countPage', context: context);

  @override
  int get countPage {
    _$countPageAtom.reportRead();
    return super.countPage;
  }

  @override
  set countPage(int value) {
    _$countPageAtom.reportWrite(value, super.countPage, () {
      super.countPage = value;
    });
  }

  late final _$_enableWishlistPluginAtom =
      Atom(name: 'WishListStoreBase._enableWishlistPlugin', context: context);

  @override
  bool get _enableWishlistPlugin {
    _$_enableWishlistPluginAtom.reportRead();
    return super._enableWishlistPlugin;
  }

  @override
  set _enableWishlistPlugin(bool value) {
    _$_enableWishlistPluginAtom.reportWrite(value, super._enableWishlistPlugin,
        () {
      super._enableWishlistPlugin = value;
    });
  }

  late final _$addWishListAsyncAction =
      AsyncAction('WishListStoreBase.addWishList', context: context);

  @override
  Future<void> addWishList(String value, {int? position}) {
    return _$addWishListAsyncAction
        .run(() => super.addWishList(value, position: position));
  }

  late final _$getDataWishlistPluginAsyncAction =
      AsyncAction('WishListStoreBase.getDataWishlistPlugin', context: context);

  @override
  Future<void> getDataWishlistPlugin() {
    return _$getDataWishlistPluginAsyncAction
        .run(() => super.getDataWishlistPlugin());
  }

  late final _$getWishlistByUserAsyncAction =
      AsyncAction('WishListStoreBase.getWishlistByUser', context: context);

  @override
  Future<dynamic> getWishlistByUser(String id) {
    return _$getWishlistByUserAsyncAction
        .run(() => super.getWishlistByUser(id));
  }

  late final _$addWishlistProductShareKeyAsyncAction = AsyncAction(
      'WishListStoreBase.addWishlistProductShareKey',
      context: context);

  @override
  Future<void> addWishlistProductShareKey(
      {required String shareKey, required int productId}) {
    return _$addWishlistProductShareKeyAsyncAction.run(() => super
        .addWishlistProductShareKey(shareKey: shareKey, productId: productId));
  }

  late final _$removeWishlistProductAsyncAction =
      AsyncAction('WishListStoreBase.removeWishlistProduct', context: context);

  @override
  Future<void> removeWishlistProduct({required int productId}) {
    return _$removeWishlistProductAsyncAction
        .run(() => super.removeWishlistProduct(productId: productId));
  }

  late final _$WishListStoreBaseActionController =
      ActionController(name: 'WishListStoreBase', context: context);

  @override
  void setWishlistPlugin(bool value) {
    final _$actionInfo = _$WishListStoreBaseActionController.startAction(
        name: 'WishListStoreBase.setWishlistPlugin');
    try {
      return super.setWishlistPlugin(value);
    } finally {
      _$WishListStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void updateWishList(List<String> newWishlist) {
    final _$actionInfo = _$WishListStoreBaseActionController.startAction(
        name: 'WishListStoreBase.updateWishList');
    try {
      return super.updateWishList(newWishlist);
    } finally {
      _$WishListStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
fetchProductsFuture: ${fetchProductsFuture},
offsetPage: ${offsetPage},
nxPage: ${nxPage},
countPage: ${countPage},
data: ${data},
count: ${count},
dataWishlistProduct: ${dataWishlistProduct},
enableWishlistPlugin: ${enableWishlistPlugin}
    ''';
  }
}
