import 'package:cirilla/constants/styles.dart';
import 'package:cirilla/mixins/mixins.dart';
import 'package:cirilla/models/address/country_address.dart';
import 'package:cirilla/types/types.dart';
import 'package:cirilla/utils/app_localization.dart';
import 'package:feather_icons/feather_icons.dart';
import 'package:flutter/material.dart';
import 'package:collection/collection.dart';

import 'modal_country_address.dart';
import 'validate_field.dart';

String _getName(String code, List<CountryAddressData> data) {
  CountryAddressData? country = data.firstWhereOrNull((element) => element.code == code);
  return country?.name?.isNotEmpty == true ? country!.name! : code;
}

String? _getCode(String? name, List<CountryAddressData> data) {
  CountryAddressData? country = data.firstWhereOrNull((element) => element.name == name);
  return country?.code;
}

class AddressFieldState extends StatefulWidget {
  final String? value;
  final ValueChanged<String> onChanged;
  final List<CountryAddressData> states;
  final Map<String, dynamic> field;
  final bool borderFields;

  const AddressFieldState({
    Key? key,
    this.value,
    required this.onChanged,
    required this.states,
    required this.field,
    this.borderFields = false,
  }) : super(key: key);

  @override
  State<AddressFieldState> createState() => _AddressFieldStateState();
}

class _AddressFieldStateState extends State<AddressFieldState> with Utility {
  final _controller = TextEditingController();
  final _focusNode = FocusNode();

  @override
  void didChangeDependencies() {
    String defaultValue = get(widget.field, ['default'], '');
    _controller.text = _getName(widget.value ?? defaultValue, widget.states);
    super.didChangeDependencies();
  }

  @override
  void didUpdateWidget(covariant AddressFieldState oldWidget) {
    if (oldWidget.value != widget.value && _getName(widget.value ?? '', widget.states) != _controller.text) {
      String defaultValue = get(widget.field, ['default'], '');
      _controller.text = _getName(widget.value ?? defaultValue, widget.states);
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    TranslateType translate = AppLocalizations.of(context)!.translate;

    String label = get(widget.field, ['label'], '');
    String placeholder = get(widget.field, ['placeholder'], '');
    bool? requiredInput = get(widget.field, ['required'], true);
    List validate = get(widget.field, ['validate'], []);

    String? labelText = requiredInput! ? '$label *' : label;

    return TextFormField(
      controller: _controller,
      validator: (String? value) => validateField(
        translate: translate,
        validate: validate,
        requiredInput: requiredInput,
        value: value,
      ),
      focusNode: _focusNode,
      onTap: widget.states.isNotEmpty
          ? () {
              if (!_focusNode.hasPrimaryFocus) {
                _focusNode.unfocus();
              }
              showModalBottomSheet<void>(
                context: context,
                isScrollControlled: true,
                builder: (BuildContext context) {
                  return buildViewModal(
                    context,
                    child: StatefulBuilder(
                      builder: (BuildContext context, StateSetter stateSetter) {
                        return ModalCountryAddress(
                          data: widget.states,
                          value: _getCode(_controller.text, widget.states),
                          onChange: (String? countryValue) {
                            if (countryValue != null && countryValue != widget.value) {
                              _controller.text = _getName(countryValue, widget.states);
                              widget.onChanged(countryValue);
                            }
                            Navigator.pop(context);
                          },
                          title: translate('address_select_state'),
                          titleSearch: translate('address_search'),
                        );
                      },
                    ),
                  );
                },
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20)),
                ),
              );
            }
          : null,
      onChanged: (text) {
        if (widget.states.isEmpty) {
          widget.onChanged(text);
        }
      },
      decoration: widget.borderFields == true
          ? InputDecoration(
              labelText: labelText,
              hintText: placeholder,
              suffixIcon: widget.states.isNotEmpty
                  ? const Padding(
                      padding: EdgeInsetsDirectional.only(end: itemPaddingMedium),
                      child: Icon(FeatherIcons.chevronDown, size: 16),
                    )
                  : null,
              suffixIconConstraints: widget.states.isNotEmpty
                  ? const BoxConstraints(
                      minWidth: 2,
                      minHeight: 2,
                    )
                  : null,
              contentPadding: const EdgeInsetsDirectional.only(start: itemPaddingMedium),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: theme.inputDecorationTheme.border?.borderSide ?? const BorderSide(),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: theme.inputDecorationTheme.enabledBorder?.borderSide ?? const BorderSide(),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: theme.inputDecorationTheme.focusedBorder?.borderSide ?? const BorderSide(),
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: theme.inputDecorationTheme.errorBorder?.borderSide ?? const BorderSide(),
              ),
              focusedErrorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: theme.inputDecorationTheme.focusedErrorBorder?.borderSide ?? const BorderSide(),
              ),
              disabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: theme.inputDecorationTheme.disabledBorder?.borderSide ?? const BorderSide(),
              ),
            )
          : InputDecoration(
              labelText: labelText,
              hintText: placeholder,
              suffixIcon: widget.states.isNotEmpty ? const Icon(FeatherIcons.chevronDown, size: 16) : null,
              suffixIconConstraints: widget.states.isNotEmpty
                  ? const BoxConstraints(
                      minWidth: 2,
                      minHeight: 2,
                    )
                  : null,
            ),
    );
  }

  Widget buildViewModal(BuildContext context, {Widget? child}) {
    MediaQueryData mediaQuery = MediaQuery.of(context);
    double height = mediaQuery.size.height - mediaQuery.viewInsets.bottom;

    return Container(
      constraints: BoxConstraints(maxHeight: height - 100),
      padding: paddingHorizontal.add(paddingVerticalLarge),
      margin: EdgeInsets.only(bottom: mediaQuery.viewInsets.bottom),
      child: SizedBox(
        width: double.infinity,
        child: child,
      ),
    );
  }
}
