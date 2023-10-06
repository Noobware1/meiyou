part of 'theme_bloc.dart';

sealed class ThemeEvent extends Equatable {
  const ThemeEvent();

  @override
  List<Object> get props => [];
}

class ToggleTheme extends ThemeEvent {
  final MeiyouTheme theme;

  const ToggleTheme(this.theme);
}

class ToggleThemeMode extends ThemeEvent {
  final ThemeMode themeMode;

  const ToggleThemeMode(this.themeMode);
}

class ToggleAmoledTheme extends ThemeEvent {
  final bool toggleAmoled;
  const ToggleAmoledTheme(this.toggleAmoled);
}
