import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meiyou/core/resources/expections.dart';
import 'package:meiyou/core/resources/response_state.dart';
import 'package:meiyou/core/resources/subtitle_decoders/models/cue.dart';
import 'package:meiyou/domain/usecases/video_player_repository_usecases/get_subtitle_cues_usecase.dart';
import 'package:meiyou_extenstions/meiyou_extenstions.dart';

class SubtitleCuesCubit extends Cubit<SubtitleCuesState> {
  final GetSubtitleCuesUseCase useCase;
  SubtitleCuesCubit(this.useCase) : super(const NoSubtitle());

  void loadSubtitles(GetSubtitleCuesUseCaseParams params) async {
    if (params.subtitle == Subtitle.noSubtitle) return emit(const NoSubtitle());
    emit(const SubtitleCuesDecoding());
    final res = await useCase.call(params);

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
