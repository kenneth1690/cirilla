import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'dart:convert' as convert;
import 'package:hyperpay_gateway/utils/helper.dart';
import 'dart:math';
class HyperpayServices {
  Future<Map<String, dynamic>> postCheckoutId({
    required Map<String, dynamic> settings,
    required String amount,
    required String currency,
    bool testMode = false,
    required Map<String, dynamic> checkoutData,
  }) async {
    
    String? entityId = getData(settings, ['entityId', 'value'], "");
    String amountDouble = double.parse(amount).toStringAsFixed(2);
    String? payType = getData(settings, ['trans_type', 'value'], "DB");
    
    String test = "https://test.oppwa.com";
    String live = "https://oppwa.com";
    
    String baseUrl = testMode ? test : live;

    int intValue = Random().nextInt(88888888) + 11111111;

    try {
      Uri url = Uri.parse("$baseUrl/v1/checkouts");
      debugPrint('uri: $url');
      final Response response = await http.post(
        url,
        headers: {"Authorization": "Bearer ${settings['accesstoken']['value']}"},
        body: {
          "entityId": entityId,
          "amount": amountDouble,
          "currency": currency,
          "paymentType": payType,
          "merchantTransactionId": "${checkoutData["order_id"]}I$intValue",
          "customer.email": getData(checkoutData, ["billing_address", "email"], ""),
          "notificationUrl": checkoutData['payment_result']['redirect_url'],
          "customParameters[bill_number]": "${checkoutData["order_id"]}I$intValue",
          "customer.givenName": getData(checkoutData, ["billing_address", "last_name"], ""),
          "customer.surname": getData(checkoutData, ["billing_address", "first_name"], ""),
          "billing.street1": getData(checkoutData, ["billing_address", "address_1"], ""),
          "billing.city": getData(checkoutData, ["billing_address", "city"], ""),
          "billing.state": getData(checkoutData, ["billing_address", "state"], ""),
          "billing.country": getData(checkoutData, ["billing_address", "country"], ""),
          "billing.postcode": getData(checkoutData, ["billing_address", "postcode"], "12345"),
          "shipping.postcode": getData(checkoutData, ["shipping_address", "postcode"], "12345"),
          "shipping.street1": getData(checkoutData, ["shipping_address", "address_1"], ""),
          "shipping.city": getData(checkoutData, ["shipping_address", "city"], ""),
          "shipping.state": getData(checkoutData, ["shipping_address", "state"], ""),
          "shipping.country": getData(checkoutData, ["shipping_address", "country"], ""),
          "customParameters[branch_id]": "1",
          "customParameters[teller_id]": "1",
          "customParameters[device_id]": "1",
          "customParameters[plugin]": "wordpress",
        },
      );
      return convert.jsonDecode(response.body);
    } catch (e) {
      rethrow;
    }
  }
}
