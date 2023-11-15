import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';



class ProgressBarState {
  final Duration postion;
  final Duration totalDuration;
  final Duration buffered;

  const ProgressBarState(
      {required this.postion,
      required this.totalDuration,
      required this.buffered});
}

class ProgressBarCubit extends Cubit<ProgressBarState> {
  Duration _postion = Duration.zero;
  Duration _totalDuration = Duration.zero;
  Duration _buffered = Duration.zero;
// late final StreamSubscription<Duration> _postionStream;
//     late final StreamSubscription<Duration> _totalDurationStream;
//     late final StreamSubscription<List<Duration>> _bufferedStream;
  final List<StreamSubscription> _subscriptions = [];

  ProgressBarCubit(
    final Stream<Duration> postionStream,
    final Stream<Duration> totalDurationStream,
    final Stream<Duration> bufferedStream,
  ) : super(const ProgressBarState(
            postion: Duration.zero,
            totalDuration: Duration.zero,
            buffered: Duration.zero)) {
    _initStreams(postionStream, totalDurationStream, bufferedStream);
  }

  @override
  Future<void> close() {
    if (_subscriptions.isNotEmpty) {
      for (final subscription in _subscriptions) {
        subscription.cancel();
      }
    }
    return super.close();
  }

  updateStreams(
    Stream<Duration> postionStream,
    Stream<Duration> totalDurationStream,
    Stream<Duration> bufferedStream,
  ) {
    if (_subscriptions.isNotEmpty) {
      for (final subscription in _subscriptions) {
        subscription.cancel();
      }
      _subscriptions.clear();
    }

    _initStreams(postionStream, totalDurationStream, bufferedStream);
  }

  _initStreams(
    Stream<Duration> postionStream,
    Stream<Duration> totalDurationStream,
    Stream<Duration> bufferedStream,
  ) {
    _subscriptions.addAll([
      totalDurationStream.listen((event) => _totalDuration = event),
      bufferedStream.listen((event) => _buffered = event),
      postionStream.listen((event) {
        _postion = event;

        emit(ProgressBarState(
            postion: _postion,
            totalDuration: _totalDuration,
            buffered: _buffered));
      }),
    ]);
  }
}
