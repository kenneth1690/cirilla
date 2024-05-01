import 'package:cirilla/constants/constants.dart';
import 'package:cirilla/types/types.dart';
import 'package:cirilla/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:cirilla/mixins/mixins.dart';

class CouponInputApply extends StatelessWidget with LoadingMixin {
  final TextEditingController textController;
  final bool loading;
  final void Function() onApply;
  final void Function(String)? onChanged;

  const CouponInputApply({
    super.key,
    required this.textController,
    required this.onApply,
    this.loading = false,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    TranslateType translate = AppLocalizations.of(context)!.translate;

    ThemeData theme = Theme.of(context);

    TextTheme textTheme = theme.textTheme;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Flexible(
            child: Padding(
                padding: const EdgeInsetsDirectional.only(end: itemPadding, top: itemPadding, bottom: itemPadding),
                child: TextFormField(
                  style: textTheme.bodyMedium?.copyWith(color: theme.textTheme.titleMedium?.color),
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsetsDirectional.only(start: itemPaddingMedium),
                    hintText: translate('cart_coupon_discount'),
                    hintStyle: textTheme.bodyMedium,
                    border: const OutlineInputBorder(
                      borderRadius: borderRadius,
                    ),
                  ),
                  controller: textController,
                  onChanged: onChanged,
                ))),
        ElevatedButton(
          style: ElevatedButton.styleFrom(minimumSize: const Size(89, 48)),
          onPressed: loading ? () => onApply() : null,
          child: Text(translate('cart_apply')),
        )
      ],
    );
  }
}
