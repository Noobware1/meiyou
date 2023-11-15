part of 'theme_bloc.dart';

sealed class ThemeEvent extends Equatable {
  // final void Function(MeiyouThemeState state) setOverlayCallback;
  const ThemeEvent(
      // this.setOverlayCallback
      );

  @override
  List<Object> get props => [];
}

class ToggleTheme extends ThemeEvent {
  final MeiyouTheme theme;

  const ToggleTheme(
    this.theme,
    // super.setOverlayCallback
  );
}

class ToggleThemeMode extends ThemeEvent {
  final ThemeMode themeMode;

  const ToggleThemeMode(
    this.themeMode,
    // super.setOverlayCallback
  );
}

class ToggleAmoledTheme extends ThemeEvent {
  final bool toggleAmoled;
  const ToggleAmoledTheme(
    this.toggleAmoled,
    // super.setOverlayCallback
  );
}
