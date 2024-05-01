import 'package:cirilla/constants/constants.dart';
import 'package:cirilla/mixins/mixins.dart';
import 'package:cirilla/models/models.dart';
import 'package:cirilla/types/types.dart';
import 'package:cirilla/utils/utils.dart';
import 'package:cirilla/widgets/cirilla_quantity.dart';
import 'package:cirilla/filters/filter_quantity.dart';
import 'package:flutter/material.dart';

class ProductQuantity extends StatelessWidget with ShapeMixin, ProductMixin {
  final Product? product;
  final String? align;
  final int qty;
  final ValueChanged<int>? onChanged;
  final int initStep;
  final int initMin;
  final int? initMax;

  const ProductQuantity({
    Key? key,
    this.product,
    this.align = 'left',
    this.qty = 1,
    this.onChanged,
    this.initStep = 1,
    this.initMin = 1,
    this.initMax,
  }) : super(key: key);

  void buildModalEmpty(BuildContext context) {
    TranslateType translate = AppLocalizations.of(context)!.translate;
    Future<void> future = showModalBottomSheet<void>(
      context: context,
      shape: borderRadiusTop(),
      isScrollControlled: true,
      builder: (context) {
        return Container(
          padding: paddingHorizontal.copyWith(top: itemPaddingMedium, bottom: itemPaddingLarge),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                translate('product_quantity_min', {'min': '1'}),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                    onPressed: () => Navigator.pop(context), child: Text(translate('product_quantity_agree'))),
              ),
            ],
          ),
        );
      },
    );
    future.then((void value) {
      onChanged!(1);
    });
  }

  @override
  Widget build(BuildContext context) {
    AlignmentDirectional alignment = align == 'right'
        ? AlignmentDirectional.centerEnd
        : align == 'center'
            ? AlignmentDirectional.center
            : AlignmentDirectional.centerStart;
    if (hideQuantity(product)) {
      return const SizedBox();
    }

    int? stockQty = product?.stockQuantity;

    int? max = b2bkingFilterQuantity(context, stockQty != null && stockQty > 0 ? stockQty : (initMax ?? CirillaQuantity.maxQty), product ?? Product(), "max");
    int min = b2bkingFilterQuantity(context, initMin, product ?? Product(), "min") ?? initMin;
    int step = b2bkingFilterQuantity(context, initStep, product ?? Product(), "step") ?? initStep;

    return Container(
      alignment: alignment,
      child: CirillaQuantity(
        key: Key("product_quantity_id=${product?.id}_value=$qty"),
        max: max,
        min: min,
        step: step,
        onChanged: onChanged,
        value: qty,
        color: Theme.of(context).colorScheme.surface,
        height: 48,
        radius: 8,
      ),
    );
  }
}
