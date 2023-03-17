import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CalendarHeader extends StatelessWidget {
  final DateTime focusedDay;
  final VoidCallback? onLeftArrowTap;
  final VoidCallback onRightArrowTap;

  const CalendarHeader({
    Key? key,
    required this.focusedDay,
    this.onLeftArrowTap,
    required this.onRightArrowTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);

    final headerText = DateFormat.yMMM().format(focusedDay);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.chevron_left),
            color: onLeftArrowTap != null ? theme.textTheme.subtitle1?.color : theme.disabledColor,
            onPressed: onLeftArrowTap ?? () {},
          ),
          Expanded(
            child: Text(
              headerText,
              style: theme.textTheme.subtitle1,
              textAlign: TextAlign.center,
            ),
          ),
          IconButton(
            icon: const Icon(Icons.chevron_right),
            color: theme.textTheme.subtitle1?.color,
            onPressed: onRightArrowTap,
          ),
        ],
      ),
    );
  }
}
