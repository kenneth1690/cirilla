import 'dart:convert';
import 'package:cirilla/models/models.dart';
import 'package:cirilla/service/helpers/request_helper.dart';
import 'package:cirilla/models/product/attributes.dart';
import 'package:cirilla/models/product/product_prices.dart';
import 'package:cirilla/store/product/products_store.dart';
import 'package:cirilla/utils/query.dart';
import 'package:flutter/material.dart';
import 'package:mobx/mobx.dart';

part 'filter_store.g.dart';

class FilterStore = FilterStoreBase with _$FilterStore;

abstract class FilterStoreBase with Store {
  late RequestHelper _requestHelper;
  ProductsStore? _productsStore;

  // Constructor:-------------------------------------------------------------------------------------------------------
  FilterStoreBase(
    RequestHelper requestHelper, {
    bool? onSale,
    bool? featured,
    bool? inStock,
    List<ProductCategory>? categories,
    Brand? brand,
    ProductPrices? productPrices,
    RangeValues? rangePrices,
    List<Attribute>? attributes,
    List<ItemAttributeSelected>? attributeSelected,
    ProductsStore? productsStore,
    String? language,
  }) {
    _requestHelper = requestHelper;
    _productsStore = productsStore;

    if (onSale != null) _onSale = onSale;
    if (featured != null) _featured = featured;
    if (inStock != null) _inStock = inStock;
    if (categories != null) _categories = ObservableList.of(categories);
    if (brand != null) _brand = brand;
    if (attributes != null) _attributes = ObservableList.of(attributes);
    if (attributeSelected != null) _attributeSelected = ObservableList.of(attributeSelected);
    if (rangePrices != null) _rangePrices = rangePrices;
    if (productPrices != null) _productPrices = productPrices;
    if (language != null) _language = language;

    _reaction();
  }

  // Store variables:---------------------------------------------------------------------------------------------------

  @observable
  ObservableList<Attribute> _attributes = ObservableList<Attribute>.of([]);

  @observable
  ProductPrices _productPrices = ProductPrices(minPrice: 0.0, maxPrice: 0.0);

  @observable
  RangeValues _rangePrices = const RangeValues(0.0, 0.0);

  @observable
  bool _featured = false;

  @observable
  bool _onSale = false;

  @observable
  bool _inStock = false;

  @observable
  bool _loadingAttributes = false;

  @observable
  ObservableList<ProductCategory> _categories = ObservableList<ProductCategory>.of([]);

  @observable
  ObservableList<ItemAttributeSelected> _attributeSelected = ObservableList<ItemAttributeSelected>.of([]);

  @observable
  Brand? _brand;

  @observable
  ObservableMap<String?, bool> itemExpand = ObservableMap<String?, bool>.of({});

  @observable
  String _language = '';

  // Computed variables:------------------------------------------------------------------------------------------------
  @computed
  bool get loadingAttributes => _loadingAttributes;

  @computed
  bool get onSale => _onSale;

  @computed
  bool get inStock => _inStock;

  @computed
  bool get featured => _featured;

  @computed
  ObservableList<ProductCategory> get categories => _categories;

  @computed
  RangeValues get rangePrices => _rangePrices;

  @computed
  ProductPrices get productPrices => _productPrices;

  @computed
  ObservableList<Attribute> get attributes => _attributes;

  @computed
  Brand? get brand => _brand;

  @computed
  String get values =>
      "$_inStock $_onSale $_featured ${_categories.map((e) => e.toString())} ${_attributeSelected.map((e) => e.toString())} ${_brand != null ? _brand!.id : 0} ${_rangePrices.toString()}";

  @computed
  ObservableList<ItemAttributeSelected> get attributeSelected => _attributeSelected;

  // Actions:-----------------------------------------------------------------------------------------------------------
  @action
  void expand(String? key) {
    if (itemExpand.containsKey(key)) {
      itemExpand.remove(key);
    } else {
      itemExpand.putIfAbsent(key, () => true);
    }
  }

  @action
  void selectAttribute(ItemAttributeSelected value) {
    int i = _attributeSelected.indexWhere((att) => att.taxonomy == value.taxonomy && att.terms == value.terms);
    if (i >= 0) {
      _attributeSelected.removeWhere((att) => att.taxonomy == value.taxonomy && att.terms == value.terms);
    } else {
      _attributeSelected.add(value);
    }
  }

  @action
  Future getAttributes() async {
    // Future getAttributes({Map<String, dynamic>? queryParameters, bool updateStore = true}) async {
    _loadingAttributes = true;
    try {
      List<Map> attrs = [];
      if (_categories.isNotEmpty) {
        attrs.add({
          'taxonomy': 'product_cat',
          'field': 'cat_id',
          'terms': _categories.map((c) => c.id).toList(),
        });
      }

      if (_brand?.id != null) {
        attrs.add({
          'taxonomy': 'product_brand',
          'field': 'brand_id',
          'terms': [_brand!.id!],
        });
      }

      if (_attributeSelected.isNotEmpty) {
        for (var a in _attributeSelected) {
          attrs.add(a.query);
        }
      }

      Map<String, dynamic> qs = {
        'attrs': jsonEncode(attrs),
        'lang': _language,
      };

      Attributes attributes = await _requestHelper.getAttributes(queryParameters: preQueryParameters(qs));
      _attributes = ObservableList<Attribute>.of(attributes.attributes!);
      // Remove _attributeSelected not exist in new attributes
      _loadingAttributes = false;
    } catch (e) {
      _loadingAttributes = false;
      rethrow;
    }
  }

  @action
  void setMinMaxPrice(double minPrice, double maxPrice) {
    _rangePrices = RangeValues(minPrice, maxPrice);
  }

  @action
  Future<void> getMinMaxPrices() async {
    try {
      ProductPrices prices = await _requestHelper.getMinMaxPrices(
        queryParameters: {'category': _categories.map((c) => c.id).join(",")},
      );
      _productPrices = prices;
      _rangePrices = RangeValues(prices.minPrice!, prices.maxPrice!);
    } catch (e) {
      rethrow;
    }
  }

  @action
  void onChange({
    Map? sort,
    bool? onSale,
    bool? featured,
    bool? inStock,
    List<ProductCategory>? categories,
    Brand? brand,
    ProductPrices? productPrices,
    RangeValues? rangePrices,
    List<Attribute>? attributes,
    List<ItemAttributeSelected>? attributeSelected,
    bool refresh = false,
  }) {
    if (onSale != null) _onSale = onSale;
    if (featured != null) _featured = featured;
    if (inStock != null) _inStock = inStock;
    if (categories != null) _categories = ObservableList.of(categories);
    if (attributes != null) _attributes = ObservableList.of(attributes);
    if (attributeSelected != null) _attributeSelected = ObservableList.of(attributeSelected);
    if (brand != null) _brand = brand;
    if (rangePrices != null) {
      _rangePrices = RangeValues(
        rangePrices.start,
        rangePrices.end,
      );
    }
    if (productPrices != null) {
      _productPrices = ProductPrices(
        minPrice: productPrices.minPrice,
        maxPrice: productPrices.maxPrice,
      );
    }
    if (_productsStore != null) _productsStore!.refresh();
  }

  @action
  void clearAll({List<ProductCategory>? categories, Brand? brand}) {
    _categories = ObservableList.of(categories ?? []);
    _brand = brand;
    _onSale = false;
    _featured = false;
    _inStock = false;
    _attributeSelected = ObservableList.of([]);
    _rangePrices = const RangeValues(0.0, 0.0);
    _productPrices = ProductPrices(minPrice: 0, maxPrice: 0);

    if (_productsStore != null) _productsStore!.refresh();
  }

  @action
  void clearBrand({Brand? brand}) {
    _brand = brand;

    if (_productsStore != null) _productsStore!.refresh();
  }

  @action
  void clearCategory({List<ProductCategory>? categories}) {
    _categories = ObservableList.of(categories ?? []);

    if (_productsStore != null) _productsStore!.refresh();
  }

  // disposers: --------------------------------------------------------------------------------------------------------
  late List<ReactionDisposer> _disposers;

  void _reaction() {
    _disposers = [
      reaction((_) => _brand?.id, (dynamic brandId) {
        getAttributes();
      }),
      reaction((_) => _categories.toString(), (dynamic categories) {
        getAttributes();
      }),
      reaction((_) => _attributeSelected.toString(), (dynamic attrs) {
        getAttributes();
      }),
    ];
  }

  void dispose() {
    for (final d in _disposers) {
      d();
    }
  }
}
