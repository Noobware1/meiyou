import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:meiyou/config/themes/utils.dart';

class MeiyouTheme extends Equatable {
  final String name;

  late final ThemeData lightTheme;

  late final ThemeData darkTheme;

  ThemeData getFromThemeMode(BuildContext context, ThemeMode mode) =>
      getThemeFromThemeMode(context, mode, this);

  MeiyouTheme convertToAmoled() {
    return MeiyouTheme(
        lightTheme: lightTheme,
        darkTheme: darkTheme.copyWith(
            colorScheme: darkTheme.colorScheme.copyWith(
              onPrimary: Colors.black,
              secondary: Colors.black,
              tertiary: const Color(0xFF101011),
              onSecondary: Colors.black,
              onError: Colors.black,
              background: Colors.black,
              surface: Colors.black,
            ),
            scaffoldBackgroundColor: Colors.black),
        name: name);
  }

  MeiyouTheme({
    required ThemeData lightTheme,
    required ThemeData darkTheme,
    required this.name,
    bool isAmoled = false,
  }) {
    this.lightTheme = lightTheme.copyWith(
      appBarTheme: AppBarTheme(color: lightTheme.colorScheme.background),
      dropdownMenuTheme: DropdownMenuThemeData(
          textStyle: TextStyle(color: lightTheme.colorScheme.onBackground)),
      dialogTheme: DialogTheme(
          backgroundColor: lightTheme.colorScheme.background,
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(25)))),
      scaffoldBackgroundColor: lightTheme.colorScheme.background,
      bottomSheetTheme: BottomSheetThemeData(
          backgroundColor: lightTheme.colorScheme.secondary,
          elevation: 1.0,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(35)),
          modalBarrierColor: Colors.transparent,
          modalBackgroundColor: lightTheme.colorScheme.secondary),
    );

    this.darkTheme = darkTheme.copyWith(
      appBarTheme: AppBarTheme(color: darkTheme.colorScheme.background),
      dropdownMenuTheme: DropdownMenuThemeData(
          textStyle: TextStyle(color: darkTheme.colorScheme.onBackground)),
      dialogTheme: DialogTheme(
          backgroundColor: darkTheme.colorScheme.background,
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(25)))),
      scaffoldBackgroundColor: darkTheme.colorScheme.background,
      bottomSheetTheme: BottomSheetThemeData(
          backgroundColor: darkTheme.colorScheme.secondary,
          elevation: 1.0,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(35)),
          modalBarrierColor: Colors.transparent,
          modalBackgroundColor: darkTheme.colorScheme.secondary),
    );
  }

  MeiyouTheme copyWith({
    String? name,
    ThemeData? lightTheme,
    ThemeData? darkTheme,
  }) {
    return MeiyouTheme(
        darkTheme: darkTheme ?? this.darkTheme,
        lightTheme: lightTheme ?? this.lightTheme,
        name: name ?? this.name);
  }

  static final List<MeiyouTheme> values = [
    MeiyouTheme(
        lightTheme: ThemeData(
            colorScheme: const ColorScheme.light(
                secondary: Color(0xFFEEEFEF),
                onPrimary: Colors.black,
                tertiary: Color(0xFFEEEFEF))),
        darkTheme: ThemeData.dark().copyWith(
            colorScheme: ThemeData.dark().colorScheme.copyWith(
                background: const Color(0xff303030),
                secondary: const Color(0xff424242),
                tertiary: const Color(0xff424242))),
        name: 'Default'),
    MeiyouTheme(
        lightTheme: ThemeData(
            colorScheme: const ColorScheme.light(
                secondary: Color(0xFFEEEFEF),
                onPrimary: Colors.black,
                primary: Colors.pinkAccent,
                tertiary: Color(0xFFEEEFEF))),
        darkTheme: ThemeData.dark().copyWith(
            colorScheme: ThemeData.dark().colorScheme.copyWith(
                background: Color.fromARGB(255, 194, 147, 147),
                secondary: Color.fromARGB(255, 226, 166, 166),
                primary: Colors.pinkAccent,
                tertiary: const Color(0xff424242))),
        name: 'Midnight Dusk')
  ];

  @override
  List<Object?> get props => [name, lightTheme, darkTheme];
}

class MeiyouThemeFromPrimary extends MeiyouTheme {
  MeiyouThemeFromPrimary({required Color primaryColor, required String name})
      : super(
            name: name,
            darkTheme: ThemeData(
                colorScheme: ColorScheme.dark(
              onPrimary: const Color(0xff121212),
              secondary: const Color(0xff121212),
              primary: primaryColor,
              onSecondary: const Color(0xff121212),
              background: Colors.black,
              surface: Colors.black,
            )),
            lightTheme: ThemeData(
                colorScheme: ColorScheme.light(
                    secondary: const Color(0xFFEEEFEF),
                    onPrimary: Colors.black,
                    primary: primaryColor,
                    tertiary: const Color(0xFFEEEFEF))));
}
