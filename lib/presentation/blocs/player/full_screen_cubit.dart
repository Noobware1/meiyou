import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:window_manager/window_manager.dart';

class FullScreenCubit extends Cubit<bool> {
  FullScreenCubit() : super(false);

  void toggleFullScreen() async {
    final isFullScreen = await windowManager.isFullScreen();
    if (!isFullScreen) {
      emit(true);
      windowManager.setFullScreen(true);
    } else {
      emit(false);
      windowManager.setFullScreen(false);
    }
  }

  void exitFullScreen() {
    emit(false);
    windowManager.setFullScreen(false);
  }
}
