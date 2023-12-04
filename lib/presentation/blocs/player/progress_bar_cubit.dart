import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:media_kit/media_kit.dart';

class ProgressBarCubit extends Cubit<ProgressBarState> {
  Duration total = Duration.zero;
  Duration buffered = Duration.zero;
  final List<StreamSubscription> _subscriptions = [];
  ProgressBarCubit(Player player)
      : super(ProgressBarState(
            total: Duration.zero,
            current: Duration.zero,
            buffered: Duration.zero)) {
    _subscriptions.addAll([
      player.stream.duration.listen((duration) {
        total = duration;
      }),
      player.stream.buffer.listen((duration) {
        buffered = duration;
      }),
      player.stream.position.listen((postion) {
        emit(ProgressBarState(
            total: total, current: postion, buffered: buffered));
      })

  
    ]);
  }

  @override
  Future<void> close() {
    for (var subscription in _subscriptions) {
      subscription.cancel();
    }
    return super.close();
  }
}

class ProgressBarState {
  final Duration total;
  final Duration buffered;
  final Duration current;

  ProgressBarState(
      {required this.buffered, required this.total, required this.current});
}
