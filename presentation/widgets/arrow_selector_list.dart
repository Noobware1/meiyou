import 'package:flutter/material.dart';
import 'package:meiyou/core/utils/extenstions/context.dart';
import 'package:meiyou/core/utils/get_lighter_color.dart';

import '../../lib/presentation/widgets/apply_cancel.dart';

class ArrowSelectorList<T> extends StatefulWidget {
  final String label;
  final String Function(BuildContext context, T item) builder;

  // final int currentIndex;
  final void Function(T selected)? onApply;
  final VoidCallback? onCancel;
  final List<T> items;
  final T initalValue;
  const ArrowSelectorList(
      {super.key,
      required this.items,
      required this.label,
      required this.initalValue,
      required this.builder,
      // required this.currentIndex,
      this.onApply,
      this.onCancel});

  @override
  State<ArrowSelectorList<T>> createState() => _ArrowSelectorListState<T>();
}

class _ArrowSelectorListState<T> extends State<ArrowSelectorList<T>> {
  late T selected;

  @override
  void initState() {
    selected = widget.initalValue;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // return Container(
    // constraints: isMobile
    //     ? BoxConstraints(
    //         maxWidth: context.screenWidth, maxHeight: 300, minHeight: 20)
    //     : BoxConstraints(
    //         maxWidth: context.screenWidth, maxHeight: 350, minHeight: 20),
    // child:

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: const EdgeInsets.all(10),
          child: Text(
            widget.label,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Flexible(
          child: ListView(
            children: List.generate(widget.items.length, (index) {
              return ArrowSelector(
                text: widget.builder.call(context, widget.items[index]),
                onTap: () {
                  setState(() {
                    selected = widget.items[index];
                  });
                },
                showArrow: selected == widget.items[index],
              );
            }),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: Align(
            alignment: Alignment.bottomRight,
            child: Container(
              width: 200,
              height: 50,
              alignment: Alignment.bottomRight,
              child: Padding(
                  padding: const EdgeInsets.only(right: 10),
                  child: AppyCancel(
                    onApply: () {
                      widget.onApply?.call(selected);
                    },
                    onCancel: () {
                      widget.onCancel?.call();
                    },
                  )),
            ),
          ),
        ),
      ],
      // ),
    );
  }
}

class ArrowSelector extends StatelessWidget {
  final String text;
  final VoidCallback onTap;
  final bool showArrow;
  const ArrowSelector(
      {super.key,
      required this.text,
      required this.onTap,
      this.showArrow = true});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: context.screenWidth,
      child: ElevatedButton.icon(
          style: ButtonStyle(
              overlayColor: MaterialStatePropertyAll(
                  context.theme.colorScheme.onSurface.withOpacity(0.2)),
              alignment: Alignment.centerLeft,
              padding: const MaterialStatePropertyAll(EdgeInsets.all(15)),
              backgroundColor:
                  const MaterialStatePropertyAll(Colors.transparent),
              elevation: const MaterialStatePropertyAll(0.0)),
          onPressed: onTap,
          icon: showArrow
              ? Icon(
                  Icons.done,
                  color: context.theme.colorScheme.onSurface,
                  size: 25,
                )
              : const SizedBox(
                  width: 25,
                  height: 25,
                ),
          label: Padding(
            padding: const EdgeInsets.only(left: 20),
            child: Text(
              text,
              style: TextStyle(
                  color: showArrow
                      ? context.theme.colorScheme.onSurface
                      : Colors.grey.shade600,
                  fontSize: 17,
                  fontWeight: FontWeight.w600),
            ),
          )),
    );
  }
}
