import 'package:flutter/material.dart';
import 'package:meiyou/core/constants/plaform_check.dart';
import 'package:meiyou/presentation/player/video_controls/arrow_selector.dart';
import 'apply_cancel.dart';

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
                            text: widget.builder(
                                context, index, widget.data[index]),
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
