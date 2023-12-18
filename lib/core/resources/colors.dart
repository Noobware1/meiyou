import 'package:flutter/material.dart';
import 'package:meiyou/core/utils/extenstions/context.dart';

Color getBaseColorFromThemeMode(BuildContext context) {
  if (context.isDarkMode) {
    return Colors.white54;
  } else {
    return Colors.black54;
  }
}
