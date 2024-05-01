import 'dart:async';

import 'package:cirilla/constants/constants.dart';
import 'package:cirilla/mixins/mixins.dart';
import 'package:cirilla/models/address/address.dart';
import 'package:cirilla/models/models.dart';
import 'package:cirilla/store/store.dart';
import 'package:cirilla/types/types.dart';
import 'package:cirilla/utils/utils.dart';
import 'package:feather_icons/feather_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/provider.dart';
import 'package:ui/notification/notification_screen.dart';

import 'widgets/address_field_form3.dart';
import 'widgets/fields/loading_field_address.dart';

class AddressBillingScreen extends StatefulWidget {
  static const String routeName = '/profile/address_billing';

  const AddressBillingScreen({Key? key}) : super(key: key);

  @override
  State<AddressBillingScreen> createState() => _AddressBillingScreenState();
}

class _AddressBillingScreenState extends State<AddressBillingScreen> with SnackMixin, AppBarMixin {
  late AuthStore _authStore;
  late SettingStore _settingStore;
  AddressDataStore? _addressDataStore;
  late CustomerStore _customerStore;
  bool? _loading;

  @override
  void initState() {
    _authStore = Provider.of<AuthStore>(context, listen: false);
    _settingStore = Provider.of<SettingStore>(context, listen: false);

    _customerStore = CustomerStore(_settingStore.requestHelper)
      ..getCustomer(userId: _authStore.user!.id).then(
        (value) {
          String country =
              _customerStore.customer?.billing != null ? get(_customerStore.customer!.billing, ['country'], '') : '';
          _addressDataStore = AddressDataStore(_settingStore.requestHelper)
            ..getAddressData(queryParameters: {
              'country': country,
              'lang': _settingStore.locale,
            });
        },
      );
    super.initState();
  }

  postAddress(Map data) async {
    try {
      setState(() {
        _loading = true;
      });
      TranslateType translate = AppLocalizations.of(context)!.translate;
      List<Map<String, dynamic>> meta = [];

      for (String key in data.keys) {
        if (key.contains('wooccm')) {
          meta.add({
            'key': 'billing_$key',
            'value': data[key],
          });
        }
      }

      await _customerStore.updateCustomer(
        userId: _authStore.user!.id,
        data: {
          'billing': data,
          'meta_data': meta,
        },
      );
      if (mounted) showSuccess(context, translate('address_billing_success'));
      setState(() {
        _loading = false;
      });
    } catch (e) {
      if (mounted) showError(context, e);
      setState(() {
        _loading = false;
      });
    }
  }

  Map<String, dynamic> getAddress(Customer? customer) {
    if (customer == null) {
      return {};
    }
    Map<String, dynamic> data = customer.billing ?? {};
    if (customer.metaData?.isNotEmpty == true) {
      for (var meta in customer.metaData!) {
        String keyElement = get(meta, ['key'], '');
        if (keyElement.contains('billing_wooccm')) {
          dynamic valueElement = meta['value'];
          String nameData = keyElement.replaceFirst('billing_', '');
          data[nameData] = valueElement;
        }
      }
    }
    return data;
  }

  @override
  Widget build(BuildContext context) {
    TranslateType translate = AppLocalizations.of(context)!.translate;
    return Observer(
      builder: (_) {
        bool loadingCustomer = _customerStore.loading;
        Customer? customer = _customerStore.customer;
        bool loading = loadingCustomer ||
            (_addressDataStore?.loading != false && _addressDataStore?.address?.billing?.isNotEmpty != true);

        return Scaffold(
          appBar: baseStyleAppBar(context, title: translate('address_billing')),
          body: loading
              ? const Padding(
                  padding: EdgeInsets.fromLTRB(layoutPadding, itemPaddingMedium, layoutPadding, itemPaddingLarge),
                  child: LoadingFieldAddress(count: 10),
                )
              : _addressDataStore?.address?.billing?.isNotEmpty == true
                  ? AddressChild(
                      address: getAddress(customer),
                      addressDataStore: _addressDataStore,
                      onSave: postAddress,
                      loading: _loading,
                      locale: _settingStore.locale,
                      keyForm: 'billing',
                      countLoading: 10,
                    )
                  : _buildaddressEmpty(),
        );
      },
    );
  }

  Widget _buildaddressEmpty() {
    TranslateType translate = AppLocalizations.of(context)!.translate;
    return NotificationScreen(
      title: Text(
        translate('address_billing'),
        style: Theme.of(context).textTheme.titleLarge,
        textAlign: TextAlign.center,
      ),
      content: Text(translate('address_empty_billing'), style: Theme.of(context).textTheme.bodyMedium),
      iconData: FeatherIcons.frown,
      isButton: false,
    );
  }
}

class AddressChild extends StatefulWidget {
  final Map<String, dynamic>? address;
  final List<String> include;
  final AddressDataStore? addressDataStore;
  final Function(Map<String, dynamic> address) onSave;
  final bool? loading;
  final Widget? titleModal;
  final bool note;
  final bool borderFields;
  final String locale;
  final String keyForm;
  final int countLoading;
  final bool isBooking;

  const AddressChild({
    Key? key,
    this.address,
    this.include = const [],
    this.titleModal,
    this.borderFields = false,
    this.note = true,
    this.addressDataStore,
    required this.onSave,
    this.loading = false,
    this.locale = 'en',
    this.keyForm = 'billing',
    this.countLoading = 8,
    this.isBooking = false,
  }) : super(key: key);

  @override
  State<AddressChild> createState() => _AddressChildState();
}

class _AddressChildState extends State<AddressChild> with LoadingMixin {
  final _formKey = GlobalKey<FormState>();
  Map<String, dynamic> data = {};

  @override
  void didChangeDependencies() {
    if (widget.address != null) {
      setState(() {
        data = widget.address!;
      });
    }
    super.didChangeDependencies();
  }

  void changeValue(Map<String, dynamic> value) {
    setState(() {
      data = {
        ...data,
        ...value,
      };
    });
  }

  Widget buildForm() {
    return Form(
      key: _formKey,
      child: AddressFieldForm3(
        keyForm: widget.keyForm,
        data: data,
        addressData: widget.addressDataStore?.address ?? AddressData(),
        include: widget.include,
        onChanged: changeValue,
        titleModal: widget.titleModal,
        borderFields: widget.borderFields,
        onGetAddressData: (String country) {
          widget.addressDataStore!.getAddressData(queryParameters: {
            'country': country,
            'lang': widget.locale,
          });
        },
        formType: widget.keyForm == 'shipping' ? FieldFormType.shipping : FieldFormType.billing,
        isBooking: widget.isBooking,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    TranslateType translate = AppLocalizations.of(context)!.translate;

    return ListView(
      padding: const EdgeInsets.fromLTRB(layoutPadding, itemPaddingMedium, layoutPadding, itemPaddingLarge),
      children: [
        buildForm(),
        if (widget.note == true) ...[
          const SizedBox(height: itemPaddingMedium),
          Text(translate('address_note'), style: theme.textTheme.bodySmall),
        ],
        const SizedBox(height: itemPaddingLarge),
        SizedBox(
          height: 48,
          child: ElevatedButton(
            onPressed: () {
              if (widget.loading != true && _formKey.currentState!.validate()) {
                FocusManager.instance.primaryFocus?.unfocus();

                Timer.periodic(const Duration(milliseconds: 500), (time) {
                  widget.onSave(data);
                  time.cancel();
                });
              }
            },
            child: widget.loading == true
                ? entryLoading(context, color: theme.colorScheme.onPrimary)
                : Text(
                    widget.note == true ? translate('address_save') : translate('address_update'),
                  ),
          ),
        ),
      ],
    );
  }
}
