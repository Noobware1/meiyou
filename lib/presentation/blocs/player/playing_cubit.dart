import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

class PlayingCubit extends Cubit<bool> {
  late final StreamSubscription _subscription;

  PlayingCubit(Stream<bool> stream) : super(false) {
    _subscription = stream.listen((event) {
      emit(event);
    });
  }

  void stopPlaying() {
    _subscription.pause();
  
    emit(false);
  }

  void resumePlaying() {
    emit(true);
    _subscription.resume();
  }

  @override
  Future<void> close() {
    _subscription.cancel();
    return super.close();
  }
}
