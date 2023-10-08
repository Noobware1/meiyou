import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:meiyou/core/utils/extenstions/context.dart';

Size calcTextSize(BuildContext context, String text, TextStyle style) {
  final TextPainter textPainter = TextPainter(
    text: TextSpan(text: text, style: style),
    textDirection: TextDirection.ltr,
    maxLines: 3,
  )..layout(maxWidth: context.screenWidth);
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
      //  duration: const Duration(milliseconds: 300),
      elevation: 10.0,
      //elevation: 1,
      //margin: const EdgeInsets.all(40),

      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      // width: calcTextSize(context, text, textStyle).width,
      width:  width ?? context.screenWidth / 1.2,

      behavior: SnackBarBehavior.floating,
    ));
}
