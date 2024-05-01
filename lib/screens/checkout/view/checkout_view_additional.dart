import 'package:cirilla/constants/styles.dart';
import 'package:cirilla/mixins/mixins.dart';
import 'package:cirilla/models/address/address.dart';
import 'package:cirilla/screens/profile/widgets/address_field_form3.dart';
import 'package:cirilla/screens/profile/widgets/fields/loading_field_address.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:cirilla/store/store.dart';
import 'package:provider/provider.dart';

class CheckoutViewAdditional extends StatefulWidget {
  final Map<String, dynamic> data;
  final ValueChanged<Map<String, dynamic>> onChange;

  const CheckoutViewAdditional({
    Key? key,
    required this.data,
    required this.onChange,
  }) : super(key: key);

  @override
  State<CheckoutViewAdditional> createState() => _CheckoutViewAdditionalState();
}

class _CheckoutViewAdditionalState extends State<CheckoutViewAdditional> with Utility {
  late SettingStore _settingStore;
  late AddressDataStore _addressDataStore;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _settingStore = Provider.of<SettingStore>(context);

    _addressDataStore = AddressDataStore(_settingStore.requestHelper)
      ..getAddressData(queryParameters: {
        'lang': _settingStore.locale,
      });
  }

  @override
  Widget build(BuildContext context) {

    return Observer(
      builder: (_) {
        Map<String, dynamic>? addressFields = _addressDataStore.address?.additional;
        bool loading = _addressDataStore.loading;

        if (!loading && addressFields?.isNotEmpty != true) {
          return Container();
        }

        return Padding(
          padding: const EdgeInsets.symmetric(vertical: itemPaddingMedium),
          child: loading
              ? const LoadingFieldAddress(count: 5)
              : AddressFieldForm3(
                  keyForm: "additional",
                  data: widget.data,
                  addressData: _addressDataStore.address ?? AddressData(),
                  onChanged: widget.onChange,
                  onGetAddressData: (_) {},
                  formType: FieldFormType.additional,
                ),
        );
      },
    );
  }
}
