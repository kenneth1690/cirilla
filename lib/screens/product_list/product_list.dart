import 'package:cirilla/constants/strings.dart';
import 'package:cirilla/mixins/mixins.dart';
import 'package:cirilla/models/models.dart';
import 'package:cirilla/store/product/filter_store.dart';
import 'package:cirilla/store/store.dart';
import 'package:cirilla/utils/convert_data.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/provider.dart';

import 'data.dart';
import 'widgets/body.dart';
import 'widgets/refine.dart';
import 'widgets/heading_list.dart';
import 'widgets/filter_list.dart';
import 'widgets/sort.dart';

class ProductListScreen extends StatefulWidget {
  static const routeName = '/product_list';

  const ProductListScreen({Key? key, this.args, this.store}) : super(key: key);

  @override
  State<ProductListScreen> createState() => _ProductListScreenState();

  final Map? args;
  final SettingStore? store;
}

class _ProductListScreenState extends State<ProductListScreen>
    with ShapeMixin, Utility, HeaderListMixin, ProductListMixin {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  ProductsStore? _productsStore;
  FilterStore? _filterStore;
  BrandStore? _brandStore;
  late int typeView;

  late List<ProductCategory>? _categories;
  late Brand? _brand;

  @override
  void initState() {
    super.initState();
    AuthStore authStore = Provider.of<AuthStore>(context, listen: false);

    // Configs
    Data data = widget.store!.data!.screens!['products']!;
    WidgetConfig widgetConfig = data.widgets!['productListPage']!;
    List<ProductCategory>? categories = getCategories(widget.args);
    Brand? brand = getBrand(widget.args);
    List<int>? tag = getTag(widget.args);
    String? orderby = widget.args?['orderby'];

    _productsStore = ProductsStore(
      widget.store!.requestHelper,
      categories: categories,
      brand: brand,
      tag: tag,
      perPage: ConvertData.stringToInt(get(widgetConfig.fields, ['itemPerPage'], 10)),
      currency: widget.store!.currency,
      language: widget.store!.locale,
      sort: getSort(orderby),
      locationStore: authStore.locationStore,
    );
    _filterStore = FilterStore(
      widget.store!.requestHelper,
      categories: _productsStore!.filter!.categories,
      brand: _productsStore!.filter!.brand,
      language: widget.store!.locale,
    );
    _categories = categories;
    _brand = brand;

    bool enableFilterBrand = get(widgetConfig.fields, ['enableFilterBrand'], false);
    if (enableFilterBrand && brand == null) {
      _brandStore = BrandStore(widget.store!.requestHelper, perPage: 100)..getBrands();
    }

    List layouts = get(widgetConfig.fields, ["layout"], initLayouts);
    int visitActive = layouts.indexWhere((e) => get(e, ["active"], false) == true);
    typeView = visitActive > -1 ? visitActive : 0;

    init();
  }

  @override
  void didUpdateWidget(covariant ProductListScreen oldWidget) {
    // Configs
    Data data = widget.store!.data!.screens!['products']!;
    WidgetConfig widgetConfig = data.widgets!['productListPage']!;
    List layouts = get(widgetConfig.fields, ["layout"], initLayouts);

    // Configs old
    Data dataOld = oldWidget.store!.data!.screens!['products']!;
    WidgetConfig widgetConfigOld = dataOld.widgets!['productListPage']!;
    List layoutsOld = get(widgetConfigOld.fields, ["layout"], initLayouts);

    if (!listEquals(layouts, layoutsOld)) {
      int visitActive = layouts.indexWhere((e) => get(e, ["active"], false) == true);
      setState(() {
        typeView = visitActive > -1 ? visitActive : 0;
      });
    }
    super.didUpdateWidget(oldWidget);
  }

  Map getSort(String? orderBy) {
    switch (orderBy) {
      case 'popularity':
        return listSortBy[2];
      case 'rating':
        return listSortBy[3];
      case 'date':
        return listSortBy[4];
      case 'price':
        return listSortBy[5];
      case 'price-desc':
        return listSortBy[6];
      default:
        return listSortBy[1];
    }
  }

  Future<void> init() async {
    bool loading = true;
    await _productsStore!.getProducts();
    await _productsStore?.filter?.getAttributes();
    await _productsStore?.filter?.getMinMaxPrices();
    loading = false;
    if (!loading) {
      _filterStore?.onChange(
        inStock: _productsStore!.filter!.inStock,
        onSale: _productsStore!.filter!.onSale,
        featured: _productsStore!.filter!.featured,
        attributeSelected: _productsStore!.filter!.attributeSelected,
        productPrices: _productsStore!.filter!.productPrices,
        rangePrices: _productsStore!.filter!.rangePrices,
      );
    }
  }

  // Fetch product data
  Future<List<Product>> _getProducts() async {
    return _productsStore!.getProducts();
  }

  Future _refresh() {
    return _productsStore!.refresh();
  }

  void _clearAll() {
    _filterStore!.onChange(
      inStock: _productsStore!.filter!.inStock,
      onSale: _productsStore!.filter!.onSale,
      featured: _productsStore!.filter!.featured,
      categories: _productsStore!.filter!.categories,
      brand: _productsStore!.filter!.brand,
      attributeSelected: _productsStore!.filter!.attributeSelected,
      productPrices: _productsStore!.filter!.productPrices,
      rangePrices: _productsStore!.filter!.rangePrices,
    );
    if (_productsStore!.filter!.brand == null) {
      _filterStore?.clearBrand(brand: null);
    }
  }

  void onSubmit(FilterStore? filter) {
    if (filter != null) {
      _productsStore!.onChanged(filterStore: filter);
    } else {
      _clearAll();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Observer(
      builder: (_) {
        // Configs
        Data data = widget.store!.data!.screens!['products']!;
        WidgetConfig widgetConfig = data.widgets!['productListPage']!;

        String? refinePosition = get(widgetConfig.fields, ['refinePosition'], Strings.refinePositionBottom);
        String? refineItemStyle = get(widgetConfig.fields, ['refineItemStyle'], Strings.refineItemStyleListTitle);
        bool enableFilterBrand = get(widgetConfig.fields, ['enableFilterBrand'], false);
        int itemPerPage = ConvertData.stringToInt(get(widgetConfig.fields, ['itemPerPage'], 10));

        List layouts = get(widgetConfig.fields, ["layout"], initLayouts);
        Map? layout = get(layouts[typeView], ["data"]);

        List<Product> loadingProduct = List.generate(itemPerPage, (index) => Product()).toList();

        ProductCategory? category = _categories?.isNotEmpty == true ? _categories?.elementAt(0) : null;

        bool showFilterBrand = enableFilterBrand && _brand == null;

        bool isShimmer = _productsStore!.products.isEmpty && _productsStore!.loading;

        int? countBrand = _brand?.count;
        int countCategory = category?.count ?? -1;
        int countItems = countBrand ?? countCategory;

        String? name = widget.args?['name'] ?? _brand?.name ?? category?.name;

        return Scaffold(
          key: _scaffoldKey,
          drawer: Drawer(
            child: buildRefine(
              context,
              category: category,
              min: 1,
              refinePosition: refinePosition,
              refineItemStyle: refineItemStyle,
              showFilterBrand: showFilterBrand,
            ),
          ),
          endDrawer: Drawer(
            child: buildRefine(
              context,
              category: category,
              min: 1,
              refinePosition: refinePosition,
              refineItemStyle: refineItemStyle,
              showFilterBrand: showFilterBrand,
            ),
          ),
          body: SafeArea(
            child: Body(
              title: name,
              count: countItems,
              products: isShimmer ? loadingProduct : _productsStore!.products.where(productCatalog).toList(),
              loading: _productsStore!.loading,
              refresh: _refresh,
              getProducts: _getProducts,
              canLoadMore: _productsStore!.canLoadMore,
              heading: HeadingList(
                height: 58,
                sort: _productsStore!.sort,
                onchangeSort: (Map sort) => _productsStore!.onChanged(sort: sort),
                clickRefine: () async {
                  if (refinePosition == Strings.refinePositionLeft) {
                    _scaffoldKey.currentState!.openDrawer();
                  } else if (refinePosition == Strings.refinePositionRight) {
                    _scaffoldKey.currentState!.openEndDrawer();
                  } else {
                    showModalBottomSheet<FilterStore>(
                      isScrollControlled: true,
                      context: context,
                      shape: borderRadiusTop(),
                      builder: (context) => buildRefine(
                        context,
                        category: category,
                        refinePosition: refinePosition,
                        refineItemStyle: refineItemStyle,
                        showFilterBrand: showFilterBrand,
                        max: 0.86,
                      ),
                    );
                  }
                },
                layouts: layouts,
                typeView: typeView,
                onChangeType: (int visit) => setState(() {
                  typeView = visit;
                }),
              ),
              filter: FilterList(
                productsStore: _productsStore,
                filter: _filterStore,
                category: category,
                brand: _brand,
              ),
              heightHeading: 58,
              configs: data.configs,
              styles: widgetConfig.styles,
              layout: layout,
            ),
          ),
        );
      },
    );
  }

  Widget buildRefine(
    BuildContext context, {
    ProductCategory? category,
    double min = 0.8,
    double max = 1,
    String? refinePosition = Strings.refinePositionBottom,
    String? refineItemStyle = Strings.refineItemStyleListTitle,
    bool showFilterBrand = false,
  }) {
    return Refine(
      filterStore: _filterStore,
      brandStore: _brandStore,
      category: category,
      clearAll: _clearAll,
      onSubmit: onSubmit,
      min: min,
      max: max,
      refineItemStyle: refineItemStyle,
      refinePosition: refinePosition,
      showFilterBrand: showFilterBrand,
    );
  }
}
