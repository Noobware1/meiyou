import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meiyou/core/resources/expections.dart';
import 'package:meiyou/core/resources/response_state.dart';
import 'package:meiyou/core/resources/subtitle_decoders/models/cue.dart';
import 'package:meiyou/domain/entities/subtitle.dart';
import 'package:meiyou/domain/usecases/video_player_usecase/get_subtitle_cue.dart';
import 'package:meiyou/presentation/player/video_controls/cubits/buffering_cubit.dart';

import 'package:media_kit/media_kit.dart';

part 'subtitle_worker_event.dart';
part 'subtitle_worker_state.dart';

class SubtitleWorkerBloc
    extends Bloc<SubtitleWorkerEvent, SubtitleWorkerState> {
  final GetSubtitleCueUseCase _getSubtitleCueUseCase;

  SubtitleWorkerBloc(this._getSubtitleCueUseCase)
      : super(const SubtitleDecoding(SubtitleEntity.noSubtitle)) {
    on<ChangeSubtitle>(_changeSubtitle);
  }

  FutureOr<void> _changeSubtitle(
      ChangeSubtitle event, Emitter<SubtitleWorkerState> emit) async {
    if (event.subtitle == SubtitleEntity.noSubtitle) {
      emit(NoSubtitle(event.subtitle));
    } else {
      SubtitleDecoding(event.subtitle);
      final response = await _getSubtitleCueUseCase.call(
          GetSubtitleCueUseCaseParams(event.subtitle, headers: event.headers));

      if (response is ResponseFailed) {
        emit(SubtitleDecodingFailed(response.error!, event.subtitle));
      } else {
        emit(SubtitleDecoded(response.data!, event.subtitle));
      }
    }
  }
}
