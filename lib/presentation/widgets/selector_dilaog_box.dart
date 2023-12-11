import 'package:flutter/material.dart';
import 'package:meiyou/core/resources/platform_check.dart';
import '../../../presentation/widgets/apply_cancel.dart';

class ArrowButton extends StatelessWidget {
  final VoidCallback onTap;
  final bool isSelected;

  final Widget child;
  const ArrowButton({
    super.key,
    required this.isSelected,
    required this.child,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      animationDuration: const Duration(milliseconds: 200),
      type: MaterialType.transparency,
      child: InkWell(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Expanded(
                child: Visibility(
                  visible: isSelected,
                  replacement: const SizedBox(
                    height: 25,
                    width: 25,
                  ),
                  child: const Align(
                    alignment: Alignment.bottomLeft,
                    child: Icon(
                      Icons.done,
                      size: 25,
                    ),
                  ),
                ),
              ),
              Expanded(flex: 4, child: child)
            ],
          ),
        ),
      ),
    );
  }
}

typedef ArrowSelectorTextBuilder<T> = String Function(
    BuildContext context, int index, T data);

class ArrowSelectorDialogBox<T> extends StatefulWidget {
  final T defaultValue;

  final ArrowSelectorTextBuilder<T> builder;
  final bool Function(T defaultValue, T value)? isSelected;
  final List<T> data;
  final String label;

  final void Function(T value) onApply;
  final void Function() onCancel;

  const ArrowSelectorDialogBox(
      {super.key,
      required this.defaultValue,
      required this.label,
      required this.builder,
      this.isSelected,
      required this.data,
      required this.onApply,
      required this.onCancel});

  @override
  State<ArrowSelectorDialogBox<T>> createState() =>
      _ArrowSelectorDialogBoxState<T>();
}

class _ArrowSelectorDialogBoxState<T> extends State<ArrowSelectorDialogBox<T>> {
  late final ScrollController _controller;
  late T selected;

  @override
  void initState() {
    _controller = ScrollController();
    selected = widget.defaultValue;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // print(player(context).state.track.video);

    return ConstrainedBox(
      constraints: isMobile
          ? const BoxConstraints(maxWidth: 300, maxHeight: 300, minHeight: 20)
          : const BoxConstraints(maxWidth: 350, maxHeight: 350, minHeight: 20),
      child: Column(
        // crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(10, 10, 10, 5),
            child: Text(
              widget.label,
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 19.5,
                  fontWeight: FontWeight.w600),
            ),
          ),
          const Divider(
            thickness: 1,
          ),
          const SizedBox(
            height: 10,
          ),
          Expanded(
            child: ScrollbarTheme(
              data: const ScrollbarThemeData(
                  thickness: MaterialStatePropertyAll(5.0),
                  thumbColor: MaterialStatePropertyAll(Colors.grey)),
              child: Scrollbar(
                // thumbVisibility: true,
                controller: _controller,
                child: ListView(
                    controller: _controller,
                    shrinkWrap: true,
                    children: List.generate(widget.data.length, (index) {
                      final bool isSelected = widget.isSelected
                              ?.call(selected, widget.data[index]) ??
                          selected == widget.data[index];
                      return ArrowButton(
                          isSelected: isSelected,
                          child: Text(
                            widget.builder(context, index, widget.data[index]),

                            // textAlign: TextAlign.start,
                            style: TextStyle(
                                fontWeight: FontWeight.w600,
                                color: isSelected ? null : Colors.grey,
                                fontSize: 16),
                          ),
                          onTap: () {
                            setState(() {
                              selected = widget.data[index];
                            });
                          });
                    })),
              ),
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
                      onApply: () => widget.onApply.call(selected),
                      onCancel: widget.onCancel,
                    )),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ArrowSelectorListView<T> extends StatefulWidget {
  final T defaultValue;

  final String Function(BuildContext context, int index, T element) builder;
  final List<T> data;

  final String? label;
  final CrossAxisAlignment? crossAxisAlignment;

  final void Function(T value) onSelected;
  const ArrowSelectorListView({
    super.key,
    required this.defaultValue,
    this.label,
    required this.builder,
    required this.data,
    this.crossAxisAlignment,
    required this.onSelected,
  });

  @override
  State<ArrowSelectorListView<T>> createState() =>
      _ArrowSelectorListViewState<T>();
}

class _ArrowSelectorListViewState<T> extends State<ArrowSelectorListView<T>> {
  late final ScrollController _controller;
  late T selected;

  @override
  void initState() {
    _controller = ScrollController();
    selected = widget.defaultValue;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: isMobile
          ? const BoxConstraints(maxWidth: 300, maxHeight: 260, minHeight: 20)
          : const BoxConstraints(maxWidth: 350, maxHeight: 290, minHeight: 20),
      child: Column(
        crossAxisAlignment: widget.crossAxisAlignment ?? CrossAxisAlignment.end,
        children: [
          if (widget.label != null) ...[
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 10, 10, 5),
              child: Text(
                widget.label!,
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 19.5,
                    fontWeight: FontWeight.w600),
              ),
            ),
            const Divider(
              thickness: 1,
            ),
          ],
          const SizedBox(
            height: 10,
          ),
          Expanded(
            child: ScrollbarTheme(
              data: const ScrollbarThemeData(
                  thickness: MaterialStatePropertyAll(5.0),
                  thumbColor: MaterialStatePropertyAll(Colors.grey)),
              child: Scrollbar(
                // thumbVisibility: true,
                controller: _controller,
                child: ListView(
                    controller: _controller,
                    shrinkWrap: true,
                    children: List.generate(widget.data.length, (index) {
                      final bool isSelected = selected == widget.data[index];
                      return ArrowButton(
                          isSelected: isSelected,
                          child: Text(
                            widget.builder(context, index, widget.data[index]),

                            // textAlign: TextAlign.start,
                            style: TextStyle(
                                fontWeight: FontWeight.w600,
                                color: isSelected ? null : Colors.grey,
                                fontSize: 16),
                          ),
                          onTap: () {
                            setState(() {
                              selected = widget.data[index];
                            });
                            widget.onSelected(selected);
                          });
                    })),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
