import 'package:cirilla/mixins/mixins.dart';
import 'package:cirilla/models/models.dart';

Map<String, dynamic> getBillingCustomer(Customer? customer) {
  if (customer == null) {
    return {};
  }
  Map<String, dynamic> data = customer.billing ?? {};
  if (customer.metaData?.isNotEmpty == true) {
    for (var meta in customer.metaData!) {
      String keyElement = get(meta, ['key'], '');
      if (keyElement.contains('billing_wooccm')) {
        dynamic valueElement = meta['value'];
        String nameData = keyElement.replaceFirst('billing_', '');
        data[nameData] = valueElement;
      }
    }
  }
  return data;
}