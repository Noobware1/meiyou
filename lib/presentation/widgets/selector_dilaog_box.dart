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
        child: LayoutBuilder(
            // stream: null,
            builder: (context, constraints) {
          return Container(
            padding: const EdgeInsets.all(10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Expanded(
                  child: Visibility(
                    visible: isSelected,
                    replacement: const SizedBox(
                      height: 30,
                      width: 30,
                    ),
                    child: const Align(
                      alignment: Alignment.bottomLeft,
                      child: Icon(
                        Icons.done,
                        size: 30,
                      ),
                    ),
                  ),
                ),
                Expanded(flex: 3, child: child)
              ],
            ),
          );
        }),
      ),
    );
  }
}

typedef ArrowSelectorTextBuilder<T> = String Function(
    BuildContext context, int index, T data);

class ArrowSelectorDialogBox<T> extends StatefulWidget {
  final T defaultValue;

  final ArrowSelectorTextBuilder<T> builder;
  final List<T> data;
  final String label;

  final void Function(T value) onApply;
  final void Function() onCancel;

  const ArrowSelectorDialogBox(
      {super.key,
      required this.defaultValue,
      required this.label,
      required this.builder,
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

    return Container(
      constraints: isMobile
          ? const BoxConstraints(maxWidth: 300, maxHeight: 300, minHeight: 20)
          : const BoxConstraints(maxWidth: 350, maxHeight: 350, minHeight: 20),
      child: Column(
        // crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Padding(
            padding: const EdgeInsets.all(10),
            child: Text(
              widget.label,
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w600),
            ),
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
                    children: List.generate(
                        widget.data.length,
                        (index) => ArrowButton(
                            isSelected: selected == widget.data[index],
                            child: Text(
                              widget.builder(
                                  context, index, widget.data[index]),

                              // textAlign: TextAlign.start,
                              style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  color: selected == widget.data[index]
                                      ? null
                                      : Colors.grey,
                                  fontSize: 18),
                            ),
                            onTap: () {
                              setState(() {
                                selected = widget.data[index];
                              });
                            }))

                    // [
                    //   ArrowButton(
                    //       isSelected: selected == widget.videoTracks[0],
                    //       text: 'Auto',
                    //       onTap: () {
                    //         setState(() {
                    
                    
                    
                    
                    
                    
                    
                    
                    
                    
                    
                    
                    //           selected = widget.videoTracks[0];
                    //         });
                    //       }),
                    //   ...widget.videoTracks.sublist(2).map((it) {
                    //     final isSame = selected == it;
                    //     return ArrowButton(
                    //         isSelected: isSame,
                    //         text: '${it.w}x${it.h}',
                    //         onTap: () {
                    //           setState(() {
                    //             selected = it;
                    //           });
                    //         });
                    //   })
                    // ],
                    ),
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

  final Widget Function(BuildContext context, int index, T element) builder;
  final List<T> data;
  final String? label;
  final void Function(T value) onSelected;
  const ArrowSelectorListView({
    super.key,
    required this.defaultValue,
    this.label,
    required this.builder,
    required this.data,
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
    // print(player(context).state.track.video);

    return Container(
      constraints: isMobile
          ? const BoxConstraints(maxWidth: 300, maxHeight: 300, minHeight: 20)
          : const BoxConstraints(maxWidth: 350, maxHeight: 350, minHeight: 20),
      child: Column(
        // crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (widget.label != null) ...[
            Padding(
              padding: const EdgeInsets.all(10),
              child: Text(
                widget.label!,
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w600),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
          ],
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
                    children: List.generate(
                        widget.data.length,
                        (index) => ArrowButton(
                            isSelected: selected == widget.data[index],
                            child: widget.builder(
                                context, index, widget.data[index]),
                            onTap: () {
                              setState(() {
                                selected = widget.data[index];
                                widget.onSelected(selected);
                              });
                            }))),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
