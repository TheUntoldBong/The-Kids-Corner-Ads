import 'package:cirilla/constants/constants.dart';
import 'package:cirilla/mixins/mixins.dart';
import 'package:cirilla/screens/screens.dart';
import 'package:cirilla/types/types.dart';
import 'package:cirilla/utils/app_localization.dart';
import 'package:flutter/material.dart';
import 'package:cirilla/widgets/cirilla_tile.dart';

class AccountScreen extends StatelessWidget with AppBarMixin {
  static const String routeName = '/profile/account';

  const AccountScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    TranslateType translate = AppLocalizations.of(context)!.translate;
    return Scaffold(
      appBar: baseStyleAppBar(context, title: translate('edit_account_your_account')),
      body: SingleChildScrollView(
        padding: paddingHorizontal,
        child: Column(
          children: [
            CirillaTile(
              title: Text(translate('edit_account'), style: theme.textTheme.subtitle2),
              onTap: () => Navigator.of(context).pushNamed(EditAccountScreen.routeName),
            ),
            // CirillaTile(
            //   title: Text(translate('change_phone'), style: theme.textTheme.subtitle2),
            //   onTap: () {},
            // ),
            CirillaTile(
              title: Text(translate('change_password'), style: theme.textTheme.subtitle2),
              onTap: () => Navigator.of(context).pushNamed(ChangePasswordScreen.routeName),
            ),
            CirillaTile(
              title: Text(translate('address_billing'), style: theme.textTheme.subtitle2),
              onTap: () => Navigator.of(context).pushNamed(AddressBookScreen.routeName),
            ),
            CirillaTile(
              title: Text(translate('address_shipping'), style: theme.textTheme.subtitle2),
              onTap: () => Navigator.of(context).pushNamed(AddressShippingScreen.routeName),
            ),
            CirillaTile(
              title: Text(translate('delete_account_txt'), style: theme.textTheme.subtitle2),
              onTap: () => Navigator.of(context).pushNamed(DeleteAccountScreen.routeName),
            ),
          ],
        ),
      ),
    );
  }
}
