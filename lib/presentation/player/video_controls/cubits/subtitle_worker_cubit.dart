import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meiyou/core/resources/subtitle_decoders/models/cue.dart';

class SubtitleWorkerCubit extends Cubit<List<SubtitleCue>?> {
  List<SubtitleCue>? cues;
  List<SubtitleCue>? _currentCues;

  final List<StreamSubscription> _subscriptions = [];

  SubtitleWorkerCubit(
      Stream<List<SubtitleCue>?> subtitleStream, Stream<Duration> playerStream)
      : super(null) {
    _subscriptions.addAll([
      subtitleStream.listen((data) {
        cues = data;
      }),
      playerStream.listen((pos) {
        
        if (cues != null) {
          _currentCues = [];
          for (final cue in cues!) {
            if (cue.start <= pos && cue.end >= pos) {
              _currentCues?.add(cue);
            }
          }
          emit(_currentCues);
        }
      }),
    ]);
  }

  @override
  Future<void> close() {
    for (final subcription in _subscriptions) {
      subcription.cancel();
    }

    cues = null;
    _currentCues = null;
    return super.close();
  }
}
