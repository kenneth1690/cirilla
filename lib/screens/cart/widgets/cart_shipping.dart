import 'package:cirilla/constants/constants.dart';
import 'package:cirilla/models/address/country.dart';
import 'package:cirilla/models/cart/cart.dart';
import 'package:cirilla/service/helpers/request_helper.dart';
import 'package:cirilla/store/store.dart';
import 'package:cirilla/types/types.dart';
import 'package:cirilla/utils/app_localization.dart';
import 'package:collection/collection.dart' show IterableExtension;
import 'package:feather_icons/feather_icons.dart';
import 'package:flutter/material.dart';
import 'package:cirilla/mixins/mixins.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/provider.dart';
import 'cart_change_address.dart';
import 'cart_layout_shipping.dart';

class CartShipping extends StatefulWidget {
  final CartData? cartData;
  final CartStore? cartStore;
  final bool changeAddress;
  final Map<String, dynamic> fields;

  const CartShipping({
    Key? key,
    this.cartData,
    this.cartStore,
    this.changeAddress = true,
    this.fields = const {},
  }) : super(key: key);

  @override
  State<CartShipping> createState() => _CartShippingState();
}

class _CartShippingState extends State<CartShipping> with LoadingMixin, SnackMixin {
  CountryStore? _countryStore;
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    RequestHelper requestHelper = Provider.of<RequestHelper>(context);
    _countryStore = CountryStore(requestHelper)..getCountry();
  }

  void showModal(BuildContext context, int index) {
    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: borderRadiusBottomSheet,
      ),
      builder: (BuildContext context) {
        return CartChangeAddress(index: index);
      },
    );
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    TranslateType translate = AppLocalizations.of(context)!.translate;

    TextTheme textTheme = theme.textTheme;

    int lengthShip = widget.cartData?.shippingRate?.length ?? 0;

    if (lengthShip == 0) {
      return Container();
    }
    return Observer(
      builder: (_) {
        return Column(
          children: List.generate(lengthShip, (index) {

            ShippingRate shippingRate = widget.cartData!.shippingRate!.elementAt(index);

            List<String?> shippingAddress = [];

            String? city = get(shippingRate.destination, ['city'], '');
            String? countryId = get(shippingRate.destination, ['country'], '');
            String? postcode = get(shippingRate.destination, ['postcode'], '');
            String? stateId = get(shippingRate.destination, ['state'], '');

            List data = shippingRate.shipItem!;

            String nameShipping = get(shippingRate.name, [], '');

            CountryData? countrySelect =
                _countryStore?.country.firstWhereOrNull((element) => element.code == countryId);

            String? country = countrySelect is CountryData ? countrySelect.name : '';

            List<Map<String, dynamic>>? states = countrySelect is CountryData ? countrySelect.states : null;
            Map<String, dynamic>? stateSelect =
                states?.firstWhereOrNull((element) => get(element, ['code'], '') == stateId);
            String? state = get(stateSelect, ['name'], stateId);

            if (postcode != '') shippingAddress.add(postcode);
            if (city != '') shippingAddress.add(city);
            if (state != '') shippingAddress.add(state);
            if (country != '') shippingAddress.add(country);

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (widget.changeAddress && index == 0)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Flexible(
                        child: Text(shippingAddress.join(', '), style: textTheme.bodySmall),
                      ),
                      GestureDetector(
                        onTap: () => showModal(context, index),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Icon(FeatherIcons.mapPin, size: 14, color: theme.primaryColor),
                            const SizedBox(width: 4),
                            Text(
                              translate('address_change'),
                              style: textTheme.bodySmall?.copyWith(color: theme.primaryColor),
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                if (index == 0) ...[
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: itemPadding),
                    child: Divider(height: 2, thickness: 1),
                  ),
                  Text(translate('cart_shipping_method'), style: textTheme.titleMedium),
                ],
                if (data.isNotEmpty) ...[
                  const SizedBox(height: itemPadding),
                  Text(nameShipping),
                  CartLayoutShipping(
                    dataShipping: data,
                    shippingRate: shippingRate,
                    cartStore: widget.cartStore,
                  ),
                ]
              ],
            );
          }),
        );
      },
    );
  }
}
