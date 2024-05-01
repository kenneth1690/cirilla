// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product_price_format.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ProductPriceFormat _$ProductPriceFormatFromJson(Map<String, dynamic> json) {
  $checkKeys(
    json,
    requiredKeys: const ['regular_price'],
  );
  return ProductPriceFormat(
    regularPrice: json['regular_price'] as String? ?? '0.0',
    salePrice: json['sale_price'] as String?,
    percent: json['percent'] as int?,
  );
}

Map<String, dynamic> _$ProductPriceFormatToJson(ProductPriceFormat instance) =>
    <String, dynamic>{
      'regular_price': instance.regularPrice,
      'sale_price': instance.salePrice,
      'percent': instance.percent,
    };
