import 'package:flutter/material.dart';

class StreamifyElevatedButton extends StatelessWidget {
  final ButtonStyle style;
  final Widget? icon;
  final VoidCallback onTap;
  final String text;
  final TextStyle textStyle;
  const StreamifyElevatedButton(
      {super.key,
      required this.text,
      required this.onTap,
      this.textStyle = const TextStyle(
          fontSize: 17, fontWeight: FontWeight.w600, color: Colors.black),
      this.style = const ButtonStyle(
          backgroundColor: MaterialStatePropertyAll(Colors.white),
          overlayColor: MaterialStatePropertyAll(Colors.grey),
          iconColor: MaterialStatePropertyAll(Colors.black),
          iconSize: MaterialStatePropertyAll(25),
          fixedSize: MaterialStatePropertyAll(Size(100, 45))),
      this.icon});

  @override
  Widget build(BuildContext context) {
    return icon == null
        ? ElevatedButton(
            onPressed: onTap,
            style: style,
            child: DefaultTextStyle(style: textStyle, child: Text(text)))
        : ElevatedButton.icon(
            onPressed: onTap,
            style: style,
            icon: icon!,
            label: DefaultTextStyle(style: textStyle, child: Text(text)));
  }
}
