import 'dart:math';

import 'package:flutter/material.dart';
import 'package:meiyou/core/utils/extensions/context.dart';
import 'package:meiyou/presentation/core/dilog_box/alert_dialog_box.dart';

class TextFieldDialog extends StatefulWidget {
  final void Function(String) onSubmitted;
  final String title;
  final String? text;
  final String submitButtonText;
  final bool autoFocus;
  final String? Function(String)? validator;
  const TextFieldDialog({
    super.key,
    required this.onSubmitted,
    required this.title,
    required this.submitButtonText,
    this.autoFocus = false,
    this.validator,
    this.text,
  });

  @override
  State<TextFieldDialog> createState() => _TextFieldDialogState();
}

class _TextFieldDialogState extends State<TextFieldDialog> {
  late final TextEditingController controller;
  String? error;
  bool sumbitButtonEnabled = false;

  @override
  void initState() {
    super.initState();
    controller = TextEditingController(
      text: widget.text,
    );
    if (widget.validator != null) {
      controller.addListener(() {
        final text = controller.text;
        final error = widget.validator!(text);
        final shouldEnableSumbitButton = error == null && text.isNotEmpty;
        if (error != this.error) {
          setState(() {
            this.error = error;
            sumbitButtonEnabled = shouldEnableSumbitButton;
          });
        }
        if (sumbitButtonEnabled != shouldEnableSumbitButton) {
          setState(() {
            sumbitButtonEnabled = shouldEnableSumbitButton;
          });
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return CustomAlertDialog(
      title: widget.title,
      actions: [
        TextButton(
          onPressed: !sumbitButtonEnabled
              ? null
              : () {
                  widget.onSubmitted(controller.text);
                },
          child: Text(widget.submitButtonText),
        )
      ],
      content: Padding(
        padding: const EdgeInsets.only(top: 10),
        child: SizedBox(
          width: min(context.width * 0.9, 400),
          child: TextField(
            onSubmitted: (value) {
              if (value.isNotEmpty) {
                widget.onSubmitted(value);
              } else {
                return;
              }
            },
            controller: controller,
            autofocus: widget.autoFocus,
            decoration: InputDecoration(
              labelText: 'Name',
              contentPadding: const EdgeInsets.fromLTRB(12, 16, 12, 16),
              counterText: '*required',
              errorText: error,
              border: const OutlineInputBorder(
                  gapPadding: 1,
                  borderRadius: BorderRadius.all(Radius.circular(5))),
            ),
          ),
        ),
      ),
    );
  }
}
