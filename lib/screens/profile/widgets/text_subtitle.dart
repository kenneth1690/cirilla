import 'package:cirilla/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:cirilla/store/store.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/provider.dart';

class TextSubtitle extends StatefulWidget {
  final String text;
  final TextStyle? style;
  final TextAlign? textAlign;

  const TextSubtitle({
    Key? key,
    required this.text,
    this.style,
    this.textAlign,
  }) : super(key: key);

  @override
  State<TextSubtitle> createState() => _TextSubtitleState();
}

class _TextSubtitleState extends State<TextSubtitle> {
  late AppStore _appStore;
  late AuthStore _authStore;
  late WalletStore _walletStore;

  @override
  void didChangeDependencies() {
    _appStore = Provider.of<AppStore>(context);
    _authStore = Provider.of<AuthStore>(context);
    SettingStore settingStore = Provider.of<SettingStore>(context);

    String? key = StringGenerate.getWalletKeyStore(
      'wallet_balance',
      userId: _authStore.user?.id,
    );

    if (widget.text.contains("{amount_balance}")) {
      // Add store to list store
      if (_appStore.getStoreByKey(key) == null) {
        WalletStore store = WalletStore(settingStore.requestHelper, _authStore, key: key)..getAmountBalance();
        _appStore.addStore(store);
        _walletStore = store;
      } else {
        _walletStore = _appStore.getStoreByKey(key)..getAmountBalance();
      }
    } else {
      _walletStore = WalletStore(settingStore.requestHelper, _authStore);
    }

    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Observer(
      builder: (_) {
        return Text(
          TextDynamic.getTextDynamic(context, text: widget.text, options: {
            "amount_balance": formatCurrency(context, price: '${_walletStore.amountBalance}'),
          }),
          style: widget.style,
          textAlign: widget.textAlign,
        );
      },
    );
  }
}
