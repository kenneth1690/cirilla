import 'package:cirilla/constants/constants.dart';
import 'package:cirilla/mixins/mixins.dart';
import 'package:cirilla/models/address/address.dart';
import 'package:cirilla/models/address/country_address.dart';
import 'package:cirilla/screens/checkout/view/delivery_location_icon.dart';
import 'package:cirilla/store/auth/auth_store.dart';
import 'package:cirilla/store/cart/checkout_store.dart';
import 'package:cirilla/store/data/address_store.dart';
import 'package:cirilla/store/setting/setting_store.dart';
import 'package:cirilla/types/types.dart';
import 'package:cirilla/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'fields/fields.dart';

enum FieldFormType {
  billing,
  shipping,
  checkoutBilling,
  checkoutShipping,
  additional,
}

class AddressFieldForm3 extends StatelessWidget {
  final Map<String, dynamic>? data;
  final AddressData addressData;
  final Function(Map<String, dynamic>) onChanged;
  final Function(String) onGetAddressData;
  final Widget? titleModal;
  final bool borderFields;
  final String keyForm;
  final FieldFormType formType;
  final List<String> include;
  final bool isBooking;

  const AddressFieldForm3({
    Key? key,
    this.titleModal,
    this.borderFields = false,
    required this.data,
    required this.addressData,
    required this.onChanged,
    required this.onGetAddressData,
    required this.keyForm,
    this.formType = FieldFormType.billing,
    this.include = const [],
    this.isBooking = false,
  }) : super(key: key);

  String getDefaultName(String key, FieldFormType type) {
    switch (type) {
      case FieldFormType.billing:
      case FieldFormType.checkoutBilling:
        return key.replaceFirst("billing_", "");
      case FieldFormType.shipping:
      case FieldFormType.checkoutShipping:
        return key.replaceFirst("shipping_", "");
      case FieldFormType.additional:
        return key.replaceFirst("additional_", "");
      default:
        return key;
    }
  }

  Map<String, List<CountryAddressData>> getStateList() {
    if (formType == FieldFormType.shipping || formType == FieldFormType.checkoutShipping) {
      return (addressData.shippingStates ?? {}).cast<String, List<CountryAddressData>>();
    }
    return (addressData.billingStates ?? {}).cast<String, List<CountryAddressData>>();
  }

  List<CountryAddressData> getCountryList() {
    if (formType == FieldFormType.shipping || formType == FieldFormType.checkoutShipping) {
      return addressData.shippingCountries ?? [];
    }
    return (addressData.billingCountries ?? []).cast<CountryAddressData>();
  }

  Map<String, dynamic> getFields(dynamic nickname) {
    if(formType == FieldFormType.additional) {
      return (addressData.additional ?? {}).cast<String, dynamic>();
    }

    if (formType == FieldFormType.shipping || formType == FieldFormType.checkoutShipping) {
      return {
        if (isBooking) 'shipping_address_nickname': nickname,
        ...addressData.shipping ?? {},
      }.cast<String, dynamic>();
    }
    return {
      if (isBooking) 'billing_address_nickname': nickname,
      ...addressData.billing ?? {},
    }.cast<String, dynamic>();
  }

  Map<String, dynamic> getConvertFields(Map<String, dynamic> fields) {
    Map<String, dynamic> data = {};

    for (String key in fields.keys) {
      dynamic value = fields[key];
      bool disabled = ConvertData.toBoolValue(get(value, ['disabled'])) ?? false;

      if (include.isNotEmpty) {
        String defaultName = getDefaultName(key, formType);
        String name = get(value, ['name'], defaultName);
        if (include.contains(name)) {
          data.addAll({
            key: value,
          });
        }
      } else {
        if (!disabled) {
          data.addAll({
            key: value,
          });
        }
      }
    }
    return data;
  }

  void onChangeField(String key, String name, dynamic value, String type, Map<String, dynamic> fields) {
    if (type == "country") {
      Map<String, dynamic> stateData = {};
      for (var fieldKey in fields.keys) {
        dynamic fieldData = fields[fieldKey];
        if (fieldData is Map &&
            get(fieldData, ['type'], '') == 'state' &&
            get(fieldData, ['country_field'], '') == key) {
          String defaultNameState =
              fieldKey.split('_').length > 1 ? fieldKey.split('_').sublist(1).join('_') : fieldKey;
          String nameState = get(fieldData, ['name'], defaultNameState);
          Map<String, List<CountryAddressData>> states = getStateList();
          List<CountryAddressData>? stateList = states[value];
          stateData.addAll({
            nameState: stateList?.isNotEmpty == true ? stateList![0].code : '',
          });
        }
      }
      onChanged({...?data, ...stateData, name: value});
      if (name == "country") {
        onGetAddressData(value);
      }
      return;
    }
    onChanged({...?data, name: value});
  }

  @override
  Widget build(BuildContext context) {
    SettingStore settingStore = Provider.of<SettingStore>(context);
    TranslateType translate = AppLocalizations.of(context)!.translate;

    dynamic nickname = {
      "label": translate('address_book_input_nickname'),
      "placeholder": translate('address_book_hint_nickname'),
      "class": ["form-row-wide"],
      "autocomplete": "organization",
      "priority": 1,
      "required": false
    };

    Map<String, dynamic> fields = getConvertFields(getFields(nickname));

    if (fields.isEmpty) {
      return Container();
    }

    return LayoutBuilder(
      builder: (_, BoxConstraints constraints) {
        double widthView =
            constraints.maxWidth != double.infinity ? constraints.maxWidth : MediaQuery.of(context).size.width;
        List<String> keys = fields.keys.toList();
        return SizedBox(
          width: double.infinity,
          child: Wrap(
            alignment: WrapAlignment.spaceBetween,
            crossAxisAlignment: WrapCrossAlignment.start,
            spacing: 0,
            runSpacing: itemPaddingMedium,
            children: [
              if (titleModal != null)
                Container(
                  width: widthView,
                  padding: const EdgeInsets.only(bottom: itemPaddingExtraLarge),
                  child: Center(
                    child: titleModal,
                  ),
                ),
              ...List.generate(
                keys.length,
                (index) {
                  String key = keys.toList()[index];
                  Map<String, dynamic> field = fields[key];
                  String type = get(field, ['type'], 'text');
                  String defaultField = get(field, ['default'], '');
                  String position = get(field, ['position'], 'form-row-wide');

                  String conditionalParent = get(field, ['custom_attributes', 'data-conditional-parent']) ?? "";
                  String conditionalParentValue =
                      get(field, ['custom_attributes', 'data-conditional-parent-value']) ?? "";

                  String defaultName = getDefaultName(key, formType);
                  String name = get(field, ['name'], defaultName);

                  if (conditionalParent.isNotEmpty) {
                    String defaultNameParent = getDefaultName(conditionalParent, formType);
                    String nameParent = get(field, ['parent', 'name'], defaultNameParent);
                    if (conditionalParentValue.isEmpty ||
                        (conditionalParentValue.isNotEmpty && (data?[nameParent] ?? "") != conditionalParentValue)) {
                      type = "hidden";
                    }
                  }

                  /// Update only if this widget initialized.
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    if (name != "country" && name != "state" && data?[name] == null && defaultField.isNotEmpty) {
                      onChangeField(key, name, defaultField, type, fields);
                    }

                    if (name == "country" &&
                        (data?[name] == null || data?[name] == "") &&
                        addressData.country?.isNotEmpty == true) {
                      onChangeField(key, name, addressData.country, type, fields);
                    }
                  });

                  late Widget child;
                  String keyInput = '${keyForm}_$name';

                  switch (type) {
                    case 'text':
                      child = AddressFieldText(
                        key: Key(keyInput),
                        value: data?[name],
                        onChanged: (String value) => onChangeField(key, name, value, type, fields),
                        field: field,
                        borderFields: borderFields,
                        // <Handle for pick location button at checkout page>
                        suffixIcon: (field['autocomplete'] == 'address-line1' &&
                                (formType == FieldFormType.checkoutBilling ||
                                    formType == FieldFormType.checkoutShipping))
                            ? DeliveryLocationIcon(
                                callback: (place, {String? address2}) async {
                                  AddressDataStore addressDataStore = AddressDataStore(settingStore.requestHelper);
                                  CheckoutStore checkoutStore =
                                      Provider.of<AuthStore>(context, listen: false).cartStore.checkoutStore;
                                  switch (formType) {
                                    case FieldFormType.checkoutBilling:
                                      await checkoutStore.updateBillingFromMap(
                                        place: place,
                                        addressDataStore: addressDataStore,
                                        locale: settingStore.locale,
                                        address2: address2,
                                      );
                                      break;
                                    case FieldFormType.checkoutShipping:
                                      await checkoutStore.updateShippingFromMap(
                                        place: place,
                                        addressDataStore: addressDataStore,
                                        locale: settingStore.locale,
                                        address2: address2,
                                      );
                                      break;
                                    default:
                                      break;
                                  }
                                },
                              )
                            : null,
                        // </Handle for pick location button at checkout page>
                      );
                      break;
                    case 'heading':
                      child = AddressFieldHeading(field: field);
                      break;
                    case 'email':
                      child = AddressFieldEmail(
                        key: Key(keyInput),
                        value: data?[name],
                        onChanged: (String value) => onChangeField(key, name, value, type, fields),
                        field: field,
                        borderFields: borderFields,
                      );
                      break;
                    case 'tel':
                      child = AddressFieldPhone(
                        key: Key(keyInput),
                        value: data?[name],
                        onChanged: (String value) => onChangeField(key, name, value, type, fields),
                        field: field,
                        borderFields: borderFields,
                      );
                      break;
                    case 'textarea':
                      child = AddressFieldTextArea(
                        key: Key(keyInput),
                        value: data?[name],
                        onChanged: (String value) => onChangeField(key, name, value, type, fields),
                        field: field,
                        borderFields: borderFields,
                      );
                      break;
                    case 'password':
                      child = AddressFieldPassword(
                        key: Key(keyInput),
                        value: data?[name],
                        onChanged: (String value) => onChangeField(key, name, value, type, fields),
                        field: field,
                        borderFields: borderFields,
                      );
                      break;
                    case 'select':
                      child = AddressFieldSelect(
                        key: Key(keyInput),
                        value: data?[name],
                        onChanged: (String value) => onChangeField(key, name, value, type, fields),
                        field: field,
                        borderFields: borderFields,
                      );
                      break;
                    case 'radio':
                      child = AddressFieldRadio(
                        value: data?[name],
                        onChanged: (String value) => onChangeField(key, name, value, type, fields),
                        field: field,
                        borderFields: borderFields,
                      );
                      break;
                    case 'checkbox':
                      child = AddressFieldCheckbox(
                        value: data?[name],
                        onChanged: (String value) => onChangeField(key, name, value, type, fields),
                        field: field,
                      );
                      break;
                    case 'time':
                      child = AddressFieldTime(
                        key: Key(keyInput),
                        value: data?[name],
                        onChanged: (String value) => onChangeField(key, name, value, type, fields),
                        field: field,
                        borderFields: borderFields,
                      );
                      break;
                    case 'date':
                      child = AddressFieldDate(
                        key: Key(keyInput),
                        value: data?[name],
                        onChanged: (String value) => onChangeField(key, name, value, type, fields),
                        field: field,
                        borderFields: borderFields,
                      );
                      break;
                    case 'number':
                      child = AddressFieldNumber(
                        key: Key(keyInput),
                        value: data?[name],
                        onChanged: (String value) => onChangeField(key, name, value, type, fields),
                        field: field,
                        borderFields: borderFields,
                      );
                      break;
                    case 'country':
                      List<CountryAddressData> countries = getCountryList();
                      child = AddressFieldCountry(
                        key: Key(keyInput),
                        value: data?[name],
                        countries: countries,
                        field: field,
                        onChanged: (String value) => onChangeField(key, name, value, type, fields),
                        borderFields: borderFields,
                      );
                      break;
                    case 'state':
                      Map<String, List<CountryAddressData>> states = getStateList();
                      String countryField = get(field, ['country_field'], '');
                      Map<String, dynamic>? fieldCountry = fields[countryField];
                      String defaultNameCountry = countryField.split('_').length > 1
                          ? countryField.split('_').sublist(1).join('_')
                          : countryField;
                      String? nameCountry = get(fieldCountry, ['name'], defaultNameCountry);
                      String? valueCountry = nameCountry != null ? get(data, [nameCountry]) : null;
                      List<CountryAddressData>? stateData = states[valueCountry];

                      child = AddressFieldState(
                        key: Key('${keyInput}_${defaultNameCountry}_$valueCountry'),
                        value: data?[name],
                        states: stateData ?? [],
                        field: field,
                        onChanged: (String value) => onChangeField(key, name, value, type, fields),
                        borderFields: borderFields,
                      );
                      break;
                    case 'multiselect':
                      child = AddressFieldMultiSelect(
                        value: data?[name],
                        onChanged: (List value) => onChangeField(key, name, value, type, fields),
                        field: field,
                      );
                      break;
                    case 'multicheckbox':
                      child = AddressFieldMultiCheckbox(
                        value: data?[name],
                        onChanged: (List value) => onChangeField(key, name, value, type, fields),
                        field: field,
                        borderFields: borderFields,
                      );
                      break;
                    case 'colorpicker':
                      child = AddressFieldColorPicker(
                        key: Key(keyInput),
                        value: data?[name],
                        onChanged: (String value) => onChangeField(key, name, value, type, fields),
                        field: field,
                        borderFields: borderFields,
                      );
                      break;
                    default:
                      child = Container();
                  }

                  if (position == 'form-row-wide') {
                    return SizedBox(
                      width: widthView,
                      child: child,
                    );
                  }

                  if (position == 'form-row-last') {
                    String? preKey = index > 0 ? keys[index - 1] : null;
                    Map<String, dynamic>? preField = preKey != null ? fields[preKey] : null;
                    String prePosition = get(preField, ['position'], 'form-row-wide');
                    if (prePosition != 'form-row-first') {
                      return Container(
                        width: widthView,
                        alignment: AlignmentDirectional.topEnd,
                        child: SizedBox(
                          width: (widthView - itemPaddingMedium) / 2,
                          child: child,
                        ),
                      );
                    }
                  }

                  if (position == 'form-row-first') {
                    String? nextKey = index < keys.length - 1 ? keys[index + 1] : null;
                    Map<String, dynamic>? nextField = nextKey != null ? fields[nextKey] : null;
                    String nextPosition = get(nextField, ['position'], 'form-row-wide');
                    if (nextPosition != 'form-row-last') {
                      return Container(
                        width: widthView,
                        alignment: AlignmentDirectional.topStart,
                        child: SizedBox(
                          width: (widthView - itemPaddingMedium) / 2,
                          child: child,
                        ),
                      );
                    }
                  }
                  return SizedBox(
                    width: (widthView - itemPaddingMedium) / 2,
                    child: child,
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
