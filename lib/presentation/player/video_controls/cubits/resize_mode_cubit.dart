import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

enum ResizeMode {
  normal,
  zoom,
  stretch,
}

class ResizeModeCubit extends Cubit<ResizeMode> {
  ResizeModeCubit() : super(ResizeMode.normal);

  void resize() {
    final ResizeMode mode;
    switch (state) {
      case ResizeMode.normal:
        mode = ResizeMode.zoom;
        break;
      case ResizeMode.zoom:
        mode = ResizeMode.stretch;
        break;
      case ResizeMode.stretch:
        mode = ResizeMode.normal;
        break;
      default:
        mode = ResizeMode.normal;
        break;
    }
    emit(mode);
  }
}
