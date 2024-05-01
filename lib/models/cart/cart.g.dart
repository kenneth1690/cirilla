// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cart.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CartData _$CartDataFromJson(Map<String, dynamic> json) => CartData(
      hasCalculatedShipping: json['has_calculated_shipping'] as bool?,
      itemsCount: json['items_count'] as int?,
      itemsWeight: (json['items_weight'] as num?)?.toDouble(),
      needsPayment: json['needs_payment'] as bool?,
      needsShipping: json['needs_shipping'] as bool?,
      shippingAddress: json['shipping_address'] as Map<String, dynamic>,
      billingAddress: json['billing_address'] as Map<String, dynamic>?,
    )
      ..items = CartData._fromListItem(json['items'] as List?)
      ..shippingRate =
          CartData._fromShippingRate(json['shipping_rates'] as List?)
      ..coupons = json['coupons'] as List<dynamic>?
      ..errors = json['errors'] as List<dynamic>?
      ..extensions = json['extensions'] as Map?
      ..totals = json['totals'] as Map<String, dynamic>?;

Map<String, dynamic> _$CartDataToJson(CartData instance) => <String, dynamic>{
      'items_count': instance.itemsCount,
      'items_weight': instance.itemsWeight,
      'needs_payment': instance.needsPayment,
      'needs_shipping': instance.needsShipping,
      'has_calculated_shipping': instance.hasCalculatedShipping,
      'items': CartData._toListItem(instance.items),
      'shipping_rates': CartData._toShippingRate(instance.shippingRate),
      'coupons': instance.coupons,
      'errors': instance.errors,
      'extensions': instance.extensions,
      'totals': instance.totals,
      'shipping_address': instance.shippingAddress,
      'billing_address': instance.billingAddress,
    };

ShippingRate _$ShippingRateFromJson(Map<String, dynamic> json) => ShippingRate(
      packageId: json['package_id'] as int?,
      name: json['name'] as String?,
      destination: json['destination'] as Map<String, dynamic>?,
      shipItem: ShippingRate._fromShipItem(json['shipping_rates'])
    );

Map<String, dynamic> _$ShippingRateToJson(ShippingRate instance) =>
    <String, dynamic>{
      'package_id': instance.packageId,
      'destination': instance.destination,
      'shipping_rates': ShippingRate._toShipItem(instance.shipItem),
      'name': instance.name,
    };

CartItem _$CartItemFromJson(Map<String, dynamic> json) => CartItem(
      key: json['key'] as String?,
      id: json['id'] as int?,
      quantity: json['quantity'] as int?,
      quantityLimit: json['quantity_limits'] == null
          ? null
          : QuantityLimit.fromJson(
              json['quantity_limits'] as Map<String, dynamic>),
      name: json['name'] as String?,
      images: (json['images'] as List<dynamic>?)
          ?.map((e) => e as Map<String, dynamic>)
          .toList(),
      prices: json['prices'] as Map<String, dynamic>?,
      variation: (json['variation'] as List<dynamic>?)
          ?.map((e) => e as Map<String, dynamic>)
          .toList(),
      itemData: (json['item_data'] as List<dynamic>?)
          ?.map((e) => e as Map<String, dynamic>)
          .toList(),
    );

Map<String, dynamic> _$CartItemToJson(CartItem instance) => <String, dynamic>{
      'key': instance.key,
      'id': instance.id,
      'quantity': instance.quantity,
      'quantity_limits': CartItem._toQuantity(instance.quantityLimit),
      'name': instance.name,
      'images': instance.images,
      'variation': instance.variation,
      'item_data': instance.itemData,
      'prices': instance.prices,
    };

ShipItem _$ShipItemFromJson(Map<String, dynamic> json) => ShipItem(
      rateId: json['rate_id'] as String?,
      name: json['name'] as String?,
      deliveryTime: json['delivery_time'] as String?,
      currencyCode: json['currency_code'] as String?,
      currencySymbol: json['currency_symbol'] as String?,
      description: json['description'] as String?,
      methodId: json['method_id'] as String?,
      price: json['price'] as String?,
      taxes: json['taxes'] as String?,
      selected: json['selected'] as bool?,
    );

Map<String, dynamic> _$ShipItemToJson(ShipItem instance) => <String, dynamic>{
      'rate_id': instance.rateId,
      'name': instance.name,
      'description': instance.description,
      'delivery_time': instance.deliveryTime,
      'price': instance.price,
      'taxes': instance.taxes,
      'method_id': instance.methodId,
      'selected': instance.selected,
      'currency_code': instance.currencyCode,
      'currency_symbol': instance.currencySymbol,
    };

QuantityLimit _$QuantityLimitFromJson(Map<String, dynamic> json) =>
    QuantityLimit(
      minimum: json['minimum'] as int? ?? 1,
      maximum: json['maximum'] as int?,
      step: json['multiple_of'] as int? ?? 1,
    );

Map<String, dynamic> _$QuantityLimitToJson(QuantityLimit instance) =>
    <String, dynamic>{
      'minimum': instance.minimum,
      'maximum': instance.maximum,
      'multiple_of': instance.step,
    };
