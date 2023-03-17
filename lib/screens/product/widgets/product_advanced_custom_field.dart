import 'package:cirilla/mixins/mixins.dart';
import 'package:cirilla/models/product/product.dart';
import 'package:flutter/material.dart';
import 'package:collection/collection.dart';

import 'package:cirilla/screens/product/custom_field/custom_field.dart';

class ProductAdvancedFieldsCustom extends StatelessWidget with Utility {
  final Product? product;
  final String? align;
  final String? fieldName;

  const ProductAdvancedFieldsCustom({Key? key, this.product, this.align, this.fieldName}) : super(key: key);

  Map getFields(Product? p) {
    Map data = {
      ...?product?.afcFields,
    };
    List<Map<String, dynamic>>? meta = product?.metaData;
    if (meta?.isNotEmpty == true) {
      Map<String, dynamic>? barcode =
          meta!.firstWhereOrNull((element) => get(element, ['key'], '') == '_ywbc_barcode_image');

      Map<String, dynamic>? labelBarcode =
          meta.firstWhereOrNull((element) => get(element, ['key'], '') == 'ywbc_barcode_display_value_custom_field');

      String value = get(barcode, ['value'], '');
      String label = get(labelBarcode, ['value'], '');

      if (value.isNotEmpty) {
        data['_ywbc_barcode_image'] = {
          "key": "_ywbc_barcode_image",
          "label": label,
          "name": "_ywbc_barcode_image",
          "prefix": "acf",
          "type": "base64",
          "value": value,
        };
      }
    }
    return data;
  }

  @override
  Widget build(BuildContext context) {
    return AdvancedFieldsCustomView(
      fields: getFields(product),
      align: align,
      fieldName: fieldName,
    );
  }
}
