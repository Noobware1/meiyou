import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meiyou/core/utils/player_utils.dart';
import 'package:meiyou/presentation/widgets/apply_cancel.dart';

class SelectorDialogBox extends StatefulWidget {
  final List<Widget> children;
  final String? label;
  final VoidCallback? onApply;
  final VoidCallback? onCancel;

  const SelectorDialogBox(
      {super.key,
      required this.children,
      this.label,
      this.onApply,
      this.onCancel});

  @override
  State<SelectorDialogBox> createState() => _SelectorDialogBoxState();

  static Future showDialogBox(
    BuildContext context, {
    required List<Widget> children,
    VoidCallback? onApply,
    VoidCallback? onCancel,
  }) {
    return showDialog(
        context: context,
        builder: (context) {
          return Dialog(
            elevation: 10,
            backgroundColor: Colors.black,
            child: RepositoryProvider.value(
              value: player,
              child: SelectorDialogBox(
                children: children,
                onApply: () {
                  onApply?.call();
                  Navigator.pop(context);
                },
                onCancel: () {
                  onCancel?.call();
                  Navigator.pop(context);
                },
              ),
            ),
          );
        });
  }
}

class _SelectorDialogBoxState extends State<SelectorDialogBox> {
  late final ScrollController _controller;

  @override
  void initState() {
    _controller = ScrollController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // print(player(context).state.track.video);

    return Container(
      constraints:
          const BoxConstraints(maxWidth: 300, maxHeight: 300, minHeight: 20),
      child: Column(
        // crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Padding(
            padding: const EdgeInsets.all(10),
            child: Text(
              widget.label ?? 'Select',
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
                    children: widget.children),
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomRight,
            child: Container(
              width: 200,
              height: 50,
              alignment: Alignment.bottomRight,
              child: Padding(
                  padding: const EdgeInsets.only(right: 10),
                  child: AppyCancel(
                    onApply: widget.onApply ?? () {},
                    onCancel: widget.onCancel ?? () {},
                  )),
            ),
          ),
        ],
      ),
    );
  }
}
