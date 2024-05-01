// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'variation_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$VariationStore on VariationStoreBase, Store {
  Computed<ObservableMap<String, dynamic>?>? _$dataComputed;

  @override
  ObservableMap<String, dynamic>? get data => (_$dataComputed ??=
          Computed<ObservableMap<String, dynamic>?>(() => super.data,
              name: 'VariationStoreBase.data'))
      .value;
  Computed<ObservableMap<String?, String?>>? _$selectedComputed;

  @override
  ObservableMap<String?, String?> get selected => (_$selectedComputed ??=
          Computed<ObservableMap<String?, String?>>(() => super.selected,
              name: 'VariationStoreBase.selected'))
      .value;
  Computed<bool>? _$loadingComputed;

  @override
  bool get loading => (_$loadingComputed ??= Computed<bool>(() => super.loading,
          name: 'VariationStoreBase.loading'))
      .value;
  Computed<bool>? _$canAddToCartComputed;

  @override
  bool get canAddToCart =>
      (_$canAddToCartComputed ??= Computed<bool>(() => super.canAddToCart,
              name: 'VariationStoreBase.canAddToCart'))
          .value;
  Computed<Map<String, dynamic>>? _$findVariationComputed;

  @override
  Map<String, dynamic> get findVariation => (_$findVariationComputed ??=
          Computed<Map<String, dynamic>>(() => super.findVariation,
              name: 'VariationStoreBase.findVariation'))
      .value;
  Computed<Product?>? _$productVariationComputed;

  @override
  Product? get productVariation => (_$productVariationComputed ??=
          Computed<Product?>(() => super.productVariation,
              name: 'VariationStoreBase.productVariation'))
      .value;

  late final _$_langAtom =
      Atom(name: 'VariationStoreBase._lang', context: context);

  @override
  String get _lang {
    _$_langAtom.reportRead();
    return super._lang;
  }

  @override
  set _lang(String value) {
    _$_langAtom.reportWrite(value, super._lang, () {
      super._lang = value;
    });
  }

  late final _$_currencyAtom =
      Atom(name: 'VariationStoreBase._currency', context: context);

  @override
  String? get _currency {
    _$_currencyAtom.reportRead();
    return super._currency;
  }

  @override
  set _currency(String? value) {
    _$_currencyAtom.reportWrite(value, super._currency, () {
      super._currency = value;
    });
  }

  late final _$_productIdAtom =
      Atom(name: 'VariationStoreBase._productId', context: context);

  @override
  int? get _productId {
    _$_productIdAtom.reportRead();
    return super._productId;
  }

  @override
  set _productId(int? value) {
    _$_productIdAtom.reportWrite(value, super._productId, () {
      super._productId = value;
    });
  }

  late final _$_manageStockParentAtom =
      Atom(name: 'VariationStoreBase._manageStockParent', context: context);

  @override
  bool? get _manageStockParent {
    _$_manageStockParentAtom.reportRead();
    return super._manageStockParent;
  }

  @override
  set _manageStockParent(bool? value) {
    _$_manageStockParentAtom.reportWrite(value, super._manageStockParent, () {
      super._manageStockParent = value;
    });
  }

  late final _$_selectedAtom =
      Atom(name: 'VariationStoreBase._selected', context: context);

  @override
  ObservableMap<String?, String?> get _selected {
    _$_selectedAtom.reportRead();
    return super._selected;
  }

  @override
  set _selected(ObservableMap<String?, String?> value) {
    _$_selectedAtom.reportWrite(value, super._selected, () {
      super._selected = value;
    });
  }

  late final _$_dataAtom =
      Atom(name: 'VariationStoreBase._data', context: context);

  @override
  ObservableMap<String, dynamic>? get _data {
    _$_dataAtom.reportRead();
    return super._data;
  }

  @override
  set _data(ObservableMap<String, dynamic>? value) {
    _$_dataAtom.reportWrite(value, super._data, () {
      super._data = value;
    });
  }

  late final _$_loadingAtom =
      Atom(name: 'VariationStoreBase._loading', context: context);

  @override
  bool get _loading {
    _$_loadingAtom.reportRead();
    return super._loading;
  }

  @override
  set _loading(bool value) {
    _$_loadingAtom.reportWrite(value, super._loading, () {
      super._loading = value;
    });
  }

  late final _$getVariationAsyncAction =
      AsyncAction('VariationStoreBase.getVariation', context: context);

  @override
  Future<void> getVariation(List<Map<String, dynamic>>? defaultAttributes) {
    return _$getVariationAsyncAction
        .run(() => super.getVariation(defaultAttributes));
  }

  late final _$VariationStoreBaseActionController =
      ActionController(name: 'VariationStoreBase', context: context);

  @override
  void selectTerm({String? key, String? value}) {
    final _$actionInfo = _$VariationStoreBaseActionController.startAction(
        name: 'VariationStoreBase.selectTerm');
    try {
      return super.selectTerm(key: key, value: value);
    } finally {
      _$VariationStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void clear() {
    final _$actionInfo = _$VariationStoreBaseActionController.startAction(
        name: 'VariationStoreBase.clear');
    try {
      return super.clear();
    } finally {
      _$VariationStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  dynamic dispose() {
    final _$actionInfo = _$VariationStoreBaseActionController.startAction(
        name: 'VariationStoreBase.dispose');
    try {
      return super.dispose();
    } finally {
      _$VariationStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
data: ${data},
selected: ${selected},
loading: ${loading},
canAddToCart: ${canAddToCart},
findVariation: ${findVariation},
productVariation: ${productVariation}
    ''';
  }
}
