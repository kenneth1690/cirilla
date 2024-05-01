import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:payment_base/payment_base.dart';
import 'package:wallet_gateway/services/wallet_services.dart';

class WalletNativeScreen extends StatefulWidget {
  final String amount;
  final String restUrl;
  final String consumerKey;
  final String consumerSecret;
  final String userId;
  final Function(BuildContext context, {String? price, String? currency, String? symbol, String? pattern})
      formatCurrency;
  final Future Function(List p1) checkout;
  final Function(dynamic data) callback;
  const WalletNativeScreen({
    this.amount = '0',
    required this.restUrl,
    required this.consumerKey,
    required this.consumerSecret,
    required this.userId,
    required this.formatCurrency,
    required this.checkout,
    required this.callback,
    super.key,
  });
  @override
  State<WalletNativeScreen> createState() => WalletNativeScreenState();
}

class WalletNativeScreenState extends State<WalletNativeScreen> {
  late WalletServices walletServices;
  String currentBalance = '0';
  bool _loadingPay = false;
  bool _obscureText = true;
  @override
  void didChangeDependencies() {
    walletServices = WalletServices();
    _getCurrentBalance();
    super.didChangeDependencies();
  }

  _getCurrentBalance() async {
    try {
      setState(() {
        _loadingPay = true;
      });
      currentBalance = await walletServices.getCurrentBalance(
        widget.restUrl,
        widget.consumerKey,
        widget.consumerSecret,
        widget.userId,
      );
      setState(() {
        _loadingPay = false;
      });
    } catch (e) {
      widget.callback(
        PaymentException(
          error: 'Please double check the information "restUrl, consumerKey, consumerSecret"',
        ),
      );
      setState(() {
        _loadingPay = false;
      });
    }
  }

  _onPayment() async {
    double balance = double.parse(currentBalance);
    double amount = double.parse(widget.amount);
    if (balance >= amount) {
      try {
        setState(() {
          _loadingPay = true;
        });
        dynamic data = await widget.checkout([]);
        setState(() {
          _loadingPay = false;
        });
        if (data != null) {
          if (mounted) Navigator.of(context).pop();
          widget.callback("");
        }
      } catch (e) {
        widget.callback(e);
        setState(() {
          _loadingPay = false;
        });
      }
    } else {
      widget.callback(
        PaymentException(
          error:
              'You do not have enough money in your balance.Make a deposit to your Wallet account or choose another payment option.',
        ),
      );
    }
  }



  void _updateObscure() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  @override
  Widget build(BuildContext context) {
    String balance = widget.formatCurrency(context, price: currentBalance);
    String amount = widget.formatCurrency(context, price: widget.amount);
    ThemeData theme = Theme.of(context);
    TextTheme textTheme = theme.textTheme;
    return Stack(
      children: [
        Scaffold(
          appBar: AppBar(
            title: const Text('Wallet Payment'),
            elevation: 0,
            leading: IconButton(
              tooltip: 'Back',
              onPressed: () => Navigator.of(context).pop(),
              icon: const Icon(Icons.arrow_back_ios_rounded, size: 22),
            ),
          ),
          body: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    height: _obscureText ? 40 : null,
                    child: Center(
                      child: Text(
                        _obscureText ? "*** *** ***" : balance,
                        style: textTheme.headlineMedium,
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: _updateObscure,
                    splashRadius: 20,
                    icon: Icon(
                      _obscureText ? Icons.visibility_outlined : Icons.visibility_off_outlined,
                      size: 22,
                      color: textTheme.headlineMedium!.color,
                    ),
                  ),
                ],
              ),
              Text('You Current Wallet Balance', style: textTheme.bodySmall),
              ListTile(
                title: Text('Total Amount Due:', style: textTheme.titleMedium!.copyWith(fontSize: 20)),
                trailing: Text(amount, style: textTheme.titleMedium!.copyWith(fontSize: 20)),
              ),
            ],
          ),
          bottomNavigationBar: Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
            child: SizedBox(
              height: 48,
              child: ElevatedButton(
                onPressed: _onPayment,
                child: const Text('Pay now'),
              ),
            ),
          ),
        ),
        if (_loadingPay)
          Container(
            color: Colors.black.withOpacity(0.3),
            child: const Center(
              child: CupertinoActivityIndicator(),
            ),
          )
      ],
    );
  }
}
