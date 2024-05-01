import 'package:cirilla/mixins/mixins.dart';
import 'package:cirilla/models/product_category/product_category.dart';
import 'package:cirilla/models/setting/setting.dart';
import 'package:cirilla/store/product_category/product_category_store.dart';
import 'package:cirilla/store/setting/setting_store.dart';
import 'package:cirilla/utils/convert_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/provider.dart';

import 'widgets/body_horizontal.dart';
import 'widgets/body_vertical.dart';
import 'widgets/body_default.dart';

class ProductCategoryScreen extends StatefulWidget {
  static const routeName = '/product_category';

  const ProductCategoryScreen({Key? key}) : super(key: key);

  @override
  State<ProductCategoryScreen> createState() => _ProductCategoryScreenState();
}

class _ProductCategoryScreenState extends State<ProductCategoryScreen> with LoadingMixin, Utility, CategoryMixin {
  late ProductCategoryStore _productCategoryStore;
  SettingStore? _settingStore;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _productCategoryStore = Provider.of<ProductCategoryStore>(context);
    _settingStore = Provider.of<SettingStore>(context);
  }

  List<ProductCategory> excludeData(List<ProductCategory> categories, List exclude) {
    if (exclude.isEmpty) {
      return categories;
    }
    return categories
        .where((category) =>
            exclude.where((element) => ConvertData.stringToInt(element['key']) == category.id).toList().isEmpty)
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Observer(
      builder: (_) {
        final String languageKey = _settingStore?.languageKey ?? 'text';
        final String themeModeKey = _settingStore?.themeModeKey ?? 'value';
        final String imageKey = _settingStore?.imageKey ?? 'src';

        final WidgetConfig widgetConfig = _settingStore!.data!.screens!['category']!.widgets!['categoryPage']!;
        final Map<String, dynamic>? configs = _settingStore!.data!.screens!['category']!.configs;

        final List excludeCategory = get(widgetConfig.fields, ['excludeCategory'], []);
        final List includeCategory = get(widgetConfig.fields, ['includeCategory'], []);

        String layout = widgetConfig.layout ?? 'vertical';

        List<ProductCategory> categories = (exclude(
          categories: include(
            categories: _productCategoryStore.categories,
            includes: includeCategory.map((e) => ConvertData.stringToInt(e['key'])).toList().cast<int>(),
          ),
          excludes: excludeCategory.map((e) => ConvertData.stringToInt(e['key'])).toList().cast<int>(),
        ) ?? []).whereType<ProductCategory>().toList().cast();

        if (_productCategoryStore.loading) {
          return buildLoading(context, isLoading: true);
        }

        EdgeInsetsDirectional padding = ConvertData.space(get(widgetConfig.styles, ['padding'], {}), 'padding');
        EdgeInsetsDirectional margin = ConvertData.space(get(widgetConfig.styles, ['margin'], {}), 'margin');

        Widget child;
        switch (layout) {
          case 'horizontal':
            child = HorizontalCategory(
              categories: categories,
              configs: configs,
              widgetConfig: widgetConfig,
              languageKey: languageKey,
              themeModeKey: themeModeKey,
              imageKey: imageKey,
            );
            break;
          case 'vertical':
            child = VerticalCategory(
              categories: categories,
              configs: configs,
              widgetConfig: widgetConfig,
              languageKey: languageKey,
              themeModeKey: themeModeKey,
              imageKey: imageKey,
            );
            break;
          default:
            child = DefaultCategory(
              categories: categories,
              configs: configs,
              widgetConfig: widgetConfig,
              languageKey: languageKey,
              themeModeKey: themeModeKey,
              imageKey: imageKey,
            );
        }
        return Container(
          padding: padding,
          margin: margin,
          child: child,
        );
      },
    );
  }
}
