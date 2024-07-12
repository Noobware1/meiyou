import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:meiyou/core/constants/font_size.dart';
import 'package:meiyou/core/utils/extensions/context.dart';
import 'package:meiyou/presentation/core/dilog_box/alert_dialog_box.dart';

class ListDialogBox<E> extends StatefulWidget {
  final String? title;
  final List<String> items;
  final void Function(BuildContext context, int selected) onItemSelected;
  final int selected;
  final bool showCancelButton;

  const ListDialogBox({
    super.key,
    this.title,
    required this.items,
    required this.onItemSelected,
    this.selected = 0,
    this.showCancelButton = false,
  });

  @override
  State<ListDialogBox> createState() => _ListDialogBoxState();
}

class _ListDialogBoxState extends State<ListDialogBox> {
  int selected = 0;

  @override
  void initState() {
    selected = widget.selected;
    super.initState();
  }

  TextStyle get selectedTextStyle => TextStyle(
        color: context.theme.primaryColor,
        fontWeight: FontWeight.bold,
      );

  List<Widget> children() {
    return List.generate(widget.items.length, (index) {
      final item = widget.items[index];
      final isSelected = index == selected;
      return RadioListTile<String>.adaptive(
        contentPadding: EdgeInsets.zero,
        visualDensity: const VisualDensity(horizontal: 0, vertical: -2),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        title: Text(
          item,
          style: TextStyle(color: context.theme.colorScheme.onSurface),
        ),
        value: item,
        groupValue: widget.items[selected],
        onChanged: (value) {
          if (selected != index && value != null) {
            setState(() {
              selected = index;
            });
            widget.onItemSelected(context, index);
          }
        },
        selected: isSelected,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog.adaptive(
      insetPadding: const EdgeInsets.symmetric(horizontal: 15),
      title: widget.title == null ? null : Text(widget.title!),
      content: Column(
        children: children(),
      ),
      scrollable: true,
      actions: !widget.showCancelButton
          ? null
          : [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('Cancel'),
              ),
            ],
    );
  }
}
