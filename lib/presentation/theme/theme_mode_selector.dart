import 'package:flutter/material.dart';
import 'package:meiyou/core/constants/font_size.dart';
import 'package:meiyou/core/utils/extensions/context.dart';
import 'package:meiyou/presentation/core/space.dart';

class ThemeModeSelector extends StatelessWidget {
  final ThemeMode themeMode;
  final Color? borderColor;
  final void Function(ThemeMode) onThemeModeSelected;

  const ThemeModeSelector(
      {super.key,
      this.borderColor,
      required this.themeMode,
      required this.onThemeModeSelected});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: SegmentedButton<ThemeMode>(
        segments: const [
          ButtonSegment<ThemeMode>(
              value: ThemeMode.system, label: Text('System')),
          ButtonSegment<ThemeMode>(
              value: ThemeMode.light, label: Text('Light')),
          ButtonSegment<ThemeMode>(value: ThemeMode.dark, label: Text('Dark')),
        ],
        selected: {themeMode},
        onSelectionChanged: (themeModeSet) {
          onThemeModeSelected(themeModeSet.first);
        },
      ),
    );
  }
}
