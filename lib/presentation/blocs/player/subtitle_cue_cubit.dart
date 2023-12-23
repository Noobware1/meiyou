import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meiyou/core/resources/expections.dart';
import 'package:meiyou/core/resources/response_state.dart';
import 'package:meiyou/core/resources/subtitle_decoders/models/cue.dart';
import 'package:meiyou/domain/usecases/video_player_repository_usecases/get_subtitle_cues_usecase.dart';
import 'package:meiyou_extensions_lib/meiyou_extensions_lib.dart';

class CurrentSubtitleCuesCubit extends Cubit<List<SubtitleCue>?> {
  final List<StreamSubscription> _subscriptions = [];
  List<SubtitleCue>? cues;
  Duration? duration;
  List<SubtitleCue>? _currentCues;

  CurrentSubtitleCuesCubit(
      SubtitleCuesCubit subtitleCuesCubit, Stream<Duration> durationStream)
      : super(null) {
    _subscriptions.addAll([
      subtitleCuesCubit.stream.listen((data) {
        cues = null;
        if (data is SubtitleCuesDecoded) {
          cues = data.subtitleCues;
        }
        emitCues();
      }),
      durationStream.listen((pos) {
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
    duration = null;
    return super.close();
  }
}

class SubtitleCuesCubit extends Cubit<SubtitleCuesState> {
  final GetSubtitleCuesUseCase _useCase;
  SubtitleCuesCubit(this._useCase) : super(const NoSubtitle());

  void loadSubtitles(Subtitle subtitle) async {
    if (subtitle == Subtitle.noSubtitle) return emit(const NoSubtitle());
    emit(const SubtitleCuesDecoding());
    final res = await _useCase.call(subtitle);

    if (res is ResponseSuccess) return emit(SubtitleCuesDecoded(res.data!));
    return emit(SubtitleCuesDecodingFailed(res.error!));
  }

  void emitNoSubtitle() => emit(const NoSubtitle());
}

sealed class SubtitleCuesState {
  final List<SubtitleCue>? subtitleCues;
  final MeiyouException? error;

  const SubtitleCuesState({this.subtitleCues, this.error});
}

final class NoSubtitle extends SubtitleCuesState {
  const NoSubtitle();
}

final class SubtitleCuesDecoding extends SubtitleCuesState {
  const SubtitleCuesDecoding();
}

final class SubtitleCuesDecoded extends SubtitleCuesState {
  const SubtitleCuesDecoded(List<SubtitleCue> subtitleCues)
      : super(subtitleCues: subtitleCues);
}

final class SubtitleCuesDecodingFailed extends SubtitleCuesState {
  const SubtitleCuesDecodingFailed(MeiyouException error) : super(error: error);
}
