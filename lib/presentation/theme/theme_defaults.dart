import 'package:flutter/material.dart';
import 'package:path/path.dart';

class MaterialThemeDeaults {
  static ThemeData to(ThemeData theme) {
    final colors = theme.colorScheme;

    return theme.copyWith(
      dividerTheme: DividerThemeData(
        color: colors.outline.withOpacity(0.38),
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        extendedPadding: const EdgeInsets.fromLTRB(15, 50, 15, 50),
      ),
      listTileTheme: ListTileThemeData(
        iconColor: colors.primary,
      ),
      switchTheme: SwitchThemeData(
        trackColor: MaterialStateProperty.resolveWith(
          (states) => states.contains(MaterialState.disabled)
              ? colors.surfaceVariant
              : null,
        ),
      ),
      segmentedButtonTheme: SegmentedButtonThemeData(
          style: ButtonStyle(
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        visualDensity: const VisualDensity(horizontal: -0.5, vertical: -0.5),
        side: MaterialStateProperty.resolveWith((Set<MaterialState> states) {
          if (states.contains(MaterialState.disabled)) {
            return BorderSide(color: colors.onSurface.withOpacity(0.12));
          }
          return BorderSide(color: colors.outline);
        }),
        backgroundColor: MaterialStateProperty.resolveWith(
          (states) {
            if (states.contains(MaterialState.selected)) {
              return theme.colorScheme.secondaryContainer;
            }
            return colors.background;
          },
        ),
      )),
    );
  }
}
