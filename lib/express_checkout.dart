/// Express Checkout Package
export 'package:cirilla/widgets/cirilla_express_checkout_dev.dart';

/// Apple Pay Config
///
class ApplePayConfig {
  /// Merchant identifier
  static const String merchantIdentifier = 'merchant.speedypay.appcheap.io';

  /// Display name
  static const String displayName = 'Example Merchant';

  /// Country code
  static const String countryCode = 'US';

  /// Currency code
  static const String currencyCode = 'USD';

  /// Payment method [stripe, hyperpay_applepay]
  static const String paymentMethod = 'stripe';
}

/// Google Pay Config
///
class GooglePayConfig {
  /// Environment (TEST, PRODUCTION)
  static const String environment = 'TEST';

  /// Merchant id
  static const String merchantId = 'BCR2DN4TZ33YVJDJ';

  /// Merchant name
  static const String merchantName = 'Example Merchant Name';

  /// Country code
  static const String countryCode = 'US';

  /// Currency code
  static const String currencyCode = 'USD';

  /// Gateway [stripe, hyperpay_applepay]
  static const String gateway = 'stripe';

  /// Gateway params
  static const Map<String, String> gatewayParams = {
    "gateway": "stripe",
    "stripe:version": "2018-10-31",
    "stripe:publishableKey": "pk_test_51O4yLqIWWYQpCPjUyhQSNHXAognZmBExgLhqvEFrx3biRoqIJCmfB31B9u4sZpgcwoZKgXk0poOt6O8kKv0bWFUq00M3N36hOE",
  };
}