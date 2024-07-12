import 'package:flutter/material.dart';
import 'package:meiyou/presentation/theme/colorscheme/base_colorscheme.dart';

class GreenAppleColorScheme extends BaseColorScheme {
  @override
  final darkScheme = const ColorScheme.dark(
    primary: Color(0xFF7ADB8F),
    onPrimary: Color(0xFF003915),
    primaryContainer: Color(0xFF005322),
    onPrimaryContainer: Color(0xFF96F8A9),
    inversePrimary: Color(0xFF006D2F),
    secondary: Color(0xFF7ADB8F),
    onSecondary: Color(0xFF003915),
    secondaryContainer: Color(0xFF005322),
    onSecondaryContainer: Color(0xFF96F8A9),
    tertiary: Color(0xFFFFB3AA),
    onTertiary: Color(0xFF680006),
    tertiaryContainer: Color(0xFF93000D),
    onTertiaryContainer: Color(0xFFFFDAD5),
    background: Color(0xFF1A1C19),
    onBackground: Color(0xFFE1E3DD),
    surface: Color(0xFF1A1C19),
    onSurface: Color(0xFFE1E3DD),
    surfaceVariant: Color(0xFF414941),
    onSurfaceVariant: Color(0xFFC1C8BE),
    surfaceTint: Color(0xFF7ADB8F),
    inverseSurface: Color(0xFFE1E3DD),
    onInverseSurface: Color(0xFF1A1C19),
    outline: Color(0xFF8B9389),
  );

  @override
  final lightScheme = const ColorScheme.light(
    primary: Color(0xFF006D2F),
    onPrimary: Color(0xFFFFFFFF),
    primaryContainer: Color(0xFF96F8A9),
    onPrimaryContainer: Color(0xFF002109),
    inversePrimary: Color(0xFF7ADB8F),
    secondary: Color(0xFF006D2F),
    onSecondary: Color(0xFFFFFFFF),
    secondaryContainer: Color(0xFF96F8A9),
    onSecondaryContainer: Color(0xFF002109),
    tertiary: Color(0xFFB91D22),
    onTertiary: Color(0xFFFFFFFF),
    tertiaryContainer: Color(0xFFFFDAD5),
    onTertiaryContainer: Color(0xFF410003),
    background: Color(0xFFFBFDF7),
    onBackground: Color(0xFF1A1C19),
    surface: Color(0xFFFBFDF7),
    onSurface: Color(0xFF1A1C19),
    surfaceVariant: Color(0xFFDDE5DA),
    onSurfaceVariant: Color(0xFF414941),
    surfaceTint: Color(0xFF006D2F),
    inverseSurface: Color(0xFF2F312E),
    onInverseSurface: Color(0xFFF0F2EC),
    outline: Color(0xFF717970),
  );
}
