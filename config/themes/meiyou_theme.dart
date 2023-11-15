import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:meiyou/config/themes/utils.dart';
import 'package:meiyou/core/utils/extenstions/context.dart';
import 'package:meiyou/presentation/widgets/theme/bloc/theme_bloc.dart';

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
      appBarTheme: AppBarTheme(
        color: lightTheme.colorScheme.background,
        elevation: 0.0,
      ),
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
      appBarTheme:
          AppBarTheme(elevation: 0.0, color: darkTheme.colorScheme.background),
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
          // primarySwatch: MaterialColor(primary, swatch),
          // primaryColor: Color(0xff9b6969).withOpacity(0.4),
          colorScheme: const ColorScheme.light(
            secondary: Color.fromARGB(255, 250, 229, 229),
            onPrimary: Colors.black,
            primary: Color.fromARGB(255, 204, 150, 150),
            tertiary: Color.fromARGB(255, 239, 238, 238),
            // tertiary: ,
          ),
        ),
        darkTheme: ThemeData.dark().copyWith(
          colorScheme: ThemeData.dark().colorScheme.copyWith(
                background: const Color(0xff1c1314),
                secondary: const Color(0xff573e3e),
                primary: const Color(0xff9b6969),
                tertiary: const Color.fromARGB(255, 36, 24, 26),
              ),
        ),
        name: 'Strawberry'),
    MeiyouTheme(
        lightTheme: ThemeData(
          // primarySwatch: MaterialColor(primary, swatch),
          // primaryColor: Color(0xff9b6969).withOpacity(0.4),
          colorScheme: const ColorScheme.light(
            background: Color(0xfffefbfe),
            secondary: Color(0xfff9e4e0),
            onPrimary: Colors.black,
            primary: Colors.pinkAccent,
            tertiary: Color.fromARGB(255, 239, 238, 238),
            // tertiary: ,
          ),
        ),
        darkTheme: ThemeData.dark().copyWith(
          colorScheme: ThemeData.dark().colorScheme.copyWith(
                background: const Color(0xff17151c),
                secondary: const Color(0xff18131c),
                primary: Colors.pinkAccent,
                tertiary: const Color.fromARGB(255, 19, 17, 24),
              ),
        ),
        name: 'Mignight Dusk'),
    MeiyouTheme(
        lightTheme: ThemeData(
          // primarySwatch: MaterialColor(primary, swatch),
          // primaryColor: Color(0xff9b6969).withOpacity(0.4),
          colorScheme: const ColorScheme.light(
            background: Color(0xfffafef6),
            secondary: Color(0xffe5f1e7),
            onPrimary: Colors.black,
            primary: Colors.green,
            tertiary: Color.fromARGB(255, 239, 238, 238),
            // tertiary: ,
          ),
        ),
        darkTheme: ThemeData.dark().copyWith(
          colorScheme: ThemeData.dark().colorScheme.copyWith(
                background: const Color(0xff1a1c19),
                secondary: const Color(0xff232c22),
                primary: Colors.green,
                tertiary: const Color.fromARGB(255, 31, 34, 30),
              ),
        ),
        name: 'Green Apple'),
  ];

  @override
  List<Object?> get props => [name, lightTheme, darkTheme];
}
