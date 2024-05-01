import 'package:cirilla/models/models.dart';
import 'package:cirilla/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:cirilla/mixins/mixins.dart';

class ProductQueryData extends StatelessWidget with ProductMixin {
  final Product? product;
  final dynamic query;
  final String? align;
  final String? languageKey;

  const ProductQueryData({super.key, this.product, this.query, this.align, this.languageKey});

  @override
  Widget build(BuildContext context) {
    return buildQueryData(
      context,
      product: product,
      query: query,
      textAlign: ConvertData.toTextAlignDirection(align),
      languageKey: languageKey ?? "text",
    ) ?? Container();
  }
}