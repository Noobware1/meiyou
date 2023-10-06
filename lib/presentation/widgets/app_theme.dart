import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meiyou/config/themes/utils.dart';
import 'package:meiyou/core/constants/default_sized_box.dart';
import 'package:meiyou/presentation/widgets/theme/bloc/theme_bloc.dart';

class AppTheme extends StatelessWidget {
  final ThemeBloc? bloc;
  final Widget? child;

  const AppTheme({super.key, this.child, this.bloc});

  factory AppTheme.builder({
    ThemeBloc? bloc,
    required Widget Function(BuildContext context, ThemeState state) builder,
  }) {
    return _AppThemeBuilder(bloc: bloc, builder: builder);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeBloc, ThemeState>(
        bloc: bloc,
        builder: (context, state) {
          return Theme(
            data: getTheme(context, state),
            child: child ?? defaultSizedBox,
          );
        });
  }
}

class _AppThemeBuilder extends AppTheme {
  final Widget Function(BuildContext context, ThemeState state) builder;

  const _AppThemeBuilder(
      {super.key, required super.bloc, required this.builder, super.child});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeBloc, ThemeState>(
      bloc: bloc,
      builder: (context, state) {
        return Theme(
          data: getTheme(context, state),
          child: builder.call(context, state),
        );
      },
    );
  }
}
