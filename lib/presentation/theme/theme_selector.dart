import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:meiyou/core/constants/font_size.dart';
import 'package:meiyou/core/utils/extensions/context.dart';
import 'package:meiyou/core/utils/resources/get_it/get_it.dart';
import 'package:meiyou/domain/ui/model/app_theme.dart';
import 'package:meiyou/presentation/common/notifers/theme_notifer.dart';
import 'package:meiyou/presentation/core/space.dart';
import 'package:meiyou/presentation/theme/colorscheme/base_colorscheme.dart';
import 'package:meiyou/presentation/theme/meiyou_theme.dart';
import 'package:path/path.dart';

class ThemeSelector extends StatelessWidget {
  final AppTheme currentAppTheme;
  final bool isAmoled;
  final ThemeMode themeMode;
  final void Function(AppTheme) onThemeSelected;
  final EdgeInsets? padding;
  const ThemeSelector({
    super.key,
    required this.onThemeSelected,
    required this.currentAppTheme,
    required this.isAmoled,
    required this.themeMode,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    // final themNotifer = getIt.get<ThemeNotifer>();
    final brightness = context.brightness;
    return SizedBox(
      height: 256,
      child: ListView.separated(
        padding: padding,
        scrollDirection: Axis.horizontal,
        itemCount: AppTheme.values.length,
        separatorBuilder: (context, index) => const HorizontalSpace(10),
        itemBuilder: (context, index) {
          final appTheme = AppTheme.values[index];
          final colorScheme = themeMode == ThemeMode.system
              ? getThemeColorScheme(brightness, appTheme, isAmoled)
              : getColorSchemeFromMode(themeMode, appTheme, isAmoled);
          final preview = themePreview(
            context,
            appTheme,
            colorScheme,
            appTheme == currentAppTheme,
          );
    
          return preview;
        },
      ),
    );
  }

  Widget themePreview(BuildContext context, AppTheme apptheme,
      ColorScheme colorScheme, bool isSelected) {
    const height = 256.0;
    const width = 120.0;

    return SizedBox(
      height: height,
      width: width,
      child: Column(
        children: [
          SizedBox(
            height: height - 56,
            width: width,
            child: Material(
              color: colorScheme.background,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(17),
                side: BorderSide(
                  color: isSelected
                      ? colorScheme.primary
                      : colorScheme.primary.withOpacity(0.5),
                  width: 4,
                ),
              ),
              type: MaterialType.canvas,
              clipBehavior: Clip.hardEdge,
              child: InkWell(
                onTap: () {
                  onThemeSelected(apptheme);
                },
                child: Padding(
                  padding: const EdgeInsets.all(4),
                  child: ClipRRect(
                    clipBehavior: Clip.hardEdge,
                    borderRadius: BorderRadius.circular(13),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SizedBox(
                          height: 40,
                          child: Padding(
                            padding: const EdgeInsets.all(8),
                            child: Row(
                              children: [
                                Flexible(
                                  child: Container(
                                    height: 20,
                                    decoration: BoxDecoration(
                                      color: colorScheme.onSurfaceVariant,
                                      borderRadius: BorderRadius.circular(30),
                                    ),
                                  ),
                                ),
                                const HorizontalSpace(10),
                                if (isSelected)
                                  Icon(
                                    Icons.check_circle_rounded,
                                    color: colorScheme.primary,
                                  ),
                              ],
                            ),
                          ),
                        ),
                        Container(
                          height: 72,
                          width: 52,
                          margin: const EdgeInsets.only(
                            left: 8,
                          ),
                          decoration: BoxDecoration(
                            color: colorScheme.surfaceVariant,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          padding: const EdgeInsets.only(
                            left: 5,
                            top: 5,
                          ),
                          alignment: Alignment.topLeft,
                          child: SizedBox(
                            width: 24,
                            child: ClipRRect(
                              clipBehavior: Clip.hardEdge,
                              borderRadius: BorderRadius.circular(5),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    height: 18,
                                    width: 12,
                                    color: colorScheme.tertiary,
                                  ),
                                  Container(
                                    height: 18,
                                    width: 12,
                                    color: colorScheme.secondary,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        Flexible(
                          child: Align(
                            alignment: Alignment.bottomCenter,
                            child: Container(
                              color: colorScheme.surfaceVariant,
                              height: 30,
                              padding: const EdgeInsets.fromLTRB(8, 5, 8, 5),
                              child: Row(
                                children: [
                                  Container(
                                    height: 17,
                                    width: 17,
                                    decoration: BoxDecoration(
                                        color: colorScheme.primary,
                                        shape: BoxShape.circle),
                                  ),
                                  const HorizontalSpace(10),
                                  Expanded(
                                    child: Container(
                                      height: 17,
                                      decoration: BoxDecoration(
                                        color: Color.lerp(colorScheme.onSurface,
                                            colorScheme.surface, 0.3),
                                        borderRadius: BorderRadius.circular(30),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(8),
            alignment: Alignment.center,
            child: Text(
              apptheme.toDisplayString(),
              textAlign: TextAlign.center,
              style: TextStyle(
                color: colorScheme.onSurface,
                fontSize: MobileFontSize.normal,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
