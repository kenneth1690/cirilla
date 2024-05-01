import 'package:cirilla/constants/styles.dart';
import 'package:flutter/material.dart';
import 'package:ui/ui.dart';

class ItemGateway extends StatelessWidget {
  final int active;
  final int index;
  final void Function(int index) select;
  final EdgeInsetsGeometry padding;
  final String? imageMethod;
  final String? packageName;
  final Widget title;

  const ItemGateway({
    required this.active,
    required this.index,
    required this.select,
    required this.padding,
    required this.title,
    this.imageMethod,
    this.packageName,
    super.key,
  });
  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return Padding(
      padding: padding,
      child: ButtonSelect.icon(
        isSelect: active == index,
        colorSelect: theme.primaryColor,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.asset(
                imageMethod ?? "",
                width: 35,
                height: 35,
                package: packageName,
              ),
            ),
            const SizedBox(width: itemPaddingMedium),
            title,
          ],
        ),
        onTap: () => select(index),
      ),
    );
  }
}

class ItemDescription extends StatelessWidget {
  final String description;
  final EdgeInsetsGeometry padding;
  const ItemDescription({required this.description, required this.padding, super.key});

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return Padding(
      padding: padding,
      child: Container(
        padding: paddingMedium,
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: theme.dividerColor),
        ),
        child: Text(description, style: theme.textTheme.bodyMedium),
      ),
    );
  }
}
