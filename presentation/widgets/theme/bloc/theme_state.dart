part of 'theme_bloc.dart';

sealed class ThemeState extends Equatable {
  final ThemeMode themeMode;
  final MeiyouTheme theme;
  final bool isAmoled;
  const ThemeState(
      {required this.theme, required this.themeMode, required this.isAmoled});

  @override
  List<Object> get props => [theme, themeMode, isAmoled];
}

class MeiyouThemeState extends ThemeState {
  const MeiyouThemeState(
      {required super.theme,
      required super.themeMode,
      required super.isAmoled});

  Map<String, dynamic> toJson() {
    return {
      'theme': MeiyouTheme.values
          .indexOf(MeiyouTheme.values.firstWhere((e) => e.name == theme.name)),
      'themeMode': themeMode.index,
      'isAmoled': isAmoled,
    };
  }

  factory MeiyouThemeState.fromJson(Map<String, dynamic> json) {
    return MeiyouThemeState(
      theme: json['isAmoled'] == true
          ? MeiyouTheme.values[json['theme'] as int].convertToAmoled()
          : MeiyouTheme.values[json['theme'] as int],
      themeMode: ThemeMode.values[json['themeMode'] as int],
      isAmoled: json['isAmoled'],
    );
  }
}
