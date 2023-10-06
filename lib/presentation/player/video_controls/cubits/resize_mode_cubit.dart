import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meiyou/presentation/player/video_controls/cubits/is_ready.dart';

enum ResizeMode {
  normal,
  zoom,
  stretch,
}

class ResizeModeCubit extends Cubit<ResizeMode> {
  final IsPlayerReady isPlayerReady;

  ResizeModeCubit(this.isPlayerReady) : super(ResizeMode.normal);
  void resize() {
    if (isPlayerReady.state == true) {
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
}
