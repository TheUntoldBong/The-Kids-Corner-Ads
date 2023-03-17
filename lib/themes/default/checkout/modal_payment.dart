import 'package:cirilla/constants/constants.dart';
import 'package:cirilla/types/types.dart';
import 'package:cirilla/utils/utils.dart';
import 'package:cirilla/widgets/widgets.dart';
import 'package:feather_icons/feather_icons.dart';
import 'package:flutter/material.dart';

import 'total_view.dart';

class ModalPaymentCheckout extends StatelessWidget {
  final EdgeInsetsGeometry? paddingBottom;
  final EdgeInsetsGeometry? paddingContent;
  final VoidCallback? onConfirm;

  const ModalPaymentCheckout({
    Key? key,
    this.paddingBottom,
    this.paddingContent,
    this.onConfirm,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    TranslateType translate = AppLocalizations.of(context)!.translate;
    ThemeData theme = Theme.of(context);

    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            padding: paddingContent ?? paddingVerticalLarge.add(paddingHorizontal),
            child: Column(
              children: [
                Text(translate('checkout_payment_confirm'), style: theme.textTheme.subtitle1),
                const SizedBox(height: 40),
                CirillaButtonSocial(
                  icon: FeatherIcons.shield,
                  size: 90,
                  sizeIcon: 36,
                  color: theme.primaryColor,
                  background: theme.primaryColorLight,
                ),
                const SizedBox(height: 24),
                Text(
                  translate('checkout_order_id', {'id': '123456'}),
                  style: theme.textTheme.subtitle2?.copyWith(color: theme.primaryColor),
                ),
                const SizedBox(height: 24),
                const Divider(height: 1, thickness: 1),
                const SizedBox(height: 24),
                TotalView(
                  title: translate('checkout_subtotal'),
                  price: '\$200.00',
                  type: TotalType.containerAll,
                ),
                const TotalView(title: 'Free Shipping', price: '- \$10.00'),
                TotalView(title: translate('checkout_vat'), price: '\$20.00'),
                const SizedBox(height: 24),
                const Divider(height: 1, thickness: 1),
                const SizedBox(height: 24),
                TotalView(
                  title: translate('checkout_total'),
                  price: '\$210.00',
                  type: TotalType.heading,
                ),
              ],
            ),
          ),
        ),
        Padding(
          padding: paddingBottom ?? paddingVerticalMedium.add(paddingHorizontal),
          child: SizedBox(
            height: 48,
            width: double.infinity,
            child: ElevatedButton(
              onPressed: onConfirm,
              child: Text(translate('checkout_confirm')),
            ),
          ),
        )
      ],
    );
  }
}
