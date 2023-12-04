import 'dart:ui';

import 'package:flutter_bloc/flutter_bloc.dart';

class PopMenuState {
  final int body;
  final Offset offset;

  PopMenuState({required this.body, required this.offset});
}

class PopMenuCubit extends Cubit<PopMenuState> {
  PopMenuCubit(PopMenuState state) : super(state);
}
