import 'dart:async';

import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:meiyou/config/themes/meiyou_theme.dart';
import 'package:meiyou/core/utils/extenstions/context.dart';

part 'theme_event.dart';
part 'theme_state.dart';

class ThemeBloc extends Bloc<ThemeEvent, ThemeState> {
  ThemeBloc(MeiyouThemeState? savedState)
      : super(savedState ??
            MeiyouThemeState(
                theme: MeiyouTheme.values.first,
                themeMode: ThemeMode.system,
                isAmoled: false)) {
    on<ToggleAmoledTheme>((event, emit) {
      // if (event.toggleAmoled) {
      emit(MeiyouThemeState(
        themeMode: state.themeMode,
        theme: event.toggleAmoled
            ? state.theme.convertToAmoled()
            : MeiyouTheme.values.firstWhere((e) => e.name == state.theme.name),
        isAmoled: event.toggleAmoled,
      ));
      // } else {
      //   emit(MeiyouThemeState(
      //       theme: ,
      //       themeMode: state.themeMode,
      //       isAmoled: false));
      // }
    });
    on<ToggleTheme>(_onToggleTheme);
    on<ToggleThemeMode>(_onToggleThemeMode);
  }

  FutureOr<void> _onToggleTheme(ToggleTheme event, Emitter<ThemeState> emit) {
    emit(MeiyouThemeState(
        theme: state.isAmoled ? event.theme.convertToAmoled() : event.theme,
        themeMode: state.themeMode,
        isAmoled: state.isAmoled));
  }

  FutureOr<void> _onToggleThemeMode(
      ToggleThemeMode event, Emitter<ThemeState> emit) {
    emit(MeiyouThemeState(
        theme: state.theme,
        themeMode: event.themeMode,
        isAmoled: state.isAmoled));
  }

  @override
  Future<void> close() {
    // _subscription.cancel();
    return super.close();
  }
}
