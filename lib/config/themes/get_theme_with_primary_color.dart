import 'package:flutter/material.dart';

ThemeData getThemeWithPrimaryColor(Color primaryColor, bool dark) {
  if (dark) {
    return ThemeData(
        colorScheme: ColorScheme.dark(
      onPrimary: const Color(0xff121212),
      secondary: const Color(0xff121212),
      primary: primaryColor,
      onSecondary: const Color(0xff121212),
      background: Colors.black,
      surface: Colors.black,
    ));
  }
  return ThemeData(
      colorScheme: ColorScheme.light(
          secondary: const Color(0xFFEEEFEF),
          onPrimary: Colors.black,
          primary: primaryColor,
          tertiary: const Color(0xFFEEEFEF)));
}



