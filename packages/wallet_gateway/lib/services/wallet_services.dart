import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'dart:convert' as convert;

class WalletServices {

  Future<String> getCurrentBalance(String baseUrl, String consumerKey, String consumerSecret, String uerId) async {
    try {
      
      String getAmountBalance = "/wc/v2/wallet/balance/$uerId";

      String queryParameters = "consumer_key=$consumerKey&consumer_secret=$consumerSecret";

      Uri url = Uri.parse("$baseUrl$getAmountBalance?$queryParameters");

      debugPrint('uri: $url');
      
      final Response response = await http.get(url);
      
      return convert.jsonDecode(response.body);
    
    } catch (e) {
      rethrow;
    }
  }
}
