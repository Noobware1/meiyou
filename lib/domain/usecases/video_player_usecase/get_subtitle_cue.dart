import 'package:meiyou/core/resources/response_state.dart';
import 'package:meiyou/core/resources/subtitle_decoders/models/cue.dart';
import 'package:meiyou/core/usecases/usecase.dart';
import 'package:meiyou/domain/entities/subtitle.dart';
import 'package:meiyou/domain/repositories/video_player_repository.dart';

class GetSubtitleCueUseCaseParams {
  final SubtitleEntity subtitle;
  final Map<String, String>? headers;

  GetSubtitleCueUseCaseParams(this.subtitle, {this.headers});
}

class GetSubtitleCueUseCase extends UseCase<
    Future<ResponseState<List<SubtitleCue>>>, GetSubtitleCueUseCaseParams> {
  final VideoPlayerRepository _repository;

  GetSubtitleCueUseCase(this._repository);

  @override
  Future<ResponseState<List<SubtitleCue>>> call(
      GetSubtitleCueUseCaseParams params) {
    return _repository.getSubtitleCues(params.subtitle, params.headers);
  }
}
