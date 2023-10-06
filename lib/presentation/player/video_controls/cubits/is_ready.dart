import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:media_kit_video/media_kit_video.dart';

class IsPlayerReady extends Cubit<bool> {
  IsPlayerReady() : super(false);

  Future<void> fromController(VideoController controller) async {
    emit(false);
    await controller.waitUntilFirstFrameRendered;
    emit(true);
  }
}
