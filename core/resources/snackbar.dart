import 'package:flutter/material.dart';
import 'package:meiyou/core/utils/extenstions/context.dart';

Size calcTextSize(BuildContext context, String text, TextStyle style) {
  final TextPainter textPainter = TextPainter(
    text: TextSpan(text: text, style: style),
    textAlign: TextAlign.center,
    textDirection: TextDirection.ltr,
    maxLines: 3,
  )..layout(maxWidth: context.screenWidth, minWidth: 84);
  return textPainter.size;
}

void showSnackBAr(BuildContext context, {required String text, double? width}) {
  final textStyle = TextStyle(
      color: context.theme.colorScheme.onSurface,
      fontWeight: FontWeight.bold,
      fontSize: 16);

  ScaffoldMessenger.of(context)
    ..clearSnackBars()
    ..showSnackBar(SnackBar(
      content: Text(text,
          textAlign: TextAlign.center, style: textStyle, maxLines: 3),
      backgroundColor: context.theme.colorScheme.background,
      elevation: 10.0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      width: calcTextSize(context, text, textStyle).width * 1.2,
      behavior: SnackBarBehavior.floating,
    ));
}
