import 'package:flutter/material.dart';
import 'package:meiyou/core/utils/extenstions/context.dart';

void showSnackBAr(BuildContext context, {required String text, double? width}) {
  ScaffoldMessenger.of(context)
    ..clearSnackBars()
    ..showSnackBar(SnackBar(
      content: Text(text,
          textAlign: TextAlign.center,
          style: TextStyle(
              color: context.theme.colorScheme.onSurface,
              fontWeight: FontWeight.bold,
              fontSize: 16),
          maxLines: 2),
      backgroundColor: context.theme.colorScheme.background,
      //  duration: const Duration(milliseconds: 300),
      elevation: 10.0,
      //elevation: 1,
      //margin: const EdgeInsets.all(40),

      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      width: width ?? context.screenWidth / 1.2,

      behavior: SnackBarBehavior.floating,
    ));
}
