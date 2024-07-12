import 'package:flutter/material.dart';
import 'package:meiyou/presentation/theme/colorscheme/base_colorscheme.dart';

class DefaultColorScheme extends BaseColorScheme {
  @override
  final darkScheme = const ColorScheme.dark(
    primary: Color(0xFFB0C6FF),
    onPrimary: Color(0xFF002D6E),
    primaryContainer: Color(0xFF00429B),
    onPrimaryContainer: Color(0xFFD9E2FF),
    inversePrimary: Color(0xFF0058CA),
    secondary: Color(0xFFB0C6FF),
    onSecondary: Color(0xFF002D6E),
    secondaryContainer: Color(0xFF00429B),
    onSecondaryContainer: Color(0xFFD9E2FF),
    tertiary: Color(0xFF7ADC77),
    onTertiary: Color(0xFF003909),
    tertiaryContainer: Color(0xFF005312),
    onTertiaryContainer: Color(0xFF95F990),
    background: Color(0xFF1B1B1F),
    onBackground: Color(0xFFE3E2E6),
    surface: Color(0xFF1B1B1F),
    onSurface: Color(0xFFE3E2E6),
    surfaceVariant: Color(0xFF44464F),
    onSurfaceVariant: Color(0xFFC5C6D0),
    surfaceTint: Color(0xFFB0C6FF),
    inverseSurface: Color(0xFFE3E2E6),
    onInverseSurface: Color(0xFF1B1B1F),
    error: Color(0xFFFFB4AB),
  );
  @override
  final lightScheme = const ColorScheme.light(
    primary: Color(0xFF0058CA),
    onPrimary: Color(0xFFFFFFFF),
    primaryContainer: Color(0xFFD9E2FF),
    onPrimaryContainer: Color(0xFF001945),
    inversePrimary: Color(0xFFB0C6FF),
    secondary: Color(0xFF0058CA),
    onSecondary: Color(0xFFFFFFFF),
    secondaryContainer: Color(0xFFD9E2FF),
    onSecondaryContainer: Color(0xFF001945),
    tertiary: Color(0xFF006E1B),
    onTertiary: Color(0xFFFFFFFF),
    tertiaryContainer: Color(0xFF95F990),
    onTertiaryContainer: Color(0xFF002203),
    background: Color(0xFFFEFBFF),
    onBackground: Color(0xFF1B1B1F),
    surface: Color(0xFFFEFBFF),
    onSurface: Color(0xFF1B1B1F),
    surfaceVariant: Color(0xFFE1E2EC),
    onSurfaceVariant: Color(0xFF44464F),
    surfaceTint: Color(0xFF0058CA),
    inverseSurface: Color(0xFF303034),
    onInverseSurface: Color(0xFFF2F0F4),
    error: Color(0xFFBA1A1A),
  );
}
