// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'filter_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$FilterStore on FilterStoreBase, Store {
  Computed<bool>? _$loadingAttributesComputed;

  @override
  bool get loadingAttributes => (_$loadingAttributesComputed ??=
          Computed<bool>(() => super.loadingAttributes, name: 'FilterStoreBase.loadingAttributes'))
      .value;
  Computed<bool>? _$onSaleComputed;

  @override
  bool get onSale => (_$onSaleComputed ??= Computed<bool>(() => super.onSale, name: 'FilterStoreBase.onSale')).value;
  Computed<bool>? _$inStockComputed;

  @override
  bool get inStock =>
      (_$inStockComputed ??= Computed<bool>(() => super.inStock, name: 'FilterStoreBase.inStock')).value;
  Computed<bool>? _$featuredComputed;

  @override
  bool get featured =>
      (_$featuredComputed ??= Computed<bool>(() => super.featured, name: 'FilterStoreBase.featured')).value;
  Computed<ObservableList<ProductCategory>>? _$categoriesComputed;

  @override
  ObservableList<ProductCategory> get categories => (_$categoriesComputed ??=
          Computed<ObservableList<ProductCategory>>(() => super.categories, name: 'FilterStoreBase.categories'))
      .value;
  Computed<RangeValues>? _$rangePricesComputed;

  @override
  RangeValues get rangePrices =>
      (_$rangePricesComputed ??= Computed<RangeValues>(() => super.rangePrices, name: 'FilterStoreBase.rangePrices'))
          .value;
  Computed<ProductPrices>? _$productPricesComputed;

  @override
  ProductPrices get productPrices => (_$productPricesComputed ??=
          Computed<ProductPrices>(() => super.productPrices, name: 'FilterStoreBase.productPrices'))
      .value;
  Computed<ObservableList<Attribute>>? _$attributesComputed;

  @override
  ObservableList<Attribute> get attributes => (_$attributesComputed ??=
          Computed<ObservableList<Attribute>>(() => super.attributes, name: 'FilterStoreBase.attributes'))
      .value;
  Computed<Brand?>? _$brandComputed;

  @override
  Brand? get brand => (_$brandComputed ??= Computed<Brand?>(() => super.brand, name: 'FilterStoreBase.brand')).value;
  Computed<String>? _$valuesComputed;

  @override
  String get values =>
      (_$valuesComputed ??= Computed<String>(() => super.values, name: 'FilterStoreBase.values')).value;
  Computed<ObservableList<ItemAttributeSelected>>? _$attributeSelectedComputed;

  @override
  ObservableList<ItemAttributeSelected> get attributeSelected =>
      (_$attributeSelectedComputed ??= Computed<ObservableList<ItemAttributeSelected>>(() => super.attributeSelected,
              name: 'FilterStoreBase.attributeSelected'))
          .value;

  late final _$_attributesAtom = Atom(name: 'FilterStoreBase._attributes', context: context);

  @override
  ObservableList<Attribute> get _attributes {
    _$_attributesAtom.reportRead();
    return super._attributes;
  }

  @override
  set _attributes(ObservableList<Attribute> value) {
    _$_attributesAtom.reportWrite(value, super._attributes, () {
      super._attributes = value;
    });
  }

  late final _$_productPricesAtom = Atom(name: 'FilterStoreBase._productPrices', context: context);

  @override
  ProductPrices get _productPrices {
    _$_productPricesAtom.reportRead();
    return super._productPrices;
  }

  @override
  set _productPrices(ProductPrices value) {
    _$_productPricesAtom.reportWrite(value, super._productPrices, () {
      super._productPrices = value;
    });
  }

  late final _$_rangePricesAtom = Atom(name: 'FilterStoreBase._rangePrices', context: context);

  @override
  RangeValues get _rangePrices {
    _$_rangePricesAtom.reportRead();
    return super._rangePrices;
  }

  @override
  set _rangePrices(RangeValues value) {
    _$_rangePricesAtom.reportWrite(value, super._rangePrices, () {
      super._rangePrices = value;
    });
  }

  late final _$_featuredAtom = Atom(name: 'FilterStoreBase._featured', context: context);

  @override
  bool get _featured {
    _$_featuredAtom.reportRead();
    return super._featured;
  }

  @override
  set _featured(bool value) {
    _$_featuredAtom.reportWrite(value, super._featured, () {
      super._featured = value;
    });
  }

  late final _$_onSaleAtom = Atom(name: 'FilterStoreBase._onSale', context: context);

  @override
  bool get _onSale {
    _$_onSaleAtom.reportRead();
    return super._onSale;
  }

  @override
  set _onSale(bool value) {
    _$_onSaleAtom.reportWrite(value, super._onSale, () {
      super._onSale = value;
    });
  }

  late final _$_inStockAtom = Atom(name: 'FilterStoreBase._inStock', context: context);

  @override
  bool get _inStock {
    _$_inStockAtom.reportRead();
    return super._inStock;
  }

  @override
  set _inStock(bool value) {
    _$_inStockAtom.reportWrite(value, super._inStock, () {
      super._inStock = value;
    });
  }

  late final _$_loadingAttributesAtom = Atom(name: 'FilterStoreBase._loadingAttributes', context: context);

  @override
  bool get _loadingAttributes {
    _$_loadingAttributesAtom.reportRead();
    return super._loadingAttributes;
  }

  @override
  set _loadingAttributes(bool value) {
    _$_loadingAttributesAtom.reportWrite(value, super._loadingAttributes, () {
      super._loadingAttributes = value;
    });
  }

  late final _$_categoriesAtom = Atom(name: 'FilterStoreBase._categories', context: context);

  @override
  ObservableList<ProductCategory> get _categories {
    _$_categoriesAtom.reportRead();
    return super._categories;
  }

  @override
  set _categories(ObservableList<ProductCategory> value) {
    _$_categoriesAtom.reportWrite(value, super._categories, () {
      super._categories = value;
    });
  }

  late final _$_attributeSelectedAtom = Atom(name: 'FilterStoreBase._attributeSelected', context: context);

  @override
  ObservableList<ItemAttributeSelected> get _attributeSelected {
    _$_attributeSelectedAtom.reportRead();
    return super._attributeSelected;
  }

  @override
  set _attributeSelected(ObservableList<ItemAttributeSelected> value) {
    _$_attributeSelectedAtom.reportWrite(value, super._attributeSelected, () {
      super._attributeSelected = value;
    });
  }

  late final _$_brandAtom = Atom(name: 'FilterStoreBase._brand', context: context);

  @override
  Brand? get _brand {
    _$_brandAtom.reportRead();
    return super._brand;
  }

  @override
  set _brand(Brand? value) {
    _$_brandAtom.reportWrite(value, super._brand, () {
      super._brand = value;
    });
  }

  late final _$itemExpandAtom = Atom(name: 'FilterStoreBase.itemExpand', context: context);

  @override
  ObservableMap<String?, bool> get itemExpand {
    _$itemExpandAtom.reportRead();
    return super.itemExpand;
  }

  @override
  set itemExpand(ObservableMap<String?, bool> value) {
    _$itemExpandAtom.reportWrite(value, super.itemExpand, () {
      super.itemExpand = value;
    });
  }

  late final _$_languageAtom = Atom(name: 'FilterStoreBase._language', context: context);

  @override
  String get _language {
    _$_languageAtom.reportRead();
    return super._language;
  }

  @override
  set _language(String value) {
    _$_languageAtom.reportWrite(value, super._language, () {
      super._language = value;
    });
  }

  late final _$getAttributesAsyncAction = AsyncAction('FilterStoreBase.getAttributes', context: context);

  @override
  Future<dynamic> getAttributes() {
    return _$getAttributesAsyncAction.run(() => super.getAttributes());
  }

  late final _$getMinMaxPricesAsyncAction = AsyncAction('FilterStoreBase.getMinMaxPrices', context: context);

  @override
  Future<void> getMinMaxPrices() {
    return _$getMinMaxPricesAsyncAction.run(() => super.getMinMaxPrices());
  }

  late final _$FilterStoreBaseActionController = ActionController(name: 'FilterStoreBase', context: context);

  @override
  void expand(String? key) {
    final _$actionInfo = _$FilterStoreBaseActionController.startAction(name: 'FilterStoreBase.expand');
    try {
      return super.expand(key);
    } finally {
      _$FilterStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void selectAttribute(ItemAttributeSelected value) {
    final _$actionInfo = _$FilterStoreBaseActionController.startAction(name: 'FilterStoreBase.selectAttribute');
    try {
      return super.selectAttribute(value);
    } finally {
      _$FilterStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setMinMaxPrice(double minPrice, double maxPrice) {
    final _$actionInfo = _$FilterStoreBaseActionController.startAction(name: 'FilterStoreBase.setMinMaxPrice');
    try {
      return super.setMinMaxPrice(minPrice, maxPrice);
    } finally {
      _$FilterStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void onChange(
      {Map<dynamic, dynamic>? sort,
      bool? onSale,
      bool? featured,
      bool? inStock,
      List<ProductCategory>? categories,
      Brand? brand,
      ProductPrices? productPrices,
      RangeValues? rangePrices,
      List<Attribute>? attributes,
      List<ItemAttributeSelected>? attributeSelected,
      bool refresh = false}) {
    final _$actionInfo = _$FilterStoreBaseActionController.startAction(name: 'FilterStoreBase.onChange');
    try {
      return super.onChange(
          sort: sort,
          onSale: onSale,
          featured: featured,
          inStock: inStock,
          categories: categories,
          brand: brand,
          productPrices: productPrices,
          rangePrices: rangePrices,
          attributes: attributes,
          attributeSelected: attributeSelected,
          refresh: refresh);
    } finally {
      _$FilterStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void clearAll({List<ProductCategory>? categories, Brand? brand}) {
    final _$actionInfo = _$FilterStoreBaseActionController.startAction(name: 'FilterStoreBase.clearAll');
    try {
      return super.clearAll(categories: categories, brand: brand);
    } finally {
      _$FilterStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void clearBrand({Brand? brand}) {
    final _$actionInfo = _$FilterStoreBaseActionController.startAction(name: 'FilterStoreBase.clearBrand');
    try {
      return super.clearBrand(brand: brand);
    } finally {
      _$FilterStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void clearCategory({List<ProductCategory>? categories}) {
    final _$actionInfo = _$FilterStoreBaseActionController.startAction(name: 'FilterStoreBase.clearCategory');
    try {
      return super.clearCategory(categories: categories);
    } finally {
      _$FilterStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
itemExpand: ${itemExpand},
loadingAttributes: ${loadingAttributes},
onSale: ${onSale},
inStock: ${inStock},
featured: ${featured},
categories: ${categories},
rangePrices: ${rangePrices},
productPrices: ${productPrices},
attributes: ${attributes},
brand: ${brand},
values: ${values},
attributeSelected: ${attributeSelected}
    ''';
  }
}
