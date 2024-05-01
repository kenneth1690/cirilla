import 'package:cirilla/constants/assets.dart';
import 'package:cirilla/mixins/mixins.dart';
import 'package:cirilla/models/models.dart';
import 'package:cirilla/screens/cart/coupon_smart/coupon_detail_page.dart';
import 'package:cirilla/themes/components/saw_path.dart';
import 'package:cirilla/types/types.dart';
import 'package:cirilla/utils/app_localization.dart';
import 'package:cirilla/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:ui/ui.dart';

const List<BoxShadow> secondShadow = [
  BoxShadow(
    color: Color.fromRGBO(0, 0, 0, 0.12),
    offset: Offset(0, 1),
    blurRadius: 5,
    spreadRadius: 0,
  ),
];

class CirillaCouponItem extends StatelessWidget with VoucherMixin, TransitionMixin {
  final Coupon? coupon;
  final bool selected;
  final GestureTapCallback? onChangeSelected;

  const CirillaCouponItem({
    super.key,
    this.coupon,
    this.selected = false,
    this.onChangeSelected,
  });

  bool get enable {
    return coupon?.isInvalid != true;
  }

  Widget renderImage(double size, double radius, ThemeData theme) {
    Widget image = coupon?.thumbnailSrc?.endsWith('.svg') == true
        ? _ImageSvg(
            url: coupon!.thumbnailSrc!,
            width: size,
            height: size,
            colorFilter: !enable ? theme.disabledColor : null,
          )
        : CirillaCacheImage(
            coupon?.thumbnailSrc,
            width: size,
            height: size,
            colorFilter: !enable ? theme.disabledColor : null,
          );

    return ClipRRect(
      borderRadius: BorderRadius.circular(radius),
      child: image,
    );
  }

  Widget renderName(ThemeData theme) {
    TextStyle? style = theme.textTheme.titleSmall;
    return CirillaHtml(
      html: coupon?.couponDescription ?? '',
      style: {
        'body': Style(
          margin: EdgeInsets.zero,
          padding: EdgeInsets.zero,
          fontFamily: style?.fontFamily,
          fontSize: FontSize(style?.fontSize ?? 14),
          fontWeight: style?.fontWeight ?? FontWeight.w500,
          color: style?.color,
          lineHeight: LineHeight(style?.height ?? 1.43),
        ),
      },
    );
  }

  Widget renderCondition(BuildContext context, ThemeData theme) {
    TranslateType translate = AppLocalizations.of(context)!.translate;
    return TextButton(
      onPressed: () {
        Navigator.push(
          context,
          PageRouteBuilder(
            pageBuilder: (context, _, __) => CouponDetailPage(
              coupon: coupon ?? Coupon(),
            ),
            transitionsBuilder: slideTransition,
          ),
        ).then((value) {
          if (value == true && enable && onChangeSelected != null) {
            onChangeSelected!.call();
          }
        });
      },
      style: TextButton.styleFrom(
        padding: EdgeInsets.zero,
        textStyle: theme.textTheme.bodySmall,
        minimumSize: Size.zero,
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
      ),
      child: Text(translate('cart_coupon_detail')),
    );
  }

  Widget renderOffer(ThemeData theme) {
    TextStyle? labelSmall = theme.textTheme.labelSmall;

    Color color = enable ? theme.primaryColor : theme.dividerColor;

    TextStyle? titleColor = labelSmall?.copyWith(color: enable ? theme.cardColor : labelSmall.color);

    String amount =
        '${coupon?.isPercent == true ? '' : coupon?.amountSymbol}${coupon?.couponAmount ?? 0}${coupon?.isPercent == true ? coupon?.amountSymbol : ''}';

    return Wrap(
      children: [
        BadgeUi(
          text: Text(
            '$amount ${coupon?.discountType ?? ''}',
            style: titleColor,
          ),
          padding: const EdgeInsets.symmetric(horizontal: 8),
          color: color,
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);

    bool isLoading = coupon == null;

    return SawPathComponent(
      background: theme.cardColor,
      boxShadow: secondShadow[0],
      child: CouponSmartItem(
        image: buildImage(
          image: (size, radius) => renderImage(size, radius, theme),
          isLoading: isLoading,
        ),
        title: buildOffer(
          offer: renderOffer(theme),
          isLoading: isLoading,
        ),
        description: ListTile(
          title: buildName(
            name: renderName(theme),
            isLoading: isLoading,
          ),
          trailing: buildIconCheckbox(
            icon: CirillaRadio(
              isSelect: selected,
              selectColor: enable ? theme.primaryColor : theme.textTheme.labelSmall?.color,
            ),
            isLoading: isLoading,
          ),
          contentPadding: EdgeInsets.zero,
          dense: true,
          visualDensity: const VisualDensity(vertical: -4),
        ),
        sortDescription: ListTile(
          title: buildExpired(expired: coupon?.couponExpiry, theme: theme, isLoading: isLoading),
          trailing: buildStatus(status: renderCondition(context, theme), isLoading: isLoading),
          contentPadding: EdgeInsets.zero,
          dense: true,
          visualDensity: const VisualDensity(vertical: -4),
        ),
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        onTap: enable && onChangeSelected != null ? () => onChangeSelected!.call() : null,
      ),
    );
  }
}

class _ImageSvg extends StatelessWidget {
  final String url;
  final double? width;
  final double? height;
  final Color? colorFilter;

  const _ImageSvg({
    required this.url,
    this.width,
    this.height,
    this.colorFilter,
  });

  @override
  Widget build(BuildContext context) {
    String assetImage = '';
    if (url.endsWith('cart-discount.svg') == true) {
      assetImage = 'assets/images/coupon/cart-discount.png';
    } else if (url.endsWith('cart-discount-alt.svg') == true) {
      assetImage = 'assets/images/coupon/cart-discount-alt.png';
    } else if (url.endsWith('delivery-motorcyle.svg') == true) {
      assetImage = 'assets/images/coupon/delivery-motorcyle.png';
    } else if (url.endsWith('discount-coupon.svg') == true) {
      assetImage = 'assets/images/coupon/discount-coupon.png';
    } else if (url.endsWith('gift-card-alt.svg') == true) {
      assetImage = 'assets/images/coupon/gift-card-alt.png';
    } else if (url.endsWith('gift-voucher-credit-alt.svg') == true) {
      assetImage = 'assets/images/coupon/gift-voucher-credit-alt.png';
    } else if (url.endsWith('giftbox-color.svg') == true) {
      assetImage = 'assets/images/coupon/giftbox-color.png';
    } else if (url.endsWith('megaphone-announce-color-alt.svg') == true) {
      assetImage = 'assets/images/coupon/megaphone-announce-color-alt.png';
    } else if (url.endsWith('product-discount-alt.svg') == true) {
      assetImage = 'assets/images/coupon/product-discount-alt.png';
    } else if (url.endsWith('product-package-box.svg') == true) {
      assetImage = 'assets/images/coupon/product-package-box.png';
    } else if (url.endsWith('sale-splash-tag.svg') == true) {
      assetImage = 'assets/images/coupon/sale-splash-tag.png';
    } else if (url.endsWith('subs-calendar-discount.svg') == true) {
      assetImage = 'assets/images/coupon/subs-calendar-discount.png';
    } else if (url.endsWith('subs-discount-voucher.svg') == true) {
      assetImage = 'assets/images/coupon/subs-discount-voucher.png';
    }

    Widget image = assetImage.isEmpty
        ? CirillaCacheImage(
            url,
            width: width,
            height: height,
            colorFilter: colorFilter,
          )
        : Image.asset(
            assetImage,
            width: width,
            height: height,
            fit: BoxFit.cover,
            errorBuilder: (
              _,
              __,
              ___,
            ) {
              return Image.network(
                Assets.noImageUrl,
                width: width,
                height: height,
                fit: BoxFit.cover,
              );
            },
          );

    if (colorFilter != null) {
      return ColorFiltered(
        colorFilter: ColorFilter.mode(colorFilter!, BlendMode.color),
        child: image,
      );
    }
    return image;
  }
}
