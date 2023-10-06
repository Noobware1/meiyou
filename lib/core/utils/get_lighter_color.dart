import 'package:flutter/material.dart';

Color getLighterColor(Color originalColor, [double factor = 0.1]) {
  final hsl = HSLColor.fromColor(originalColor);
  return hsl.withLightness((hsl.lightness + factor).clamp(0.0, 1.0)).toColor();
}
