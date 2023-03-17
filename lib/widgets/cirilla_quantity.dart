import 'package:cirilla/constants/constants.dart';
import 'package:cirilla/mixins/mixins.dart';
import 'package:cirilla/utils/convert_data.dart';
import 'package:cirilla/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CirillaQuantity extends StatefulWidget {
  final int value;
  final ValueChanged<int>? onChanged;
  final double width;
  final double height;
  final Color? color;
  final Color? borderColor;
  final int min;
  final Function actionEmpty;
  final Function? actionZero;
  final double? radius;
  final TextStyle? textStyle;

  const CirillaQuantity({
    Key? key,
    required this.value,
    required this.onChanged,
    this.height = 34,
    this.width = 90,
    this.color,
    this.min = 1,
    required this.actionEmpty,
    this.actionZero,
    this.radius,
    this.borderColor,
    this.textStyle,
  })  : assert(height >= 28),
        assert(width >= 64),
        super(key: key);

  @override
  State<CirillaQuantity> createState() => _CirillaQuantityState();
}

class _CirillaQuantityState extends State<CirillaQuantity> with ShapeMixin {
  late TextEditingController _controller;

  @override
  void initState() {
    _controller = TextEditingController(text: '${widget.value}');
    _controller.addListener(() {
      String text = _controller.text;
      int value = ConvertData.stringToInt(text);
      if (value != widget.value) {
        widget.onChanged?.call(value);
      }
      if (text.isNotEmpty && text.length != value.toString().length) {
        _controller.text = '$value';
      }
    });

    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void onChange(dynamic value) {
    int qty = value != null && value != '' ? ConvertData.stringToInt(value, 1) : widget.min;
    if (qty < widget.min) qty = widget.min;
    _controller.text = '$qty';
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    double heightItem = widget.height;
    TextStyle textStyle =
        theme.textTheme.bodyText2!.copyWith(color: theme.textTheme.subtitle1!.color).merge(widget.textStyle);
    int value = widget.value;

    return Container(
      width: widget.width,
      decoration: BoxDecoration(
        color: widget.color,
        borderRadius: BorderRadius.circular(widget.radius ?? 4),
        border: widget.borderColor != null ? Border.all(color: widget.borderColor!) : null,
      ),
      height: heightItem,
      alignment: Alignment.center,
      clipBehavior: Clip.antiAliasWithSaveLayer,
      child: Row(
        children: [
          buildIconButton(
            icon: Icons.remove_rounded,
            theme: theme,
            onTap: () => onChange(value - 1),
          ),
          Expanded(
            child: TextFormField(
              controller: _controller,
              textAlign: TextAlign.center,
              decoration: InputDecoration(
                isDense: true,
                hintText: '$value',
                contentPadding: EdgeInsets.zero,
                border: InputBorder.none,
                focusedBorder: InputBorder.none,
                enabledBorder: InputBorder.none,
                errorBorder: InputBorder.none,
                disabledBorder: InputBorder.none,
              ),
              keyboardType: const TextInputType.numberWithOptions(signed: true),
              textInputAction: TextInputAction.done,
              inputFormatters: <TextInputFormatter>[
                FilteringTextInputFormatter.digitsOnly,
              ],
              style: textStyle,
            ),
          ),
          buildIconButton(
            icon: Icons.add_rounded,
            theme: theme,
            onTap: () => onChange(value + 1),
          ),
        ],
      ),
    );
  }

  Widget buildIconButton({
    required IconData icon,
    GestureTapCallback? onTap,
    required ThemeData theme,
  }) {
    Widget child = Container(
      height: double.infinity,
      width: 32,
      padding: paddingHorizontalTiny,
      child: Icon(
        icon,
        size: 16,
        color: onTap != null ? theme.textTheme.subtitle1!.color : theme.colorScheme.onSurface,
      ),
    );
    return onTap != null
        ? InkWell(
            onTap: onTap,
            child: child,
          )
        : child;
  }
}
