import 'package:cirilla/models/auth/user.dart';
import 'package:cirilla/store/auth/auth_store.dart';
import 'package:cirilla/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/product/product.dart';

int? b2bkingFilterQuantity(BuildContext context, int? value, Product product, String type) {
  AuthStore authStore = Provider.of<AuthStore>(context, listen: false);
  List<Map<String, dynamic>>? data = product.metaData;

  UserOptions? userOptions = authStore.user?.options;

  if (data == null) {
    return value;
  }

  Map<String, dynamic> metaDataRegular = data.firstWhere(
        (e) => e['key'] == 'b2bking_quantity_product_${type}_b2c',
    orElse: () => {'value': ''},
  );

  int? newValue = ConvertData.stringToIntCanBeNull(metaDataRegular["value"], value);

  if (userOptions == null || userOptions.b2bkingCustomerGroupId == '') {
    return newValue;
  }

  Map<String, dynamic> metaDataGroup = data.firstWhere(
    (e) => e['key'] == 'b2bking_quantity_product_${type}_${userOptions.b2bkingCustomerGroupId}',
    orElse: () => {'value': ''},
  );
  return ConvertData.stringToIntCanBeNull(metaDataGroup['value'], newValue);
}