import 'package:cirilla/constants/styles.dart';
import 'package:cirilla/mixins/mixins.dart';
import 'package:cirilla/models/address/address.dart';
import 'package:cirilla/models/models.dart';
import 'package:cirilla/screens/profile/widgets/address_field_form3.dart';
import 'package:cirilla/screens/profile/widgets/fields/loading_field_address.dart';
import 'package:cirilla/types/types.dart';
import 'package:cirilla/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:cirilla/store/store.dart';
import 'package:provider/provider.dart';

import 'checkout_address_book.dart';

class CheckoutViewShippingAddress extends StatefulWidget {
  final CartStore cartStore;

  const CheckoutViewShippingAddress({
    Key? key,
    required this.cartStore,
  }) : super(key: key);

  @override
  State<CheckoutViewShippingAddress> createState() => _CheckoutViewShippingAddressState();
}

class _CheckoutViewShippingAddressState extends State<CheckoutViewShippingAddress> with Utility {
  late SettingStore _settingStore;
  late AuthStore _authStore;
  late AddressDataStore _addressDataStore;
  AddressBookStore? _addressBookStore;
  String _name = 'shipping';

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _settingStore = Provider.of<SettingStore>(context);
    _authStore = Provider.of<AuthStore>(context);

    WidgetConfig? widgetConfig = _settingStore.data?.screens?['profile']?.widgets?['profilePage']!;
    Map<String, dynamic>? fields = widgetConfig?.fields;

    bool enableAddressBook = get(fields, ['enableAddressBook'], false);

    if (enableAddressBook && _authStore.isLogin) {
      _addressBookStore = AddressBookStore(_settingStore.requestHelper)..getAddressBook();
    }

    Map<String, dynamic> shipping = widget.cartStore.cartData?.shippingAddress ?? {};
    String country = get(shipping, ['country'], '');
    _addressDataStore = AddressDataStore(_settingStore.requestHelper)
      ..getAddressData(queryParameters: {
        'country': country,
        'lang': _settingStore.locale,
      });
  }

  void onChanged(Map<String, dynamic> value, [String? name]) {
    if (name != null) {
      setState(() {
        _name = name;
      });
    }

    widget.cartStore.checkoutStore.changeAddress(
        billing: {
          ...?widget.cartStore.cartData?.billingAddress,
          ...widget.cartStore.checkoutStore.billingAddress,
        },
        shipping: value,
    );
  }

  @override
  Widget build(BuildContext context) {
    TranslateType translate = AppLocalizations.of(context)!.translate;
    return Observer(
      builder: (_) {
        if (widget.cartStore.checkoutStore.shipToDifferentAddress) {
          Map<String, dynamic> shipping = {
            ...?widget.cartStore.cartData?.shippingAddress,
            ...widget.cartStore.checkoutStore.shippingAddress,
          };
          Map<String, dynamic>? addressFields = _addressDataStore.address?.shipping;
          bool loading = _addressDataStore.loading != false && addressFields?.isNotEmpty != true;

          if (shipping["country"] is String && shipping["country"] != "" && !_addressDataStore.loading && _addressDataStore.address?.country != null && shipping["country"] != _addressDataStore.address?.country) {
            /// Update only if this widget initialized.
            WidgetsBinding.instance.addPostFrameCallback((_) {
              _addressDataStore.getAddressData(queryParameters: {
                'country': shipping["country"],
                'lang': _settingStore.locale,
              });
            });
          }

          return Padding(
            padding: paddingVerticalMedium,
            child: Column(
              children: [
                if (_addressBookStore != null && _addressBookStore?.addressBook?.shippingEnable == true) ...[
                  if (_addressBookStore!.loading != true)
                    CheckoutAddressBook(
                      valueSelected: _name,
                      data: _addressBookStore?.addressBook ?? AddressBook(),
                      onChanged: onChanged,
                      type: 'shipping',
                    )
                  else
                    const LoadingFieldAddressItem(width: double.infinity),
                  const SizedBox(height: 15),
                ],
                loading
                    ? const LoadingFieldAddress()
                    : addressFields?.isNotEmpty == true
                        ? AddressFieldForm3(
                            keyForm: _name,
                            data: shipping,
                            addressData: _addressDataStore.address ?? AddressData(),
                            onChanged: onChanged,
                            onGetAddressData: (String country) {},
                            formType: FieldFormType.checkoutShipping,
                          )
                        : Center(
                            child: Text(translate('address_empty_shipping')),
                          ),
              ],
            ),
          );
        }

        return Container();
      },
    );
  }
}
