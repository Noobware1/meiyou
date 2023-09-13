import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:media_kit/media_kit.dart';
import 'package:meiyou/presentation/player/video_controls/cubits/player_cubit.dart';

class PlayingCubit extends Cubit<bool> {
  // final Stream<bool> _stream;
  late final StreamSubscription _subscription;

  PlayingCubit(Stream<bool> playing) : super(false) {
    _subscription = playing.listen(
      (event) {
        emit(event);
      },
    );
  }

  @override
  Future<void> close() {
    _subscription.cancel();
    return super.close();
  }
}
