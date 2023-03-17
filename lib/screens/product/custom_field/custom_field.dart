import 'package:cirilla/mixins/mixins.dart';
import 'package:flutter/material.dart';

import 'text.dart';
import 'text_area.dart';
import 'image.dart';
import 'select.dart';
import 'checkbox.dart';
import 'switch.dart';
import 'link.dart';
import 'taxonomy.dart';
import 'user.dart';
import 'date.dart';
import 'color.dart';
import 'file.dart';
import 'google_map.dart';
import 'embed.dart';
import 'base64.dart';

class AdvancedFieldsCustomView extends StatelessWidget with Utility {
  final Map? fields;
  final String? align;
  final String? fieldName;

  const AdvancedFieldsCustomView({Key? key, this.fields, this.align, this.fieldName}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (fieldName?.isNotEmpty == true && fields != null && fields![fieldName] is Map) {
      Map data = fields![fieldName];
      String type = get(data, ['type'], '');
      dynamic value = get(data, ['value'], null);

      switch (type) {
        case 'text':
        case 'number':
        case 'range':
        case 'email':
        case 'url':
        case 'password':
          return FieldText(
            value: value,
            align: align,
            type: type,
          );
        case 'textarea':
          String line = get(data, ['new_lines'], '');
          return FieldTextArea(
            value: value,
            align: align,
            line: line,
          );
        case 'wysiwyg':
          return FieldTextArea(
            value: value,
            align: align,
            line: 'wpautop',
          );
        case 'oembed':
          return FieldEmbed(
            value: value,
          );
        case 'image':
          String format = get(data, ['return_format'], 'array');
          return FieldImage(
            value: value,
            format: format,
          );
        case 'select':
        case 'radio':
        case 'button_group':
          Map choices = get(data, ['choices'], {});
          String format = get(data, ['return_format'], 'value');
          return FieldSelect(
            value: value,
            align: align,
            choices: choices,
            format: format,
          );
        case 'checkbox':
          Map choices = get(data, ['choices'], {});
          String format = get(data, ['return_format'], 'value');
          return FieldCheckbox(
            value: value,
            align: align,
            choices: choices,
            format: format,
          );
        case 'true_false':
          return FieldSwitch(
            value: value,
            align: align,
          );
        case 'link':
          String format = get(data, ['return_format'], 'array');
          return FieldLink(
            value: value,
            align: align,
            format: format,
          );
        case 'taxonomy':
          String format = get(data, ['return_format'], 'array');
          return FieldTaxonomy(
            value: value,
            align: align,
            format: format,
          );
        case 'user':
          String format = get(data, ['return_format'], 'array');
          return FieldUser(
            value: value,
            align: align,
            format: format,
          );
        case 'date_picker':
        case 'date_time_picker':
        case 'time_picker':
          return FieldDate(
            value: value,
            align: align,
          );
        case 'color_picker':
          String format = get(data, ['return_format'], 'string');
          return FieldColor(
            value: value,
            align: align,
            format: format,
          );
        case 'file':
          String format = get(data, ['return_format'], 'array');
          return FieldFile(
            value: value,
            align: align,
            format: format,
          );
        case 'page_link':
          return FieldText(
            value: value,
            align: align,
            type: 'url',
          );
        case 'google_map':
          return FieldGoogleMap(value: value);
        case 'base64':
          String label = get(data, ['label'], '');
          return Base64Image(
            value: value,
            label: label,
          );
        default:
          return FieldText(
            value: value,
            align: align,
          );
      }
    }
    return Container();
  }
}
