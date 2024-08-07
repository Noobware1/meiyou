import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:meiyou/core/utils/extensions/context.dart';

class PlayerThemeData {
  PlayerThemeData(BuildContext context) : _context = context;

  final BuildContext _context;

  late final _textTheme = _context.theme.textTheme;

  late final _colorScheme = _context.theme.colorScheme;

  TextStyle get timeLabelTextStyle => _textTheme.bodyMedium!;

  Color get bufferedBarColor => _colorScheme.onSurface;

  static const _baseBarColor = Color(0x3DFFFFFF);

  final Color backgroundColor = Colors.black.withOpacity(0.6);

  Color get baseBarColor => _baseBarColor;

  Color get progressBarColor => _colorScheme.primary;

  Color get thumbColor => _colorScheme.primary;

  final double seekBarHeight = 2.0;

  final Color thumbGlowColor = Colors.transparent;

  final TimeLabelLocation timeLabelLocation = TimeLabelLocation.sides;

  static const _playButtonSize = Size(75.0, 75.0);

  Size get playButtonSize => _playButtonSize;

  final ButtonStyle playButtonStyle = const ButtonStyle(
    fixedSize: WidgetStatePropertyAll(_playButtonSize),
    iconSize: WidgetStatePropertyAll(55.0),
    shape: WidgetStatePropertyAll(CircleBorder()),
  );

  final double playButtonIconSize = 55.0;

  final Color playButtonIconColor = Colors.white;

  final double loadingIndicatorSize = 35.0;

  final EdgeInsets minimumPadding = const EdgeInsets.all(8.0);

  late final titleTextStyle = _textTheme.bodyMedium!.copyWith(
    color: Colors.white,
    fontWeight: FontWeight.w600,
  );

  late final subtitleTextStyle =
      _textTheme.bodySmall!.copyWith(color: Colors.grey);

  late final double forwardRewindButtonSize = 70;

  late final forwardRewindButtonTextStyle = _textTheme.titleMedium!.copyWith(
    color: Colors.white,
    fontWeight: FontWeight.bold,
  );

  IconData get showMediaContentListIcon => Icons.video_library_rounded;

  Color get iconColor => Colors.white;

  Size get nextPreviousButtonSize => _playButtonSize;

  late final ButtonStyle nextPreviousButtonStyle = ButtonStyle(
    fixedSize: const WidgetStatePropertyAll(_playButtonSize),
    iconSize: WidgetStatePropertyAll(playButtonIconSize),
    iconColor: WidgetStateProperty.resolveWith((states) {
      if (!states.contains(WidgetState.disabled)) {
        return iconColor;
      }
      return null;
    }),
    shape: const WidgetStatePropertyAll(CircleBorder()),
  );

  final double nextPreviousButtonSpacing = 35.0;

  late final videoSettingsTextStyle = _textTheme.bodyMedium!;

  late final videoSettingsSelectedTextStyle = videoSettingsTextStyle.copyWith(
    color: _colorScheme.primary,
    fontStyle: FontStyle.italic,
  );

  static const _videoSettingsPadding = EdgeInsets.fromLTRB(20, 10, 20, 10);

  EdgeInsets get videoSettingsPadding => _videoSettingsPadding;
}
