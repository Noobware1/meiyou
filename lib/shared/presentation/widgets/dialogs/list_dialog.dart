import 'package:flutter/material.dart' hide AlertDialog;
import 'package:meiyou/shared/presentation/widgets/dialogs/alert_dialog.dart';

class ListDailog<E> extends AlertDialog {
  final List<String> keys;
  final List<E> values;
  final void Function(E selected) onSelected;
  final E selected;

  const ListDailog({
    super.key,
    super.title,
    required this.keys,
    required this.values,
    required this.onSelected,
    required this.selected,
    super.showCancelAction,
    super.actions,
    super.scrollable = true,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
        title: title,
        showCancelAction: showCancelAction,
        content: Column(
          children: List.generate(keys.length, (index) {
            final key = keys[index];

            final value = values[index];
            return RadioListTile<E>.adaptive(
              contentPadding: EdgeInsets.zero,
              visualDensity: const VisualDensity(horizontal: 0, vertical: -2),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              title: Text(key),
              value: value,
              groupValue: selected,
              onChanged: (value) {
                if (value != null) {
                  onSelected(value);
                }
              },
              selected: value == selected,
            );
          }),
        ),
        scrollable: scrollable,
        actions: actions);
  }
}
