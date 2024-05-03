import 'package:flutter/material.dart';
import 'package:meiyou/core/utils/extensions/context.dart';

class ListDialogBox<E> extends StatefulWidget {
  final List<String> items;
  final void Function(BuildContext context, int selected) onItemSelected;
  final int selected;

  const ListDialogBox({
    super.key,
    required this.items,
    required this.onItemSelected,
    this.selected = 0,
  });

  static const constraints = BoxConstraints(
    maxWidth: 300,
    maxHeight: 280,
    minHeight: 20,
  );

  static const padding = EdgeInsets.only(top: 10, bottom: 10);

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

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        constraints: ListDialogBox.constraints,
        padding: ListDialogBox.padding,
        child: ListView(
          shrinkWrap: true,
          children: List.generate(widget.items.length, (index) {
            final item = widget.items[index];
            final isSelected = index == selected;
            return RadioListTile<String>.adaptive(
              title: Text(item, style: isSelected ? selectedTextStyle : null),
              value: item,
              groupValue: widget.items[selected],
              onChanged: (value) {
                if (value != null) {
                  setState(() {
                    selected = index;
                  });
                  widget.onItemSelected(context, index);
                }
              },
              selected: isSelected,
            );
            // return ListTile(

            //   title:
            //       Text(convertToString?.call(item, index) ?? item.toString()),
            //   onTap: () {
            //     onItemSelected(context, item);
            //   },
            // );
          }),
        ),
      ),
    );
  }
}
