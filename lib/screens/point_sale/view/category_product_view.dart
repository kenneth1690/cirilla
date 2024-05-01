import 'package:cirilla/constants/constants.dart';
import 'package:cirilla/constants/strings.dart';
import 'package:cirilla/mixins/mixins.dart';
import 'package:cirilla/models/models.dart';
import 'package:cirilla/store/store.dart';
import 'package:cirilla/types/types.dart';
import 'package:cirilla/utils/utils.dart';
import 'package:cirilla/widgets/cirilla_product_item.dart';
import 'package:collection/collection.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/provider.dart';

import '../widgets/category_item.dart';
import '../widgets/heading_content.dart';
import '../widgets/icon_menu.dart';
import '../widgets/layout_content.dart';

class CategoryProductView extends StatefulWidget {
  const CategoryProductView({super.key});

  @override
  State<CategoryProductView> createState() => _CategoryProductViewState();
}

class _CategoryProductViewState extends State<CategoryProductView> with CategoryMixin, LoadingMixin {
  late SettingStore _settingStore;
  late ProductCategoryStore _categoryStore;
  late ProductsStore _productStore;

  String _layout = "rect";

  final ScrollController _controller = ScrollController();

  @override
  void initState() {
    super.initState();
    _controller.addListener(_onScroll);
  }

  @override
  void didChangeDependencies() {
    Map<String, dynamic> sortInit = {
      'key': 'product_list_default',
      'query': {
        'orderby': 'title',
        'order': 'asc',
      }
    };
    _settingStore = Provider.of<SettingStore>(context);
    _categoryStore = Provider.of<ProductCategoryStore>(context);
    _productStore = ProductsStore(
      _settingStore.requestHelper,
      perPage: 12,
      sort: sortInit,
    );
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (!_controller.hasClients || _productStore.loading || !_productStore.canLoadMore) return;
    final thresholdReached = _controller.position.extentAfter < endReachedThreshold;

    if (thresholdReached) {
      _productStore.getProducts();
    }
  }

  void onSelectedCategory(ProductCategory category) {
    ProductCategory? filterCategory = _productStore.filter?.categories.firstOrNull;
    if (category.id != filterCategory?.id) {
      _productStore.filter?.onChange(categories: [category]);
    }
  }

  List<ProductCategory> categoriesBreadcrumb(
      {List<ProductCategory> tree = const [], int? selectedCategory, required List<ProductCategory> categories}) {
    if (selectedCategory == null) {
      return tree;
    }
    ProductCategory? treeCategory = categories
        .firstWhereOrNull((cat) => flatten(categories: [cat]).any((element) => element?.id == selectedCategory));
    if (treeCategory == null) {
      return tree;
    }
    tree.add(treeCategory);

    return categoriesBreadcrumb(
        tree: tree,
        selectedCategory: selectedCategory,
        categories: (treeCategory.categories ?? []).cast<ProductCategory>());
  }

  Widget buildItemBreadcrumb(ProductCategory category, bool visitEnd) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Padding(padding: EdgeInsets.symmetric(horizontal: 4), child: Icon(Icons.arrow_forward_ios, size: 14)),
        if (visitEnd)
          Padding(
            padding: const EdgeInsetsDirectional.only(start: 6),
            child: Text(category.name ?? ""),
          )
        else
          TextButton(onPressed: () => onSelectedCategory(category), child: Text(category.name ?? "")),
      ],
    );
  }

  Widget buildBreadcrumbs(List<ProductCategory> categories) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          InkWell(
            onTap: () => _productStore.filter?.clearCategory(),
            child: const Icon(Icons.list, size: 20),
          ),
          const SizedBox(width: 4),
          ...List.generate(categories.length, (index) {
            return buildItemBreadcrumb(categories[index], index >= categories.length - 1);
          }),
        ],
      ),
    );
  }

  void onChangeMenu(String key, List<String> selected) {
    switch (key) {
      case "layout":
        if (selected.isNotEmpty) {
          setState(() {
            _layout = selected[0];
          });
        }
        break;
      case "orderby":
        if (selected.isNotEmpty) {
          Map<String, dynamic> sort = {
            'key': 'product_list_default',
            'query': {
              'order': _productStore.sort["query"]["order"] ?? "asc",
              'orderby': selected[0],
            }
          };
          _productStore.onChanged(sort: sort);
        }
        break;
      case "order":
        if (selected.isNotEmpty) {
          Map<String, dynamic> sort = {
            'key': 'product_list_default',
            'query': {
              'order': selected[0],
              'orderby': _productStore.sort["query"]["orderby"] ?? "title",
            }
          };
          _productStore.onChanged(sort: sort);
        }
        break;
      default:
    }
  }

  @override
  Widget build(BuildContext context) {
    TranslateType translate = AppLocalizations.of(context)!.translate;

    List<MenuOptionContent> layoutOptions = [
      MenuOptionContent(key: "grid", title: translate("point_sale_layout_grid"), icon: Icons.grid_view),
      MenuOptionContent(key: "rect", title: translate("point_sale_layout_rect"), icon: Icons.view_stream),
      MenuOptionContent(key: "list", title: translate("point_sale_layout_list"), icon: Icons.table_rows),
    ];

    List<MenuOptionContent> sortOptions = [
      MenuOptionContent(key: "id", title: translate("point_sale_sort_id")),
      MenuOptionContent(key: "title", title: translate("point_sale_sort_title")),
      MenuOptionContent(key: "price", title: translate("point_sale_sort_price")),
      MenuOptionContent(key: "date", title: translate("point_sale_sort_date")),
      MenuOptionContent(key: "popularity", title: translate("point_sale_sort_popularity")),
    ];

    return LayoutBuilder(
      builder: (_, BoxConstraints constraints) {
        double widthView = constraints.maxWidth;

        return Observer(
          builder: (_) {
            ProductCategory? filterCategory = _productStore.filter?.categories.firstOrNull;

            List<ProductCategory> categories = filterCategory?.id != null
                ? (filterCategory?.categories ?? []).cast<ProductCategory>()
                : _categoryStore.categories;

            List<Product> emptyProducts = List.generate(12, (index) => Product()).toList();
            List<Product> data =
                _productStore.loading && _productStore.products.isEmpty ? emptyProducts : _productStore.products;
            Map sort = _productStore.sort;

            String orderBy = sort["query"]["orderby"] ?? "title";
            String order = sort["query"]["order"] ?? "asc";

            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                HeadingContent(
                  title: filterCategory != null
                      ? buildBreadcrumbs(
                          categoriesBreadcrumb(
                            tree: [],
                            selectedCategory: filterCategory.id,
                            categories: _categoryStore.categories,
                          ),
                        )
                      : Row(
                          children: [
                            const Icon(Icons.category, size: 20),
                            const SizedBox(width: 8),
                            Text(translate("categories"))
                          ],
                        ),
                  trailing: IconMenuContent(
                    items: [
                      MenuItemContent(
                        key: "layout",
                        title: translate("point_sale_layout"),
                        type: MenuItemType.single,
                        options: layoutOptions,
                        selectedKeys: [_layout],
                      ),
                      MenuItemContent(
                        key: "orderby",
                        title: translate("sort_by"),
                        subtitle: IconButton(
                          onPressed: () => onChangeMenu("order", [order == "desc" ? "asc" : "desc"]),
                          icon: Icon(order == "desc" ? Icons.arrow_downward : Icons.arrow_upward, size: 14),
                          splashRadius: 15,
                          tooltip:
                              order == "desc" ? translate("point_sale_descending") : translate("point_sale_ascending"),
                          constraints: const BoxConstraints(maxWidth: 30, maxHeight: 30),
                        ),
                        type: MenuItemType.single,
                        options: sortOptions,
                        selectedKeys: [orderBy],
                      ),
                    ],
                    onChange: onChangeMenu,
                  ),
                  padding: const EdgeInsetsDirectional.only(start: 20, end: 8),
                ),
                const Divider(height: 1, thickness: 1),
                Expanded(
                  child: CustomScrollView(
                    controller: _controller,
                    slivers: [
                      if (categories.isNotEmpty)
                        SliverToBoxAdapter(
                          child: _ListCategory(
                            categories: categories,
                            loading: _categoryStore.loading,
                            layout: _layout,
                            onClickCategory: onSelectedCategory,
                            widthView: widthView,
                          ),
                        ),
                      if (filterCategory?.id != null) ...[
                        CupertinoSliverRefreshControl(
                          onRefresh: _productStore.refresh,
                          builder: buildAppRefreshIndicator,
                        ),
                        SliverToBoxAdapter(
                          child: _ListProduct(
                            products: data,
                            layout: _layout,
                            onClickProduct: (_) => {},
                            widthView: widthView,
                          ),
                        ),
                        if (_productStore.loading)
                          SliverToBoxAdapter(
                            child: buildLoading(context, isLoading: _productStore.canLoadMore),
                          ),
                      ]
                    ],
                  ),
                )
              ],
            );
          },
        );
      },
    );
  }
}

class _ListCategory extends StatelessWidget {
  final bool loading;
  final List<ProductCategory> categories;
  final String layout;
  final void Function(ProductCategory) onClickCategory;
  final double widthView;

  const _ListCategory({
    required this.categories,
    required this.onClickCategory,
    this.loading = true,
    this.layout = "rect",
    this.widthView = 300,
  });

  int getColumn(double width) {
    if (width > 840) {
      return 3;
    }
    if (width > 600) {
      return 2;
    }
    return 1;
  }

  Widget buildList(double width) {
    if (layout == "list") {
      return LayoutContent(
        length: categories.length,
        onRenderItem: (index, _) {
          ProductCategory cat = categories[index];
          return Column(
            children: [
              CategoryItem(
                category: cat,
                type: "tile",
                onClick: () => onClickCategory(cat),
              ),
              if (index < categories.length - 1) const Divider(height: 1, thickness: 1)
            ],
          );
        },
        col: 1,
        widthView: width,
      );
    }

    int col = getColumn(width);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: LayoutContent(
        length: categories.length,
        col: col,
        onRenderItem: (index, _) {
          ProductCategory cat = categories[index];
          return CategoryItem(
            category: cat,
            onClick: () => onClickCategory(cat),
          );
        },
        spacing: 16,
        runSpacing: 16,
        widthView: width,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    EdgeInsetsGeometry padding =
        layout == "list" ? EdgeInsets.zero : const EdgeInsets.symmetric(horizontal: 20, vertical: 12);

    double width = widthView - padding.horizontal;

    return Container(
      padding: padding,
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        border: Border(bottom: BorderSide(color: theme.dividerColor)),
      ),
      child: buildList(width),
    );
  }
}

class _ListProduct extends StatelessWidget {
  final List<Product> products;
  final String layout;
  final void Function(Product) onClickProduct;
  final double widthView;

  const _ListProduct({
    required this.products,
    required this.onClickProduct,
    this.layout = "rect",
    this.widthView = 300,
  });

  int getColumnGrid(double width) {
    if (width > 1400) {
      return 6;
    }

    if (width > 1100) {
      return 6;
    }

    if (width > 840) {
      return 4;
    }

    if (width > 600) {
      return 2;
    }
    return 1;
  }

  int getColumnRect(double width) {
    if (width > 1400) {
      return 4;
    }

    if (width > 840) {
      return 2;
    }
    return 1;
  }

  Widget buildList(ThemeData theme, double width) {
    if (layout == "list") {
      return LayoutContent(
        col: 1,
        length: products.length,
        onRenderItem: (index, _) => Column(
          children: [
            buildItem(products[index], width, theme),
            const Divider(height: 1, thickness: 1),
          ],
        ),
        widthView: width,
      );
    }

    if (layout == "grid") {
      int col = getColumnGrid(width);
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: LayoutContent(
          length: products.length,
          col: col,
          onRenderItem: (index, width) => buildItem(products[index], width, theme),
          spacing: 24,
          runSpacing: 24,
          widthView: width,
        ),
      );
    }

    int col = getColumnRect(width);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: LayoutContent(
        length: products.length,
        col: col,
        onRenderItem: (index, width) => buildItem(products[index], width, theme),
        spacing: 24,
        runSpacing: 24,
        widthView: width,
      ),
    );
  }

  Widget buildItem(Product p, double width, ThemeData theme) {
    switch (layout) {
      case "list":
        double widthItem = width;
        double heightItem = (widthItem * 160) / 190;
        return CirillaProductItem(
          product: p,
          width: widthItem,
          height: heightItem,
          template: Strings.productItemHorizontal,
          dataTemplate: const {
            "enableRating": false,
          },
          radius: 0,
          padding: const EdgeInsets.all(20),
          background: Colors.transparent,
        );
      case "grid":
        double widthItem = width;
        double heightItem = (widthItem * 190) / 160;

        return CirillaProductItem(
          product: p,
          template: Strings.productItemCurve,
          width: widthItem,
          height: heightItem,
          dataTemplate: const {
            "enableRating": false,
          },
        );
      default:
        return CirillaProductItem(
          product: p,
          width: widthView,
          height: (widthView * 190) / 160,
          template: Strings.productItemHorizontal,
          dataTemplate: const {
            "enableRating": false,
          },
          background: Colors.transparent,
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    EdgeInsetsGeometry padding =
        layout == "list" ? EdgeInsets.zero : const EdgeInsets.symmetric(horizontal: 20, vertical: 12);

    return Container(
      padding: padding,
      child: buildList(theme, widthView - padding.horizontal),
    );
  }
}
