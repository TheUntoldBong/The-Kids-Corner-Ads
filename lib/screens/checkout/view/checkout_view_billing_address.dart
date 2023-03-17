import 'package:cirilla/constants/styles.dart';
import 'package:cirilla/mixins/mixins.dart';
import 'package:cirilla/screens/profile/widgets/address_field_form3.dart';
import 'package:cirilla/screens/profile/widgets/fields/loading_field_address.dart';
import 'package:cirilla/types/types.dart';
import 'package:cirilla/utils/app_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:cirilla/store/store.dart';
import 'package:provider/provider.dart';

class CheckoutViewBillingAddress extends StatefulWidget {
  final CartStore cartStore;

  const CheckoutViewBillingAddress({
    Key? key,
    required this.cartStore,
  }) : super(key: key);

  @override
  State<CheckoutViewBillingAddress> createState() => _CheckoutViewBillingAddressState();
}

class _CheckoutViewBillingAddressState extends State<CheckoutViewBillingAddress> with Utility {
  final _formBillingKey = GlobalKey<FormState>();
  late SettingStore _settingStore;
  late AddressDataStore _addressDataStore;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _settingStore = Provider.of<SettingStore>(context);
    Map<String, dynamic> billing = {
      ...?widget.cartStore.cartData?.billingAddress,
      ...widget.cartStore.checkoutStore.billingAddress,
    };
    String country = get(billing, ['country'], '');
    _addressDataStore = AddressDataStore(_settingStore.requestHelper)
      ..getAddressData(queryParameters: {
        'country': country,
        'lang': _settingStore.locale,
      });
  }

  void onChanged(Map<String, dynamic> value) {
    widget.cartStore.checkoutStore.changeAddress(
      billing: value,
      shipping: widget.cartStore.checkoutStore.shipToDifferentAddress ? null : value,
    );
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    TranslateType translate = AppLocalizations.of(context)!.translate;
    return Observer(
      builder: (_) {
        Map<String, dynamic> billing = {
          ...?widget.cartStore.cartData?.billingAddress,
          ...widget.cartStore.checkoutStore.billingAddress,
        };
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(translate('checkout_billing_detail'), style: theme.textTheme.headline6),
            Padding(
              padding: paddingVerticalMedium,
              child: _addressDataStore.address?.billing?.isNotEmpty == true
                  ? AddressFieldForm3(
                      formKey: _formBillingKey,
                      data: billing,
                      addressFields: _addressDataStore.address?.billing ?? {},
                      onChanged: onChanged,
                      countries: _addressDataStore.address?.billingCountries ?? [],
                      states: _addressDataStore.address?.billingStates ?? {},
                      onGetAddressData: (String country) {
                        _addressDataStore.getAddressData(queryParameters: {
                          'country': country,
                          'lang': _settingStore.locale,
                        });
                      },
                    )
                  : const LoadingFieldAddress(count: 10),
            )
          ],
        );
      },
    );
  }
}
