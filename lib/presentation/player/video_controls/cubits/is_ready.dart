import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:media_kit_video/media_kit_video.dart';

class IsPlayerReady extends Cubit<bool> {
  IsPlayerReady(VideoController controller) : super(false) {
    controller.waitUntilFirstFrameRendered.then((value) => emit(true));
  }
}
