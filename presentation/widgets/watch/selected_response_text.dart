import 'package:flutter/material.dart';

class SelectedResponseText extends StatelessWidget {
  final String? text;
  const SelectedResponseText({super.key, this.text});

  static const style = TextStyle(fontSize: 14, fontWeight: FontWeight.bold);
  @override
  Widget build(BuildContext context) {
    return Container(
        alignment: Alignment.centerLeft,
        padding: const EdgeInsets.only(left: 50),
        child: text != null
            ? DefaultTextStyle(style: style, child: Text(text!))
            : const DefaultTextStyle(
                style: style, child: Text('Not Found: null')));
  }
}
