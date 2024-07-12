import 'package:flutter/material.dart';
import 'package:meiyou/presentation/theme/colorscheme/base_colorscheme.dart';

class SapphireColorScheme extends BaseColorScheme {
  @override
  final darkScheme = const ColorScheme.dark(
    primary: Color(0xFF1E88E5),
    onPrimary: Color(0xFFFAFAFA),
    primaryContainer: Color(0xFF1E88E5),
    onPrimaryContainer: Color(0xFFFAFAFA),
    inversePrimary: Color(
        0xFF2979FF), // Assuming 'inversePrimary' maps to 'sapphire_primaryInverse'
    secondary: Color(0xFF1E88E5),
    onSecondary: Color(0xFFFAFAFA),
    secondaryContainer: Color(0xFF1E88E5),
    onSecondaryContainer: Color(0xFFFAFAFA),
    tertiary: Color(0xFF212121),
    onTertiary: Color(0xFF1E88E5),
    tertiaryContainer: Color(0xFF212121),
    onTertiaryContainer: Color(0xFF1E88E5),
    background: Color(0xFF212121),
    onBackground: Color(0xFFFFFFFF),
    surface: Color(0xFF212121),
    onSurface: Color(0xFFFFFFFF),
    surfaceVariant: Color(0xFF424242),
    onSurfaceVariant: Color(0xFFD8FFFFFF),
    surfaceTint: Color(
        0xFF1E88E5), // Assuming 'surfaceTint' maps to 'sapphire_primary' or similar
    inverseSurface: Color(0xFFFAFAFA),
    onInverseSurface: Color(0xFF313131),
    outline: Color(0xFF1E88E5),
  );
  @override
  final lightScheme = const ColorScheme.light(
    primary: Color(0xFF1E88E5),
    onPrimary: Color(0xFFFFFFFF),
    primaryContainer: Color(0xFF1E88E5),
    onPrimaryContainer: Color(0xFFFFFFFF),
    inversePrimary: Color(
        0xFF2979FF), // Assuming 'inversePrimary' maps to 'sapphire_primaryInverse'
    secondary: Color(0xFF1E88E5),
    onSecondary: Color(0xFFFFFFFF),
    secondaryContainer: Color(0xFF1E88E5),
    onSecondaryContainer: Color(0xFFFFFFFF),
    tertiary: Color(0xFFE1F5FE),
    onTertiary: Color(0xFF1E88E5),
    tertiaryContainer: Color(0xFFE1F5FE),
    onTertiaryContainer: Color(0xFF1E88E5),
    background: Color(0xFFFFFFFF),
    onBackground: Color(0xFF212121),
    surface: Color(0xFFFFFFFF),
    onSurface: Color(0xFF212121),
    surfaceVariant: Color(0xFFB3E5FC),
    onSurfaceVariant: Color(0xFFD849454E),
    surfaceTint: Color(
        0xFF1E88E5), // Assuming 'surfaceTint' maps to 'sapphire_primary' or similar
    inverseSurface: Color(0xFF424242),
    onInverseSurface: Color(0xFFFAFAFA),
    outline: Color(0xFF1E88E5),
  );
}
