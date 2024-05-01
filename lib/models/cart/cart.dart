import 'package:json_annotation/json_annotation.dart';

part 'cart.g.dart';

@JsonSerializable()
class CartData {
  @JsonKey(name: 'items_count')
  int? itemsCount;

  @JsonKey(name: 'items_weight')
  double? itemsWeight;

  @JsonKey(name: 'needs_payment')
  bool? needsPayment;

  @JsonKey(name: 'needs_shipping')
  bool? needsShipping;

  @JsonKey(name: 'has_calculated_shipping')
  bool? hasCalculatedShipping;

  @JsonKey(fromJson: _fromListItem, toJson: _toListItem)
  List<CartItem>? items;

  @JsonKey(name: 'shipping_rates', fromJson: _fromShippingRate, toJson: _toShippingRate)
  List<ShippingRate>? shippingRate;

  List? coupons;

  Map<String, dynamic>? totals;

  @JsonKey(name: 'shipping_address')
  Map<String, dynamic> shippingAddress;

  @JsonKey(name: 'billing_address')
  Map<String, dynamic>? billingAddress;

  List? errors;

  Map? extensions;

  CartData({
    this.hasCalculatedShipping,
    this.itemsCount,
    this.itemsWeight,
    this.needsPayment,
    this.needsShipping,
    required this.shippingAddress,
    required this.billingAddress,
  });

  factory CartData.fromJson(Map<String, dynamic> json) => _$CartDataFromJson(json);

  Map<String, dynamic> toJson() => _$CartDataToJson(this);

  static List<CartItem>? _fromListItem(dynamic data) {
    List<CartItem> newItems = <CartItem>[];
    if (data is List && data.isNotEmpty == true) {

      newItems = data.map((d) => CartItem.fromJson(d)).toList().cast<CartItem>();
    }
    return newItems;
  }

  static dynamic _toListItem(List<CartItem>? data) {
    List newItems = [];

    if (data == null || data.isNotEmpty != true) return newItems;

    newItems = data.map((d) => d.toJson()).toList();

    return newItems;
  }

  static List<ShippingRate>? _fromShippingRate(List<dynamic>? data) {
    List<ShippingRate> newShippingRate = <ShippingRate>[];

    if (data == null) return newShippingRate;

    newShippingRate = data.map((d) => ShippingRate.fromJson(d)).toList().cast<ShippingRate>();

    return newShippingRate;
  }

  static dynamic _toShippingRate(List<ShippingRate>? data) {
    List newItems = [];

    if (data == null || data.isNotEmpty != true) return newItems;

    newItems = data.map((d) => d.toJson()).toList();

    return newItems;
  }
}

@JsonSerializable()
class ShippingRate {
  @JsonKey(name: 'package_id')
  int? packageId;

  Map<String, dynamic>? destination;

  @JsonKey(name: 'shipping_rates', fromJson: _fromShipItem, toJson: _toShipItem)
  List<ShipItem>? shipItem;

  String? name;

  ShippingRate({this.packageId, this.name, this.destination, this.shipItem});
  factory ShippingRate.fromJson(Map<String, dynamic> json) => _$ShippingRateFromJson(json);

  Map<String, dynamic> toJson() => _$ShippingRateToJson(this);

  static List<ShipItem>? _fromShipItem(dynamic data) {
    List<ShipItem> shipItems = <ShipItem>[];

    if (data is List && data.isNotEmpty) {
      shipItems = data.map((d) => ShipItem.fromJson(d)).toList().cast<ShipItem>();
    }

    return shipItems;
  }

  static dynamic _toShipItem(List<ShipItem>? data) {
    List newItems = [];

    if (data == null || data.isNotEmpty != true) return newItems;

    newItems = data.map((d) => d.toJson()).toList();

    return newItems;
  }
}

@JsonSerializable()
class CartItem {
  String? key;

  int? id;

  int? quantity;

  @JsonKey(name: 'quantity_limits', toJson: _toQuantity)
  QuantityLimit? quantityLimit;

  String? name;

  List<Map<String, dynamic>>? images;

  List<Map<String, dynamic>>? variation;

  @JsonKey(name: 'item_data')
  List<Map<String, dynamic>>? itemData;

  Map<String, dynamic>? prices;

  CartItem({
    this.key,
    this.id,
    this.quantity,
    this.quantityLimit,
    this.name,
    this.images,
    this.prices,
    this.variation,
    this.itemData,
  });

  factory CartItem.fromJson(Map<String, dynamic> json) => _$CartItemFromJson(json);

  Map<String, dynamic> toJson() => _$CartItemToJson(this);

  static dynamic _toQuantity(QuantityLimit? data) {
    return data?.toJson();
  }
}

@JsonSerializable()
class ShipItem {
  @JsonKey(name: 'rate_id')
  String? rateId;
  String? name;
  String? description;
  @JsonKey(name: 'delivery_time')
  String? deliveryTime;
  String? price;
  String? taxes;
  @JsonKey(name: 'method_id')
  String? methodId;
  bool? selected;
  @JsonKey(name: 'currency_code')
  String? currencyCode;
  @JsonKey(name: 'currency_symbol')
  String? currencySymbol;
  ShipItem(
      {this.rateId,
      this.name,
      this.deliveryTime,
      this.currencyCode,
      this.currencySymbol,
      this.description,
      this.methodId,
      this.price,
      this.taxes,
      this.selected});
  factory ShipItem.fromJson(Map<String, dynamic> json) => _$ShipItemFromJson(json);

  Map<String, dynamic> toJson() => _$ShipItemToJson(this);
}

@JsonSerializable()
class QuantityLimit {
  @JsonKey(defaultValue: 1)
  int minimum;

  @JsonKey()
  int? maximum;

  @JsonKey(name: "multiple_of", defaultValue: 1,)
  int step;

  QuantityLimit({
    required this.minimum,
    this.maximum,
    required this.step,
  });
  factory QuantityLimit.fromJson(Map<String, dynamic> json) => _$QuantityLimitFromJson(json);

  Map<String, dynamic> toJson() => _$QuantityLimitToJson(this);
}
