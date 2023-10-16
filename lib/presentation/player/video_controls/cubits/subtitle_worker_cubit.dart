import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meiyou/core/resources/subtitle_decoders/models/cue.dart';
import 'package:meiyou/core/resources/subtitle_decoders/subtitle_parser.dart';

import 'dart:convert';

import 'package:meiyou/presentation/player/video_controls/subtitle_woker_bloc/subtitle_worker_bloc.dart';

class SubtitleWorkerCubit extends Cubit<List<SubtitleCue>?> {
  List<SubtitleCue>? cues;
  List<SubtitleCue>? _currentCues;
  Duration? duration;

  final List<StreamSubscription> _subscriptions = [];

  SubtitleWorkerCubit(
      Stream<SubtitleWorkerState> subtitleStream, Stream<Duration> playerStream)
      : super(null) {
    _subscriptions.addAll([
      subtitleStream.listen((data) {
        _currentCues = null;

        if (data is SubtitleDecoded) {
          cues = data.subtitleCues;
        } else {
          cues = null;
        }

        emitCues();
      }),
      playerStream.listen((pos) {
        duration = pos;
        emitCues();
      }),
    ]);
  }

  void emitCues() {
    if (cues != null && duration != null) {
      _currentCues = [];
      for (final cue in cues!) {
        if (cue.start <= duration! && cue.end >= duration!) {
          _currentCues?.add(cue);
        }
      }

      emit(_currentCues);
    } else {
      emit(null);
    }
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
