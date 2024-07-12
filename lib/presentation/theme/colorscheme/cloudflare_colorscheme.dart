import 'package:flutter/material.dart';
import 'package:meiyou/presentation/theme/colorscheme/base_colorscheme.dart';

class CloudflareColorScheme extends BaseColorScheme {
  @override
  final darkScheme = const ColorScheme.dark(
    primary: Color(0xFFF38020),
    onPrimary: Color(0xFF1B1B22),
    primaryContainer: Color(0xFFF38020),
    onPrimaryContainer: Color(0xFF1B1B22),
    inversePrimary: Color(
        0xFFD6BAFF), // Assuming 'inversePrimary' maps to 'cloudflare_primaryInverse'
    secondary: Color(0xFFF38020),
    onSecondary: Color(0xFF1B1B22),
    secondaryContainer: Color(0xFFF38020),
    onSecondaryContainer: Color(0xFF1B1B22),
    tertiary: Color(0xFF1B1B22),
    onTertiary: Color(0xFFF38020),
    tertiaryContainer: Color(0xFF1B1B22),
    onTertiaryContainer: Color(0xFFF38020),
    background: Color(0xFF1B1B22),
    onBackground: Color(0xFFEFF2F5),
    surface: Color(0xFF1B1B22),
    onSurface: Color(0xFFEFF2F5),
    surfaceVariant: Color(0xFF3F3F46),
    onSurfaceVariant: Color(0xffd8ffffff),
    surfaceTint: Color(
        0xFFF38020), // Assuming 'surfaceTint' maps to 'cloudflare_primary' or similar
    inverseSurface: Color(0xFFF3EFF4),
    onInverseSurface: Color(0xFF313033),
    outline: Color(0xFFF38020),
  );

  @override
  final lightScheme = const ColorScheme.light(
    primary: Color(0xFFF38020),
    onPrimary: Color(0xFFEFF2F5),
    primaryContainer: Color(0xFFF38020),
    onPrimaryContainer: Color(0xFFEFF2F5),
    inversePrimary: Color(0xFFD6BAFF),
    secondary: Color(0xFFF38020),
    onSecondary: Color(0xFFEFF2F5),
    secondaryContainer: Color(0xFFF38020),
    onSecondaryContainer: Color(0xFFEFF2F5),
    tertiary: Color(0xFFEFF2F5),
    onTertiary: Color(0xFFF38020),
    tertiaryContainer: Color(0xFFEFF2F5),
    onTertiaryContainer: Color(0xFFF38020),
    background: Color(0xFFEFF2F5),
    onBackground: Color(0xFF1B1B22),
    surface: Color(0xFFEFF2F5),
    onSurface: Color(0xFF1B1B22),
    surfaceVariant: Color(0xFFB9B0CC),
    onSurfaceVariant: Color(0xFFD849454E),
    surfaceTint: Color(0xFFF38020),
    inverseSurface: Color(0xFF313033),
    onInverseSurface: Color(0xFFF3EFF4),
    outline: Color(0xFFF38020),
  );
}
