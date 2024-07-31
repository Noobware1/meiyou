import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:flutter/material.dart';
import 'package:meiyou/core/utils/extensions/context.dart';

class PlayerThemeData {
  PlayerThemeData(BuildContext context) : _context = context;

  final BuildContext _context;

  late final _textTheme = _context.theme.textTheme;

  late final _colorScheme = _context.theme.colorScheme;

  TextStyle get timeLabelTextStyle => _textTheme.bodyLarge!;

  Color get bufferedBarColor => _colorScheme.onSurface;

  static const _baseBarColor = Color(0x3DFFFFFF);

  Color get baseBarColor => _baseBarColor;

  Color get progressBarColor => _colorScheme.primary;

  Color get thumbColor => _colorScheme.primary;

  final double seekBarHeight = 2.0;

  final Color thumbGlowColor = Colors.transparent;

  final TimeLabelLocation timeLabelLocation = TimeLabelLocation.sides;

  static const _playButtonSize = Size(75.0, 75.0);

  Size get playButtonSize => _playButtonSize;

  final playButtonStyle = const ButtonStyle(
    fixedSize: WidgetStatePropertyAll(_playButtonSize),
    iconSize: WidgetStatePropertyAll(55.0),
    shape: WidgetStatePropertyAll(CircleBorder()),
  );

  final double playButtonIconSize = 55.0;

  final Color playButtonIconColor = Colors.white;
}
