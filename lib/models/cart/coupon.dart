import 'package:cirilla/utils/utils.dart';
import 'package:json_annotation/json_annotation.dart';

part 'coupon.g.dart';

@JsonSerializable()
class Coupon {
  @JsonKey(name: 'coupon_object', fromJson: _fromToMap)
  Map? couponObject;

  @JsonKey(name: 'coupon_amount')
  String? couponAmount;

  @JsonKey(name: 'amount_symbol')
  String? amountSymbol;

  @JsonKey(name: 'discount_type')
  String? discountType;

  @JsonKey(name: 'coupon_description')
  String? couponDescription;

  @JsonKey(name: 'coupon_code')
  String? couponCode;

  @JsonKey(name: 'coupon_expiry')
  String? couponExpiry;

  @JsonKey(name: 'thumbnail_src')
  String? thumbnailSrc;

  String? classes;

  @JsonKey(name: 'is_percent', fromJson: _fromToBool)
  bool? isPercent;

  @JsonKey(name: 'is_invalid', fromJson: _fromToBool)
  bool? isInvalid;

  Coupon({
    this.couponObject,
    this.couponAmount,
    this.amountSymbol,
    this.discountType,
    this.couponDescription,
    this.couponCode,
    this.couponExpiry,
    this.thumbnailSrc,
    this.classes,
    this.isPercent,
    this.isInvalid,
  });
  factory Coupon.fromJson(Map<String, dynamic> json) => _$CouponFromJson(json);

  Map<String, dynamic> toJson() => _$CouponToJson(this);

  static Map? _fromToMap(dynamic value) {
    if (value is Map) {
      return value;
    }
    return null;
  }

  static bool? _fromToBool(dynamic value) {
    return ConvertData.toBoolValue(value);
  }
}
