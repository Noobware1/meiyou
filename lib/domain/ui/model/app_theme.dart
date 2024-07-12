enum AppTheme {
  deault,
  cloudflare,
  cottoncandy,
  doom,
  greenApple,
  lavender,
  matrix,
  midnightDusk,
  mocha,
  sapphire,
  nord,
  strawberryDaiquiri,
  tako,
  tealTurquoise,
  tidalWave,
  yinYang,
  yotsuba;

  String toDisplayString() {
    switch (this) {
      case AppTheme.deault:
        return 'Default';
      case AppTheme.cloudflare:
        return 'Cloudflare';
      case AppTheme.cottoncandy:
        return 'Cotton Candy';
      case AppTheme.doom:
        return 'Doom';
      case AppTheme.greenApple:
        return 'Green Apple';
      case AppTheme.lavender:
        return 'Lavender';
      case AppTheme.matrix:
        return 'Matrix';
      case AppTheme.midnightDusk:
        return 'Midnight Dusk';
      case AppTheme.mocha:
        return 'Mocha';
      case AppTheme.sapphire:
        return 'Sapphire';
      case AppTheme.nord:
        return 'Nord';
      case AppTheme.strawberryDaiquiri:
        return 'Strawberry Daiquiri';
      case AppTheme.tako:
        return 'Tako';
      case AppTheme.tealTurquoise:
        return 'Teal Turquoise';
      case AppTheme.tidalWave:
        return 'Tidal Wave';
      case AppTheme.yinYang:
        return 'Yin Yang';
      case AppTheme.yotsuba:
        return 'Yotsuba';
    }
  }
}
