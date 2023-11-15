// import 'dart:convert';
// import 'dart:io';

// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:meiyou/config/themes/app_themes/app_theme.dart';
// import 'package:meiyou/config/themes/primary_colors/primary_color.dart';


// // class ThemeState {
// //   final AppTheme appTheme;
// //   final PrimaryColor primaryColor;
// //   late final ThemeData themeData;

// //   ThemeState({required this.appTheme, required this.primaryColor}) {
// //     themeData = getAppThemeData(appTheme, primaryColor.color);
// //   }
// //   ThemeState copyWith({
// //     AppTheme? appTheme,
// //     PrimaryColor? primaryColor,
// //   }) {
// //     return ThemeState(
// //         appTheme: appTheme ?? this.appTheme,
// //         primaryColor: primaryColor ?? this.primaryColor);
// //   }

// //   Map<String, dynamic> toJson() {
// //     return {
// //       'appTheme': appTheme.toString(),
// //       'primaryColor': primaryColor.name,
// //     };
// //   }

// //   factory ThemeState.fromJson(dynamic json) {
// //     return ThemeState(
// //         appTheme: AppTheme.values
// //             .firstWhere((e) => e.toString() == json['appTheme'].toString()),
// //         primaryColor: PrimaryColor.values
// //             .firstWhere((e) => e.name == json['primaryColor'].toString()));
// //   }
// // }

// class ThemeRepositoryImpl {
//   final String path;

//   ThemeState _theme;

//   ThemeState get state => _theme;

//   ThemeRepositoryImpl(this.path, this._theme);

//   static Future<ThemeRepositoryImpl> getInstance(String path) async {
//     final ThemeState theme;
//     final file = File(path);
//     if (file.existsSync()) {
//       theme = ThemeState.fromJson(json.decode(await file.readAsString()));
//     } else {
//       theme = ThemeState(
//           appTheme: AppTheme.amoled, primaryColor: PrimaryColor.values.first);
//     }
//     return ThemeRepositoryImpl(path, theme);
//   }

//   Future<void> toggleTheme(AppTheme appTheme) async {
//     _theme = _theme.copyWith(appTheme: appTheme);
//     await File(path).writeAsString(json.encode(_theme.toJson()));
//   }

//   Future<void> toggleColor(PrimaryColor color) async {
//     _theme = _theme.copyWith(primaryColor: color);
//     await File(path).writeAsString(json.encode(_theme.toJson()));
//   }

//   static ThemeRepositoryImpl of(BuildContext context) =>
//       RepositoryProvider.of<ThemeRepositoryImpl>(context);
// }
