import 'package:flutter/material.dart';
import 'package:meiyou/features/player/presentation/widgets/player_theme/player_theme_data.dart';

class PlayerTheme extends InheritedTheme {
  final PlayerThemeData data;
  const PlayerTheme({super.key, required this.data, required super.child});

  @override
  bool updateShouldNotify(covariant InheritedWidget oldWidget) {
    return false;
  }

  @override
  Widget wrap(BuildContext context, Widget child) {
    return PlayerTheme(data: data, child: child);
  }

  static PlayerThemeData of(BuildContext context) {
    final playerTheme =
        context.dependOnInheritedWidgetOfExactType<PlayerTheme>();
    return playerTheme?.data ?? PlayerThemeData(context);
  }

  
}
