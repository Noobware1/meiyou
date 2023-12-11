import 'package:flutter/material.dart';

class ImageText extends StatelessWidget {
  final String text;
  final TextStyle? textStyle;
  const ImageText({super.key, this.text = 'No Title', this.textStyle});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: TextAlign.left,
      style: textStyle?.copyWith(overflow: TextOverflow.ellipsis) ??
          _defaultTextStyle,
      maxLines: 2,
    );
  }

  static const _defaultTextStyle = TextStyle(
    fontSize: 11,
    fontWeight: FontWeight.w600,
    overflow: TextOverflow.ellipsis,
  );
}
