import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tabby_flutter_inapp_sdk/tabby_flutter_inapp_sdk.dart';
import 'package:flutter/scheduler.dart';
import 'package:tabby_gateway/utils/helper.dart';
import 'tabby_checkout.dart';
class TabbyScreen extends StatefulWidget {
  final Map<String, dynamic> billing;
  final String amount;
  final String currency;
  final Function(dynamic data) callback;
  final Future Function(List p1) checkout;
  final Widget Function(String url, BuildContext context, {String Function(String url)? customHandle}) webViewGateway;
  const TabbyScreen({
    Key? key,
    required this.billing,
    required this.amount,
    required this.currency,
    required this.callback,
    required this.checkout,
    required this.webViewGateway,
  }) : super(key: key);

  @override
  State<TabbyScreen> createState() => _TabbyScreenState();
}

class _TabbyScreenState extends State<TabbyScreen> {
  TabbySession? session;
  bool _loading = false;
  Lang? lang;

  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((_) => getCurrentLang());
  }

  void getCurrentLang() {
    final myLocale = Localizations.localeOf(context);
    setState(() {
      lang = myLocale.languageCode == 'ar' ? Lang.ar : Lang.en;
    });
  }

  void setLoading(bool isLoading) {
    setState(() {
      _loading = isLoading;
    });
  }

  Currency currency() {
    switch (widget.currency) {
      case "SAR":
        return Currency.sar;
      case "BDH":
        return Currency.bdh;
      case "QAR":
        return Currency.qar;
      case "KWD":
        return Currency.kwd;
      default:
        return Currency.aed;
    }
  }

  void openTabbyCheckout() async {
    dynamic checkoutData;
    try {
      setLoading(true);
      checkoutData = await widget.checkout([]);
      setLoading(false);
    } catch (e) {
      setLoading(false);
      widget.callback(e);
      return;
    }
    String url = getData(checkoutData, ['payment_result', 'redirect_url'], "");
    if (mounted && url != "") {
      final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TabbyCheckout(
            webViewGateway: widget.webViewGateway,
            url: url,
        ),
        ),
      );
      if (result != null && mounted) {
        Navigator.of(context).pop(result);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    String amountDouble = double.parse(widget.amount).toStringAsFixed(currency().decimals);
    return Stack(
      children: [
        Scaffold(
          appBar: AppBar(
            leading: InkWell(
              onTap: () => Navigator.of(context).pop(),
              child: const Icon(Icons.chevron_left_rounded, size: 30),
            ),
            title: const Text('Tabby Payment'),
            centerTitle: true,
            elevation: 0,
          ),
          body: Visibility(
            visible: lang != null,
            child: Center(
              child: Column(
                children: <Widget>[
                  const SizedBox(height: 24),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: TabbyPresentationSnippet(
                      price: amountDouble,
                      currency: currency(),
                      lang: lang ?? Lang.en,
                    ),
                  ),
                  const SizedBox(height: 24),
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: TabbyCheckoutSnippet(
                      price: amountDouble,
                      currency: currency(),
                      lang: lang ?? Lang.en,
                    ),
                  ),
                  Text(
                    '$amountDouble ${widget.currency}',
                    style: Theme.of(context).textTheme.titleLarge,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: 200,
                    height: 44,
                    child: ElevatedButton(
                      onPressed: openTabbyCheckout,
                      child: const Text('Payment'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        if (_loading)
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
