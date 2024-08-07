import 'package:flutter/material.dart' as m;

class AlertDialog extends m.StatelessWidget {
  final String? title;
  final m.Widget? content;
  final bool showCancelAction;
  final bool scrollable;
  final List<m.Widget> actions;

  const AlertDialog({
    super.key,
    this.title,
    this.content,
    this.showCancelAction = true,
    this.scrollable = false,
    this.actions = const [],
  });

  @override
  m.Widget build(m.BuildContext context) {
    return m.AlertDialog.adaptive(
      insetPadding: const m.EdgeInsets.symmetric(horizontal: 15, vertical: 24),
      title: title == null ? null : m.Text(title!),
      content: content!,
      scrollable: scrollable,
      actions: <m.Widget>[
        if (showCancelAction)
          m.TextButton(
            onPressed: () {
              m.Navigator.of(context).pop();
            },
            child: const m.Text('Cancel'),
          ),
        ...actions,
      ],
    );
  }
}
