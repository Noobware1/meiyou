import 'package:media_kit/media_kit.dart';
import 'package:meiyou/core/usecases/usecase.dart';
import 'package:meiyou/domain/repositories/video_player_repository.dart';
import 'package:meiyou/data/models/media/video/video.dart' as vid;

class ChangeSourceUseCaseParams {
  final vid.Video video;
  final int selectedSource;
  final Player player;
  final Duration? startPostion;

  ChangeSourceUseCaseParams({
    required this.video,
    required this.selectedSource,
    required this.player,
    this.startPostion,
  });
}

class ChangeSourceUseCase
    implements UseCase<Future<void>, ChangeSourceUseCaseParams> {
  final VideoPlayerRepository _videoPlayerRepository;

  ChangeSourceUseCase(this._videoPlayerRepository);

  @override
  Future<void> call(ChangeSourceUseCaseParams params) {
    return _videoPlayerRepository.changeSource(
      video: params.video,
      selectedSource: params.selectedSource,
      player: params.player,
      startPostion: params.startPostion,
    );
  }
}
