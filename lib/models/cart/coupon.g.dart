// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'coupon.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Coupon _$CouponFromJson(Map<String, dynamic> json) => Coupon(
      couponObject: Coupon._fromToMap(json['coupon_object']),
      couponAmount: json['coupon_amount'] as String?,
      amountSymbol: json['amount_symbol'] as String?,
      discountType: json['discount_type'] as String?,
      couponDescription: json['coupon_description'] as String?,
      couponCode: json['coupon_code'] as String?,
      couponExpiry: json['coupon_expiry'] as String?,
      thumbnailSrc: json['thumbnail_src'] as String?,
      classes: json['classes'] as String?,
      isPercent: Coupon._fromToBool(json['is_percent']),
      isInvalid: Coupon._fromToBool(json['is_invalid']),
    );

Map<String, dynamic> _$CouponToJson(Coupon instance) => <String, dynamic>{
      'coupon_object': instance.couponObject,
      'coupon_amount': instance.couponAmount,
      'amount_symbol': instance.amountSymbol,
      'discount_type': instance.discountType,
      'coupon_description': instance.couponDescription,
      'coupon_code': instance.couponCode,
      'coupon_expiry': instance.couponExpiry,
      'thumbnail_src': instance.thumbnailSrc,
      'classes': instance.classes,
      'is_percent': instance.isPercent,
      'is_invalid': instance.isInvalid,
    };
