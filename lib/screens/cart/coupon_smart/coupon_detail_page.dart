// Flutter library
import 'package:cirilla/constants/constants.dart';
import 'package:cirilla/mixins/mixins.dart';
import 'package:cirilla/models/models.dart';
import 'package:cirilla/types/types.dart';
import 'package:cirilla/utils/utils.dart';
import 'package:cirilla/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:feather_icons/feather_icons.dart';
import 'package:flutter/services.dart';
import 'package:flutter_html/flutter_html.dart';

class CouponDetailPage extends StatelessWidget with AppBarMixin, SnackMixin {
  final Coupon coupon;

  const CouponDetailPage({
    super.key,
    required this.coupon,
  });

  Widget buildBox({
    required String title,
    required String content,
    required ThemeData theme,
    Widget? trailing,
    double padBottom = 0,
    bool enableHtml = false,
  }) {
    TextStyle? styleContent = theme.textTheme.bodyLarge;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: theme.textTheme.titleMedium),
        ListTile(
          title: enableHtml
              ? CirillaHtml(
                  html: content,
                  style: {
                    'body': Style(
                      margin: EdgeInsets.zero,
                      padding: EdgeInsets.zero,
                      fontFamily: styleContent?.fontFamily,
                      fontSize: FontSize(styleContent?.fontSize ?? 16),
                      fontWeight: styleContent?.fontWeight ?? FontWeight.w500,
                      color: styleContent?.color,
                      lineHeight: LineHeight(styleContent?.height ?? 1.5),
                    ),
                  },
                )
              : Text(content),
          trailing: trailing,
          contentPadding: EdgeInsets.zero,
          dense: true,
          visualDensity: const VisualDensity(vertical: -4),
        )
      ],
    );
  }

  void onCopy(BuildContext context) {
    String text = coupon.couponCode?.toUpperCase() ?? '';
    Clipboard.setData(ClipboardData(text: text)).then((_) {
      showSuccess(context, 'Copied "$text"');
    });
  }

  @override
  Widget build(BuildContext context) {
    TranslateType translate = AppLocalizations.of(context)!.translate;
    ThemeData theme = Theme.of(context);

    String error =
        coupon.couponObject?.containsKey('error_message') == true ? coupon.couponObject!['error_message'] : '';

    return Scaffold(
      appBar: baseStyleAppBar(context, title: translate('cart_coupon_detail_2')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(layoutPadding, itemPadding, layoutPadding, itemPaddingLarge),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            buildBox(
              title: translate('cart_coupon_code'),
              content: coupon.couponCode?.toUpperCase() ?? '',
              trailing: coupon.isInvalid != true
                  ? TextButton(
                      onPressed: () => onCopy(context),
                      style: TextButton.styleFrom(
                        padding: EdgeInsets.zero,
                        minimumSize: Size.zero,
                        textStyle: theme.textTheme.bodyMedium,
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(translate('cart_coupon_copy')),
                          const SizedBox(width: 4),
                          const Icon(FeatherIcons.copy, size: 16),
                        ],
                      ),
                    )
                  : null,
              theme: theme,
              padBottom: itemPaddingLarge,
            ),
            buildBox(
              title: translate('cart_coupon_expired'),
              content: coupon.couponExpiry ?? '',
              theme: theme,
              padBottom: itemPaddingLarge,
            ),
            buildBox(
              title: translate('cart_coupon_description'),
              content: coupon.couponDescription ?? '',
              theme: theme,
              enableHtml: true,
            ),
            if (error.isNotEmpty)
              CirillaHtml(
                html: error,
                style: {
                  'body': Style(
                    margin: const EdgeInsets.only(top: itemPaddingLarge),
                    padding: EdgeInsets.zero,
                    color: theme.colorScheme.error,
                    fontFamily: theme.textTheme.titleSmall?.fontFamily,
                    fontSize: FontSize(theme.textTheme.titleSmall?.fontSize),
                    fontWeight: theme.textTheme.titleSmall?.fontWeight,
                  ),
                },
              ),
          ],
        ),
      ),
      bottomNavigationBar: coupon.isInvalid != true
          ? Padding(
              padding: const EdgeInsets.fromLTRB(layoutPadding, 0, layoutPadding, layoutPadding),
              child: SizedBox(
                height: 48,
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(context, true),
                  child: Text(translate('cart_apply')),
                ),
              ),
            )
          : null,
    );
  }
}
