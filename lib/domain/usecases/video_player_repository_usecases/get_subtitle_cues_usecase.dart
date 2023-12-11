import 'package:meiyou/core/resources/response_state.dart';
import 'package:meiyou/core/resources/subtitle_decoders/models/cue.dart';
import 'package:meiyou/core/usecases/usecase.dart';
import 'package:meiyou/domain/repositories/video_player_repository.dart';
import 'package:meiyou_extenstions/models.dart';

class GetSubtitleCuesUseCaseParams {
  final Subtitle subtitle;
  final Map<String, String>? headers;

  GetSubtitleCuesUseCaseParams({
    required this.subtitle,
    required this.headers,
  });
}

class GetSubtitleCuesUseCase
    implements UseCase<void, GetSubtitleCuesUseCaseParams> {
  final VideoPlayerRepository _videoPlayerRepository;

  GetSubtitleCuesUseCase(this._videoPlayerRepository);

  @override
  Future<ResponseState<List<SubtitleCue>>> call(
      GetSubtitleCuesUseCaseParams params) {
    return _videoPlayerRepository.getSubtitleCues(
      params.subtitle,
      headers: params.headers,
    );
  }
}
