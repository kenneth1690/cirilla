class YithBadgeAdvancedValueModel {
  final String amount;
  final String percentage;

  YithBadgeAdvancedValueModel({
    required this.amount,
    required this.percentage,
  });

  factory YithBadgeAdvancedValueModel.fromJson(Map<String, dynamic> json) {
    Map<String, dynamic> newJson = {
      "amount": json["amount"] is String ? json["amount"] : "",
      "percentage": json["percentage"] is String ? json["percentage"] : "",
    };
    return _$YithBadgeAdvancedValueModelFromJson(newJson);
  }

  Map<String, dynamic> toJson() => _$YithBadgeAdvancedValueModelToJson(this);

  String getString(String type) {
    switch(type) {
      case "percentage":
        return "-${this.percentage}";
      default:
        return "-${this.amount}";
    }
  }

}

YithBadgeAdvancedValueModel _$YithBadgeAdvancedValueModelFromJson(Map<String, dynamic> json) => YithBadgeAdvancedValueModel(
  amount: json["amount"] as String,
  percentage: json["percentage"] as String,
);

Map<String, dynamic> _$YithBadgeAdvancedValueModelToJson(YithBadgeAdvancedValueModel instance) => <String, dynamic>{
  "amount": instance.amount,
  "percentage": instance.percentage,
};


