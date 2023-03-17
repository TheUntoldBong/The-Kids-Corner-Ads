import 'package:cirilla/constants/styles.dart';
import 'package:cirilla/mixins/mixins.dart';
import 'package:cirilla/screens/profile/widgets/address_field_form3.dart';
import 'package:cirilla/screens/profile/widgets/fields/loading_field_address.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:cirilla/store/store.dart';
import 'package:provider/provider.dart';

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
  final _formShippingKey = GlobalKey<FormState>();
  late SettingStore _settingStore;
  late AddressDataStore _addressDataStore;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _settingStore = Provider.of<SettingStore>(context);
    Map<String, dynamic> shipping = widget.cartStore.cartData?.shippingAddress ?? {};
    String country = get(shipping, ['country'], '');
    _addressDataStore = AddressDataStore(_settingStore.requestHelper)
      ..getAddressData(queryParameters: {
        'country': country,
        'lang': _settingStore.locale,
      });
  }

  void onChanged(Map<String, dynamic> value) {
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
    return Observer(
      builder: (_) {
        if (widget.cartStore.checkoutStore.shipToDifferentAddress) {
          Map<String, dynamic> shipping = {
            ...?widget.cartStore.cartData?.shippingAddress,
            ...widget.cartStore.checkoutStore.shippingAddress,
          };
          return Padding(
            padding: paddingVerticalMedium,
            child: _addressDataStore.address?.shipping?.isNotEmpty == true
                ? AddressFieldForm3(
                    formKey: _formShippingKey,
                    data: shipping,
                    addressFields: _addressDataStore.address?.shipping ?? {},
                    onChanged: onChanged,
                    countries: _addressDataStore.address?.shippingCountries ?? [],
                    states: _addressDataStore.address?.shippingStates ?? {},
                    onGetAddressData: (String country) {
                      _addressDataStore.getAddressData(queryParameters: {
                        'country': country,
                        'lang': _settingStore.locale,
                      });
                    },
                  )
                : const LoadingFieldAddress(),
          );
        }

        return Container();
      },
    );
  }
}
