import 'package:flutter/material.dart';

class CustomAlertDialog extends StatelessWidget {
  final String? title;
  final Widget? content;
  final bool showCancelButton;
  final List<Widget> actions;
  const CustomAlertDialog({
    super.key,
    this.title,
    this.content,
    this.showCancelButton = true,
    this.actions = const [],
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog.adaptive(
      insetPadding: const EdgeInsets.symmetric(horizontal: 15),
      title: title == null ? null : Text(title!),
      content: content!,
      
      actions: <Widget>[
        if (showCancelButton)
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('Cancel'),
          ),
        ...actions,
      ],
    );
  }
}
