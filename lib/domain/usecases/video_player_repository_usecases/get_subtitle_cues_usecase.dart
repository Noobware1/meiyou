import 'package:meiyou/core/resources/response_state.dart';
import 'package:meiyou/core/resources/subtitle_decoders/models/cue.dart';
import 'package:meiyou/core/usecases/usecase.dart';
import 'package:meiyou/domain/repositories/video_player_repository.dart';
import 'package:meiyou_extensions_lib/models.dart';

class GetSubtitleCuesUseCase implements UseCase<void, Subtitle> {
  final VideoPlayerRepository _videoPlayerRepository;

  GetSubtitleCuesUseCase(this._videoPlayerRepository);

  @override
  Future<ResponseState<List<SubtitleCue>>> call(Subtitle params) {
    return _videoPlayerRepository.getSubtitleCues(
      params,
    );
  }
}
