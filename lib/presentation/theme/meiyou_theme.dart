import 'package:flutter/material.dart';
import 'package:meiyou/core/utils/extensions/context.dart';
import 'package:meiyou/core/utils/resources/get_it/get_it.dart';
import 'package:meiyou/domain/ui/model/app_theme.dart';
import 'package:meiyou/presentation/theme/colorscheme/base_colorscheme.dart';
import 'package:meiyou/presentation/theme/colorscheme/cloudflare_colorscheme.dart';
import 'package:meiyou/presentation/theme/colorscheme/cotton_candy_colorscheme.dart';
import 'package:meiyou/presentation/theme/colorscheme/default_colorscheme.dart';
import 'package:meiyou/presentation/theme/colorscheme/doom_colorscheme.dart';
import 'package:meiyou/presentation/theme/colorscheme/green_apple_colorscheme.dart';
import 'package:meiyou/presentation/theme/colorscheme/lavender_colorscheme.dart';
import 'package:meiyou/presentation/theme/colorscheme/matrix_colorscheme.dart';
import 'package:meiyou/presentation/theme/colorscheme/midnight_dusk_colorscheme.dart';
import 'package:meiyou/presentation/theme/colorscheme/mocha_colorscheme.dart';
import 'package:meiyou/presentation/theme/colorscheme/nord_colorscheme.dart';
import 'package:meiyou/presentation/theme/colorscheme/sapphire_colorscheme.dart';
import 'package:meiyou/presentation/theme/colorscheme/strawberry_colorscheme.dart';
import 'package:meiyou/presentation/theme/colorscheme/tako_colorscheme.dart';
import 'package:meiyou/presentation/theme/colorscheme/teal_turqoise_colorscheme.dart';
import 'package:meiyou/presentation/theme/colorscheme/tidal_wave_colorscheme.dart';
import 'package:meiyou/presentation/theme/colorscheme/yin_yang_colorscheme.dart';
import 'package:meiyou/presentation/theme/colorscheme/yotsuba_colorscheme.dart';
import 'package:nice_dart/nice_dart.dart';

ColorScheme getColorSchemeFromMode(
  ThemeMode themeMode,
  AppTheme appTheme,
  bool isAmoled,
) {
  final colorScheme =
      _colorSchemes.getOrDefault(appTheme, DefaultColorScheme());

  return colorScheme.getColorScheme(
    themeMode == ThemeMode.dark,
    isAmoled,
  );
}

ColorScheme getThemeColorScheme(
  Brightness brightness,
  AppTheme appTheme,
  bool isAmoled,
) {
  final colorScheme =
      _colorSchemes.getOrDefault(appTheme, DefaultColorScheme());

  return colorScheme.getColorScheme(
    brightness == Brightness.dark,
    isAmoled,
  );
}

final Map<AppTheme, BaseColorScheme> _colorSchemes = {
  AppTheme.deault: DefaultColorScheme(),
  AppTheme.cloudflare: CloudflareColorScheme(),
  AppTheme.cottoncandy: CottonCandyColorScheme(),
  AppTheme.doom: DoomColorScheme(),
  AppTheme.greenApple: GreenAppleColorScheme(),
  AppTheme.lavender: LavenderColorScheme(),
  AppTheme.matrix: MatrixColorScheme(),
  AppTheme.midnightDusk: MidnightDuskColorScheme(),
  AppTheme.mocha: MochaColorScheme(),
  AppTheme.sapphire: SapphireColorScheme(),
  AppTheme.nord: NordColorScheme(),
  AppTheme.strawberryDaiquiri: StrawberryColorScheme(),
  AppTheme.tako: TakoColorScheme(),
  AppTheme.tealTurquoise: TealTurqoiseColorScheme(),
  AppTheme.tidalWave: TidalWaveColorScheme(),
  AppTheme.yinYang: YinYangColorScheme(),
  AppTheme.yotsuba: YotsubaColorScheme(),
};
