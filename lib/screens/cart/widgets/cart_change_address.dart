import 'package:cirilla/constants/constants.dart';
import 'package:cirilla/mixins/mixins.dart';
import 'package:cirilla/screens/profile/address_billing.dart';
import 'package:cirilla/screens/profile/widgets/fields/loading_field_address.dart';
import 'package:feather_icons/feather_icons.dart';
import 'package:flutter/material.dart';
import 'package:cirilla/store/store.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/provider.dart';
import 'package:cirilla/types/types.dart';
import 'package:cirilla/utils/app_localization.dart';
import 'package:ui/notification/notification_screen.dart';

List<String> _showFields = ['country', 'state', 'postcode', 'city'];

class CartChangeAddress extends StatefulWidget {
  final int? index;
  const CartChangeAddress({Key? key, this.index}) : super(key: key);

  @override
  State<CartChangeAddress> createState() => _CartChangeAddressState();
}

class _CartChangeAddressState extends State<CartChangeAddress> with SnackMixin, AppBarMixin {
  late SettingStore _settingStore;
  late AddressDataStore _addressDataStore;
  CartStore? _cartStore;

  @override
  void initState() {
    _settingStore = Provider.of<SettingStore>(context, listen: false);
    _cartStore = Provider.of<AuthStore>(context, listen: false).cartStore;

    Map? destination = _cartStore?.cartData?.shippingRate?.elementAt(widget.index!).destination;
    String country = get(destination, ['country'], '');
    _addressDataStore = AddressDataStore(_settingStore.requestHelper)
      ..getAddressData(
        queryParameters: {
          'country': country,
          'lang': _settingStore.locale,
        },
      );
    super.initState();
  }

  postAddressCart(Map data) async {
    TranslateType translate = AppLocalizations.of(context)!.translate;
    try {
      await _cartStore!.updateCustomerCart(data: {'shipping_address': data, 'billing_address': data});
      if (mounted) showSuccess(context, translate('address_shipping_success'));
      if (mounted) Navigator.pop(context);
    } catch (e) {
      if (mounted) showError(context, e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Observer(
      builder: (_) {
        Map? destination = _cartStore?.cartData?.shippingRate?.elementAt(widget.index!).destination;

        TranslateType translate = AppLocalizations.of(context)!.translate;

        Map<String, dynamic>? addressFields = _addressDataStore.address?.shipping;
        bool loading = _addressDataStore.loading != false && addressFields?.isNotEmpty != true;
        return SizedBox(
          height: MediaQuery.of(context).size.height - 140,
          child: Scaffold(
            backgroundColor: Colors.transparent,
            body: loading
                ? Padding(
                    padding: const EdgeInsets.fromLTRB(
                      layoutPadding,
                      itemPaddingMedium,
                      layoutPadding,
                      itemPaddingLarge,
                    ),
                    child: Column(
                      children: [
                        Text(
                          translate('address_change'),
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        LoadingFieldAddress(count: _showFields.length),
                      ],
                    ),
                  )
                : addressFields?.isNotEmpty != true
                    ? _buildaddressEmpty()
                    : AddressChild(
                        address: destination as Map<String, dynamic>?,
                        addressDataStore: _addressDataStore,
                        include: _showFields,
                        onSave: postAddressCart,
                        titleModal: Text(
                          translate('address_change'),
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        note: false,
                        borderFields: true,
                        locale: _settingStore.locale,
                        keyForm: 'shipping',
                      ),
          ),
        );
      },
    );
  }

  Widget _buildaddressEmpty() {
    TranslateType translate = AppLocalizations.of(context)!.translate;
    return NotificationScreen(
      title: Text(
        translate('address_change'),
        style: Theme.of(context).textTheme.titleLarge,
        textAlign: TextAlign.center,
      ),
      content: Text(translate('address_empty_shipping'), style: Theme.of(context).textTheme.bodyMedium),
      iconData: FeatherIcons.frown,
      isButton: false,
    );
  }
}
