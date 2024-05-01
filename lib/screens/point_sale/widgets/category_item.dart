import 'package:cirilla/mixins/mixins.dart';
import 'package:cirilla/models/product_category/product_category.dart';
import 'package:cirilla/types/types.dart';
import 'package:cirilla/utils/utils.dart';
import 'package:cirilla/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:ui/ui.dart';

class CategoryItem extends StatelessWidget with CategoryMixin {
  final ProductCategory? category;
  final String type;
  final GestureTapCallback? onClick;

  const CategoryItem({
    super.key,
    this.category,
    this.type = "horizontal",
    this.onClick,
  });

  void onClickCategory() {
    if (category?.id != null) {
      onClick?.call();
    }
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    TranslateType translate = AppLocalizations.of(context)!.translate;
    ProductCategory ca = category ?? ProductCategory();

    switch (type) {
      case "tile":
        return CirillaTile(
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              buildName(
                category: ca,
                style: theme.textTheme.titleMedium,
                theme: theme,
              ),
              buildCount(
                category: ca,
                style: theme.textTheme.bodySmall,
                theme: theme,
                translate: translate,
              ),
            ],
          ),
          trailing: buildImage(
            category: ca,
            width: 70,
            height: 45,
            radius: 4,
            borderStyle: "solid",
            borderColor: theme.dividerColor,
          ),
          height: 100,
          isDivider: false,
          isChevron: false,
          padding: const EdgeInsets.symmetric(horizontal: 20),
          onTap: onClickCategory,
        );
      default:
        return ProductCategoryHorizontalItem(
          image: buildImage(
            category: ca,
            width: 92,
            height: 92,
            radius: 0,
          ),
          name: buildName(
            category: ca,
            style: theme.textTheme.titleMedium,
            theme: theme,
          ),
          color: theme.cardColor,
          count: buildCount(
            category: ca,
            style: theme.textTheme.bodySmall,
            theme: theme,
            translate: translate,
          ),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          onClick: onClickCategory,
        );
    }
  }
}
