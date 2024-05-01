import 'package:cirilla/screens/checkout/gateway/gateway.dart';
import 'package:stripe_gateway/stripe_gateway_native.dart';
import 'package:paypal_gateway/paypal_gateway_web.dart';
import 'package:payment_base/payment_base.dart';

final Map<String, PaymentBase> methods = {
  ChequeGateway.key: ChequeGateway(),
  CodGateway.key: CodGateway(),
  StripeGatewayNative.key: StripeGatewayNative(),
  BacsGateway.key: BacsGateway(),
  PayPalGatewayWeb.key: PayPalGatewayWeb(),
};
