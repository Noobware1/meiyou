import 'dart:async';
import 'package:media_kit/media_kit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BufferingCubit extends Cubit<bool> {
  late final StreamSubscription _subscription;

  bool? playingState;
  BufferingCubit(Stream<bool> stream) : super(true) {
    _subscription = stream.listen((event) {
      emit(event);
    });
  }

  void setForceBuffering(Player player) {
    playingState = player.state.playing;
    _subscription.pause();

    emit(true);

    player.pause();
  }

  void releaseForceBuffering(Player player) {
    emit(false);

    _subscription.resume();
    if (playingState == true) {
      player.play();
    }

    playingState = null;
  }

  @override
  Future<void> close() {
    _subscription.cancel();
    playingState = null;
    return super.close();
  }
}