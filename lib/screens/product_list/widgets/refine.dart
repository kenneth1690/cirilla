import 'package:cirilla/constants/constants.dart';
import 'package:cirilla/constants/strings.dart';
import 'package:cirilla/mixins/mixins.dart';
import 'package:cirilla/models/models.dart';
import 'package:cirilla/models/product/attributes.dart';
import 'package:cirilla/store/product/filter_store.dart';
import 'package:cirilla/store/store.dart';
import 'package:cirilla/types/types.dart';
import 'package:cirilla/utils/utils.dart';
import 'package:cirilla/widgets/widgets.dart';
import 'package:ui/ui.dart';
import 'package:feather_icons/feather_icons.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/provider.dart';

class Refine extends StatefulWidget {
  final ProductCategory? category;
  final List<int>? includeCategory;

  // Product list store
  final FilterStore? filterStore;

  final BrandStore? brandStore;

  final Function? clearAll;

  final Function? onSubmit;

  final double min;

  final double max;

  final String? refineItemStyle;
  final String? refinePosition;
  final bool showFilterBrand;

  const Refine({
    Key? key,
    this.category,
    this.includeCategory,
    this.filterStore,
    this.brandStore,
    this.clearAll,
    this.onSubmit,
    this.min = 0.8,
    this.max = 1,
    this.refineItemStyle,
    this.refinePosition,
    this.showFilterBrand = false,
  }) : super(key: key);

  @override
  State<Refine> createState() => _RefineState();
}

class _RefineState extends State<Refine> with CategoryMixin, LoadingMixin {
  List<ProductCategory?> _categories = List<ProductCategory>.of([]);
  bool _categoryExpand = true;
  bool _brandExpand = true;

  @override
  void didChangeDependencies() {
    ProductCategoryStore productCategoryStore = Provider.of<ProductCategoryStore>(context);

    setState(() {
      _categories = include(
            categories: parent(
              categories: productCategoryStore.categories,
              parentId: widget.category != null ? widget.category!.id : 0,
            ),
            includes: widget.includeCategory ?? [],
          ) ??
          [];
    });
    // widget.clearAll();
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    widget.clearAll!();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    TranslateType translate = AppLocalizations.of(context)!.translate;
    ThemeData theme = Theme.of(context);

    return DraggableScrollableSheet(
      expand: false,
      initialChildSize: widget.min,
      minChildSize: widget.min,
      maxChildSize: widget.max,
      builder: (_, controller) {
        return Observer(builder: (_) {
          return Stack(
            children: [
              ListView(
                padding: paddingHorizontal,
                controller: controller,
                children: [
                  _buildHeader(translate, theme),
                  _buildInStock(translate, theme),
                  _buildOnSale(translate, theme),
                  _buildFeatured(translate, theme),
                  if (_categories.isNotEmpty) _buildCategories(translate),
                  if (widget.showFilterBrand && (widget.brandStore?.brands ?? []).isNotEmpty)
                    _buildBrands(widget.brandStore!, translate),
                  if (widget.filterStore!.attributes.isNotEmpty) _buildAttributes(),
                  if (widget.filterStore!.productPrices.minPrice != widget.filterStore!.productPrices.maxPrice)
                    _buildRangesPrice(translate),
                  _buildApplyButton(context, translate),
                ],
              ),
              if (widget.filterStore!.loadingAttributes) Center(child: buildLoadingOverlay(context)),
            ],
          );
        });
      },
    );
  }

  Widget _buildHeader(TranslateType translate, ThemeData theme) {
    bool isCenter = widget.refinePosition == Strings.refinePositionBottom;
    bool isSafeArea = widget.refinePosition != Strings.refinePositionBottom;

    double paddingTop = isSafeArea ? MediaQuery.of(context).padding.top : 24;

    Widget title = isCenter
        ? Center(
            child: Text(
              translate('product_list_filters'),
              style: theme.textTheme.titleMedium,
              textAlign: TextAlign.center,
            ),
          )
        : Text(
            translate('product_list_filters'),
            style: theme.textTheme.titleMedium,
            textAlign: TextAlign.center,
          );
    return Padding(
      padding: EdgeInsets.only(top: paddingTop > 0 ? paddingTop : itemPaddingLarge, bottom: itemPaddingMedium),
      child: Stack(
        children: [
          title,
          Positioned(
            right: 0,
            top: 0,
            bottom: 0,
            child: SizedBox(
              height: double.infinity,
              child: TextButton(
                onPressed: () => widget.clearAll!(),
                style: TextButton.styleFrom(
                  foregroundColor: theme.textTheme.bodySmall?.color,
                  textStyle: theme.textTheme.bodySmall,
                  padding: EdgeInsets.zero,
                  minimumSize: Size.zero,
                ),
                child: Text(translate('product_list_clear_all')),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildInStock(TranslateType translate, ThemeData theme) {
    return CirillaTile(
      title: CirillaText(translate('product_list_in_stock')),
      trailing: CupertinoSwitch(
        activeColor: theme.primaryColor,
        value: widget.filterStore!.inStock,
        onChanged: (value) => widget.filterStore!.onChange(inStock: value),
      ),
      isChevron: false,
    );
  }

  Widget _buildOnSale(TranslateType translate, ThemeData theme) {
    return CirillaTile(
      title: CirillaText(translate('product_list_on_sale')),
      trailing: CupertinoSwitch(
        activeColor: theme.primaryColor,
        value: widget.filterStore!.onSale,
        onChanged: (value) => widget.filterStore!.onChange(onSale: value),
      ),
      isChevron: false,
    );
  }

  Widget _buildFeatured(TranslateType translate, ThemeData theme) {
    return CirillaTile(
      title: CirillaText(translate('product_list_featured')),
      trailing: CupertinoSwitch(
        activeColor: theme.primaryColor,
        value: widget.filterStore!.featured,
        onChanged: (value) => widget.filterStore!.onChange(featured: value),
      ),
      isChevron: false,
    );
  }

  Widget _buildCategories(TranslateType translate) {
    List<ProductCategory?> data =
        widget.refineItemStyle == Strings.refineItemStyleCard ? flatten(categories: _categories) : _categories;

    List<ProductCategory?> categories = widget.category != null ? [...data, ProductCategory(
      id: widget.category?.id,
      categories: [],
      name: translate('product_list_view_all'),
      count: -1,
    )]: data;

    return _Tile(
      title: translate('product_list_categories'),
      activeList: _categoryExpand,
      onChangeActiveList: () => setState(() {
        _categoryExpand = !_categoryExpand;
      }),
      count: categories.length,
      buildItem: (index) {
        return _Category(
          category: data[index],
          filterStore: widget.filterStore,
          refineItemStyle: widget.refineItemStyle,
        );
      },
      refineItemStyle: widget.refineItemStyle,
    );
  }

  Widget _buildBrands(BrandStore brandStore, TranslateType translate) {
    List<Brand> brands = brandStore.brands;
    bool canLoadMore = brandStore.canLoadMore;

    return _Tile(
      title: translate("product_brands"),
      activeList: _brandExpand,
      onChangeActiveList: () => setState(() {
        _brandExpand = !_brandExpand;
      }),
      count: canLoadMore ? brands.length + 1 : brands.length,
      buildItem: (index) {
        if (index < brands.length) {
          return _Brand(
            brand: brands[index],
            filterStore: widget.filterStore,
            refineItemStyle: widget.refineItemStyle,
          );
        }

        return CirillaTile(
          title: Center(
            child: SizedBox(
              width: 140,
              height: 34,
              child: ElevatedButton(
                onPressed: () => brandStore.loading ? {} : brandStore.getBrands(),
                child: brandStore.loading
                    ? entryLoading(context, size: 14, color: Colors.white)
                    : Text(translate("load_more")),
              ),
            ),
          ),
          isChevron: false,
        );
      },
      refineItemStyle: widget.refineItemStyle,
    );
  }

  Widget _buildAttributes() {
    return Observer(
      builder: (_) => Column(
        children: List.generate(
          widget.filterStore!.attributes.length,
          (i) => widget.filterStore!.attributes[i].terms!.options!.isNotEmpty
              ? _Attribute(
                  filterStore: widget.filterStore,
                  attribute: widget.filterStore!.attributes[i],
                  refineItemStyle: widget.refineItemStyle,
                )
              : const SizedBox(),
        ),
      ),
    );
  }

  Widget _buildRangesPrice(TranslateType translate) {
    bool expand = widget.filterStore!.itemExpand['ranges_price'] != null;

    return Column(children: [
      CirillaTile(
        onTap: () => widget.filterStore!.expand('ranges_price'),
        title: CirillaText(translate('product_list_ranges_price')),
        trailing: _IconButton(
          active: expand,
          onPressed: () => widget.filterStore!.expand('ranges_price'),
        ),
        isChevron: false,
      ),
      if (expand) _RangePrice(filterStore: widget.filterStore),
    ]);
  }

  Widget _buildApplyButton(BuildContext context, TranslateType translate) {
    return Container(
      height: 48,
      margin: paddingVertical,
      child: ElevatedButton(
        child: Text(translate('product_list_apply')),
        onPressed: () {
          widget.onSubmit!(widget.filterStore);
          Navigator.of(context).pop();
        },
      ),
    );
  }
}

class _Tile extends StatelessWidget {
  final String? title;
  final int count;
  final Widget Function(int index)? buildItem;
  final bool activeList;
  final Function? onChangeActiveList;
  final String? refineItemStyle;

  const _Tile({
    Key? key,
    this.title,
    this.count = 0,
    this.buildItem,
    this.activeList = false,
    this.onChangeActiveList,
    this.refineItemStyle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (_, BoxConstraints constraints) {
        double width = constraints.maxWidth;
        switch (refineItemStyle) {
          case Strings.refineItemStyleCard:
            double widthItem = (width - 16) / 2;
            return Column(
              children: [
                Padding(
                  padding: paddingVerticalLarge,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CirillaText(title),
                      const SizedBox(height: 16),
                      if (count > 0)
                        Wrap(
                          spacing: 16,
                          runSpacing: 8,
                          children: List.generate(
                            count,
                            (index) => SizedBox(
                              width: widthItem,
                              child: buildItem!(index),
                            ),
                          ),
                        )
                    ],
                  ),
                ),
                const Divider(height: 1, thickness: 1),
              ],
            );
          default:
            return Column(
              children: [
                CirillaTile(
                  onTap: onChangeActiveList as void Function()?,
                  title: CirillaText(title),
                  trailing: count > 0 ? _IconButton(active: activeList) : null,
                  isChevron: false,
                ),
                if (count > 0 && activeList) ...List.generate(count, (index) => buildItem!(index))
              ],
            );
        }
      },
    );
  }
}

class _IconButton extends StatelessWidget {
  final Function? onPressed;
  final bool? active;

  const _IconButton({Key? key, this.onPressed, this.active = false}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Color? color = Theme.of(context).textTheme.displayLarge?.color;
    Color activeColor = Theme.of(context).primaryColor;
    return IconButton(
      icon: Icon(
        active! ? FeatherIcons.chevronDown : FeatherIcons.chevronRight,
        color: active! ? activeColor : color,
        size: 16,
      ),
      onPressed: onPressed as void Function()?,
    );
  }
}

class _Attribute extends StatelessWidget {
  final Attribute? attribute;
  final FilterStore? filterStore;
  final String? refineItemStyle;

  const _Attribute({
    Key? key,
    this.attribute,
    this.filterStore,
    this.refineItemStyle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Observer(
      builder: (_) {
        List<Option> options = attribute!.terms!.options!;
        return _Tile(
          title: attribute!.name,
          activeList: filterStore!.itemExpand[attribute!.slug] != null,
          onChangeActiveList: () => filterStore!.expand(attribute!.slug),
          count: options.length,
          refineItemStyle: refineItemStyle,
          buildItem: (index) {
            if (refineItemStyle == Strings.refineItemStyleCard) {
              return _buildCard(context, options.elementAt(index));
            }
            return _buildListTitle(context, options.elementAt(index));
          },
        );
      },
    );
  }

  onSelected(Option option) {
    filterStore!.selectAttribute(
      ItemAttributeSelected(
        taxonomy: option.taxonomy,
        field: 'term_id',
        terms: option.termId,
        title: '${attribute!.name}: ${option.name}',
      ),
    );
  }

  Widget _buildCard(BuildContext context, Option option) {
    ThemeData theme = Theme.of(context);
    bool isSelected = filterStore!.attributeSelected
            .indexWhere((ItemAttributeSelected s) => s.taxonomy == option.taxonomy && s.terms == option.termId) >=
        0;

    return ButtonSelect.filter(
      isSelect: isSelected,
      colorSelect: theme.primaryColor,
      color: theme.colorScheme.surface,
      onTap: () => onSelected(option),
      child: Text(
        "${option.name}",
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: theme.textTheme.bodySmall?.copyWith(color: theme.textTheme.titleMedium?.color),
      ),
    );
  }

  Widget _buildListTitle(BuildContext context, Option option) {
    ThemeData theme = Theme.of(context);
    Widget trailing = const SizedBox();
    bool isSelected = filterStore!.attributeSelected
            .indexWhere((ItemAttributeSelected s) => s.taxonomy == option.taxonomy && s.terms == option.termId) >=
        0;
    Color? textColor = isSelected ? theme.textTheme.titleMedium?.color : null;

    if (attribute!.type == 'color') {
      trailing = Padding(
        padding: const EdgeInsetsDirectional.only(end: 12),
        child: Container(
          width: 22,
          height: 22,
          decoration: BoxDecoration(
            color: ConvertData.fromHex(option.value!, Colors.transparent),
            borderRadius: BorderRadius.circular(11),
          ),
        ),
      );
    }

    if (attribute!.type == 'image') {
      trailing = Padding(
        padding: const EdgeInsetsDirectional.only(end: 13),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(11),
          child: Image.network(
            option.value!,
            width: 22,
            height: 22,
          ),
        ),
      );
    }

    return CirillaTile(
      onTap: () => onSelected(option),
      leading: CirillaRadio.iconCheck(isSelect: isSelected),
      title: Container(
        alignment: AlignmentDirectional.centerStart,
        child: RichText(
          text: TextSpan(
            text: option.name,
            children: [
              TextSpan(text: ' (${option.count.toString()})', style: theme.textTheme.labelSmall),
            ],
            style: theme.textTheme.bodyMedium?.copyWith(color: textColor),
          ),
        ),
      ),
      trailing: trailing,
      isChevron: false,
    );
  }
}

class _Category extends StatelessWidget {
  final ProductCategory? category;
  final FilterStore? filterStore;
  final String? refineItemStyle;

  const _Category({
    Key? key,
    this.category,
    this.filterStore,
    this.refineItemStyle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool isSub = category!.categories!.isNotEmpty;
    return Observer(builder: (_) {
      String key = "category_${category!.id}";
      bool expand = filterStore!.itemExpand[key] != null;
      return refineItemStyle == Strings.refineItemStyleCard
          ? _buildCard(context, key: key, isSub: isSub, expand: expand)
          : _buildListTitle(context, key: key, isSub: isSub, expand: expand);
    });
  }

  Widget _buildCard(BuildContext context, {bool? isSub, bool? expand, String? key}) {
    ThemeData theme = Theme.of(context);
    bool isActive = filterStore!.categories.isNotEmpty == true && filterStore!.categories[0].id == category!.id;

    return SizedBox(
      width: double.infinity,
      child: ButtonSelect.filter(
        isSelect: isActive,
        colorSelect: theme.primaryColor,
        color: theme.colorScheme.surface,
        onTap: () => filterStore!.onChange(categories: category != null ? [category!] : null),
        child: Text(
          "${category!.name}",
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: theme.textTheme.bodySmall?.copyWith(color: theme.textTheme.titleMedium?.color),
        ),
      ),
    );
  }

  Widget _buildListTitle(BuildContext context, {bool? isSub, required bool expand, String? key}) {
    ThemeData theme = Theme.of(context);
    ProductCategory? filterCategory = filterStore?.categories.isNotEmpty == true ? filterStore!.categories[0] : null;
    Color? textColor = filterCategory?.id == category!.id ? theme.textTheme.titleMedium?.color : null;
    return Column(
      children: [
        CirillaTile(
          leading: CirillaRadio(isSelect: filterCategory?.id == category!.id),
          title: Container(
            alignment: AlignmentDirectional.centerStart,
            child: RichText(
              text: TextSpan(
                text: category!.name,
                children: [
                  if (category!.count! > -1)
                    TextSpan(text: ' (${category!.count.toString()})', style: theme.textTheme.labelSmall),
                ],
                style: theme.textTheme.bodyMedium?.copyWith(color: textColor),
              ),
            ),
          ),
          trailing: category!.categories!.isNotEmpty
              ? _IconButton(
                  active: expand,
                  onPressed: () => filterStore!.expand(key),
                )
              : null,
          onTap: () => filterStore!.onChange(categories: category != null ? [category!] : null),
          isChevron: false,
        ),
        if (expand && category!.categories!.isNotEmpty)
          Padding(
            padding: const EdgeInsetsDirectional.only(start: 36),
            child: Column(
              children: List.generate(
                category!.categories!.length,
                (int index) => _Category(
                  category: category!.categories![index],
                  filterStore: filterStore,
                ),
              ),
            ),
          )
      ],
    );
  }
}

class _Brand extends StatelessWidget {
  final Brand? brand;
  final FilterStore? filterStore;
  final String? refineItemStyle;

  const _Brand({
    Key? key,
    this.brand,
    this.filterStore,
    this.refineItemStyle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Observer(builder: (_) {
      return refineItemStyle == Strings.refineItemStyleCard ? _buildCard(context) : _buildListTitle(context);
    });
  }

  Widget _buildCard(BuildContext context) {
    ThemeData theme = Theme.of(context);
    bool isActive = filterStore?.brand?.id == brand?.id;

    return SizedBox(
      width: double.infinity,
      child: ButtonSelect.filter(
        isSelect: isActive,
        colorSelect: theme.primaryColor,
        color: theme.colorScheme.surface,
        onTap: () => filterStore!.onChange(brand: brand),
        child: Text(
          brand?.name ?? "",
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: theme.textTheme.bodySmall?.copyWith(color: theme.textTheme.titleMedium?.color),
        ),
      ),
    );
  }

  Widget _buildListTitle(BuildContext context) {
    ThemeData theme = Theme.of(context);
    Color? textColor = filterStore?.brand?.id == brand?.id ? theme.textTheme.titleMedium?.color : null;
    return CirillaTile(
      leading: CirillaRadio(isSelect: filterStore?.brand?.id == brand?.id),
      title: Container(
        alignment: AlignmentDirectional.centerStart,
        child: Text(
          brand?.name ?? "",
          style: theme.textTheme.bodyMedium?.copyWith(color: textColor),
        ),
      ),
      onTap: () => filterStore!.onChange(brand: brand),
      isChevron: false,
    );
  }
}

class _RangePrice extends StatelessWidget {
  final FilterStore? filterStore;

  const _RangePrice({Key? key, this.filterStore}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Observer(
      builder: (_) => Container(
        padding: paddingDefault,
        child: Column(
          children: [
            RangeSlider(
              values: filterStore!.rangePrices,
              min: filterStore!.productPrices.minPrice!,
              max: filterStore!.productPrices.maxPrice!,
              divisions: (filterStore!.productPrices.maxPrice! - filterStore!.productPrices.minPrice!).toInt(),
              labels: RangeLabels(
                formatCurrency(context, price: filterStore!.rangePrices.start.round().toString()),
                formatCurrency(context, price: filterStore!.rangePrices.end.round().toString()),
              ),
              onChanged: (RangeValues values) {
                filterStore!.setMinMaxPrice(values.start, values.end);
              },
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(formatCurrency(context, price: filterStore!.productPrices.minPrice.toString())),
                Text(formatCurrency(context, price: filterStore!.productPrices.maxPrice.toString()))
              ],
            ),
          ],
        ),
      ),
    );
  }
}
