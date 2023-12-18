import 'package:meiyou/core/usecases/usecase.dart';
import 'package:meiyou/domain/repositories/video_player_repository.dart';
import 'package:meiyou_extensions_lib/meiyou_extensions_lib.dart';

class GetDefaultSubtitleUseCase implements UseCase<Subtitle, List<Subtitle>> {
  final VideoPlayerRepository _videoPlayerRepository;

  GetDefaultSubtitleUseCase(this._videoPlayerRepository);

  @override
  Subtitle call(List<Subtitle> params) {
    return _videoPlayerRepository.getDefaultSubtitle(params);
  }
}
