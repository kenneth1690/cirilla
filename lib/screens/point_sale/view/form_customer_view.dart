import 'package:cirilla/mixins/mixins.dart';
import 'package:cirilla/models/address/address.dart';
import 'package:cirilla/models/models.dart';
import 'package:cirilla/screens/profile/widgets/address_field_form3.dart';
import 'package:cirilla/screens/profile/widgets/fields/fields.dart';
import 'package:cirilla/screens/profile/widgets/fields/loading_field_address.dart';
import 'package:cirilla/store/store.dart';
import 'package:cirilla/types/types.dart';
import 'package:cirilla/utils/address.dart';
import 'package:cirilla/utils/utils.dart';
import 'package:cirilla/widgets/widgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/provider.dart';

class FormCustomerView extends StatefulWidget {
  final Map<String, dynamic>? data;
  final Customer? customer;
  final ValueChanged<Customer> onSuccess;

  const FormCustomerView({
    super.key,
    required this.onSuccess,
    this.data,
    this.customer,
  });

  @override
  State<FormCustomerView> createState() => _FormCustomerViewState();
}

class _FormCustomerViewState extends State<FormCustomerView> with AppBarMixin, SnackMixin, LoadingMixin {
  final _formAddressKey = GlobalKey<FormState>();

  late SettingStore _settingStore;
  late AddressDataStore _addressDataStore;

  late Map<String, dynamic> _address;
  String _username = "";

  bool _enableUsername = true;

  bool _loading = false;

  @override
  void initState() {
    _settingStore = Provider.of<SettingStore>(context, listen: false);

    _address = {
      ...getBillingCustomer(widget.customer),
      ...?widget.data,
    };

    _addressDataStore = AddressDataStore(_settingStore.requestHelper)
      ..getAddressData(queryParameters: {
        "country": _address["country"],
        'lang': _settingStore.locale,
      });
    super.initState();
  }

  @override
  void dispose() {
    _addressDataStore.dispose();
    super.dispose();
  }

  void onSave() {
    Map<String, dynamic> address = {};
    List metaData = [];

    for (var key in _address.keys) {
      if (key.contains('wooccm')) {
        metaData.add({
          "key": "billing_$key",
          "value": _address[key],
        });
      } else {
        address[key] = _address[key];
      }
    }

    Map<String, dynamic> data = {
      "email": address["email"] ?? "",
      "first_name": address["first_name"] ?? "",
      "last_name": address["last_name"] ?? "",
      "billing": address,
      "shipping": address,
      "meta_data": metaData,
    };
    if (widget.customer != null) {
      if (widget.customer?.id != null) {
        updateCustomer(data);
      } else {
        widget.onSuccess(Customer.fromJson(data));
      }
      return;
    }
    if (_enableUsername) {
      addCustomer(data);
    } else {
      widget.onSuccess(Customer.fromJson(data));
    }
  }

  void addCustomer(data) async {
    try {
      setState(() {
        _loading = true;
      });
      Customer customer = await _settingStore.requestHelper.createCustomer(
        data: {
          ...data,
          "username": _username,
          "password": StringGenerate.uuid(20),
        },
      );
      setState(() {
        _loading = false;
      });
      widget.onSuccess(customer);
    } catch (e) {
      if (mounted) showError(context, e);
      setState(() {
        _loading = false;
      });
    }
  }

  void updateCustomer(data) async {
    try {
      setState(() {
        _loading = true;
      });
      Customer customer = await _settingStore.requestHelper.updateCustomer(
        userId: widget.customer?.id?.toString(),
        data: data,
      );
      setState(() {
        _loading = false;
      });
      widget.onSuccess(customer);
    } catch (e) {
      if (mounted) showError(context, e);
      setState(() {
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    TranslateType translate = AppLocalizations.of(context)!.translate;

    bool update = widget.customer != null;

    Map<String, dynamic> fieldUsername = {
      "label": translate("point_sale_username"),
      "required": true,
      "class": ["form-row-wide"],
      "priority": 0,
      "key": "billing_username",
      "name": "username",
      "type": "text",
      "default": "",
      "position": "form-row-wide",
    };

    return Observer(
      builder: (_) {
        Map fields = _addressDataStore.address?.billing ?? {};
        if (_addressDataStore.address?.country != null && _address["country"] == null) {
          /// Update only if this widget initialized.
          WidgetsBinding.instance.addPostFrameCallback((_) {
            setState(() {
              _address = {
                ..._address,
                "country": _addressDataStore.address?.country ?? "",
              };
            });
          });
        }

        return Form(
          key: _formAddressKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (_addressDataStore.loading && fields.isEmpty)
                const LoadingFieldAddress(count: 11)
              else
                FormAddressView(
                  address: _address,
                  addressFields: _addressDataStore.address?.billing ?? {},
                  addressDataStore: _addressDataStore,
                  locale: _settingStore.locale,
                  keyForm: "billing",
                  onChangeAddress: (value) => setState(() {
                    _address = value;
                  }),
                  heading: !update
                      ? Column(
                          children: [
                            CirillaTile(
                              title: Text(translate("point_sale_save_customer")),
                              trailing: CupertinoSwitch(
                                value: _enableUsername,
                                onChanged: (value) => setState(() {
                                  _enableUsername = value;
                                }),
                              ),
                              isChevron: false,
                            ),
                            if (_enableUsername) ...[
                              const SizedBox(height: 16),
                              AddressFieldText(
                                value: _username,
                                field: fieldUsername,
                                onChanged: (value) => setState(() {
                                  _username = value;
                                }),
                              )
                            ],
                            const SizedBox(height: 16),
                          ],
                        )
                      : null,
                ),
              const SizedBox(height: 24),
              Align(
                alignment: Alignment.center,
                child: SizedBox(
                  width: 200,
                  child: ElevatedButton(
                    onPressed: () {
                      if (!_loading) {
                        bool isValid = _formAddressKey.currentState!.validate();
                        if (isValid) {
                          onSave();
                        }
                      }
                    },
                    child: _loading
                        ? entryLoading(context, color: theme.colorScheme.onPrimary)
                        : Text(update ? translate("point_sale_update_customer") : translate("point_sale_add_customer")),
                  ),
                ),
              )
            ],
          ),
        );
      },
    );
  }
}

class FormAddressView extends StatelessWidget {
  final Widget? heading;
  final Map<String, dynamic>? address;
  final Map<String, dynamic> addressFields;
  final AddressDataStore addressDataStore;
  final String locale;
  final String keyForm;
  final ValueChanged<Map<String, dynamic>> onChangeAddress;

  const FormAddressView({
    Key? key,
    this.heading,
    this.address,
    this.addressFields = const {},
    this.locale = 'en',
    this.keyForm = 'billing',
    required this.addressDataStore,
    required this.onChangeAddress,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (heading != null) heading!,
        AddressFieldForm3(
          keyForm: keyForm,
          data: address,
          addressData: addressDataStore.address ?? AddressData(),
          onChanged: onChangeAddress,
          onGetAddressData: (String country) {
            addressDataStore.getAddressData(queryParameters: {
              'country': country,
              'lang': locale,
            });
          },
          formType: keyForm == 'shipping' ? FieldFormType.shipping : FieldFormType.billing,
        ),
      ],
    );
  }
}
