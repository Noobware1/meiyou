import 'package:meiyou/core/usecases/usecase.dart';
import 'package:meiyou/domain/repositories/video_player_repository.dart';
import 'package:meiyou_extenstions/meiyou_extenstions.dart';

class GetDefaultSubtitleUseCase implements UseCase<Subtitle, List<Subtitle>> {
  final VideoPlayerRepository _videoPlayerRepository;

  GetDefaultSubtitleUseCase(this._videoPlayerRepository);

  @override
  Subtitle call(List<Subtitle> params) {
    return _videoPlayerRepository.getDefaultSubtitle(params);
  }
}
