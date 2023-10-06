import 'package:meiyou/core/usecases/usecase.dart';
import 'package:meiyou/core/usecases_container/usecase_container.dart';
import 'package:meiyou/domain/repositories/video_player_repository.dart';
import 'package:meiyou/domain/usecases/video_player_usecase/get_default_subtitle_usecase.dart';
import 'package:meiyou/domain/usecases/video_player_usecase/get_default_video_usecase.dart';
import 'package:meiyou/domain/usecases/video_player_usecase/get_subtitle_cue.dart';
import 'package:meiyou/domain/usecases/video_player_usecase/seek_episode.dart';

class VideoPlayerUseCaseContainer
    extends UseCaseContainer<VideoPlayerUseCaseContainer> {
  final VideoPlayerRepository _repository;

  VideoPlayerUseCaseContainer(this._repository);

  @override
  Set<UseCase> get usecases => {
        GetDefaultVideoUseCase(_repository),
        GetDefaultSubtitleUseCase(_repository),
        SeekEpisodeUseCase(_repository),
        GetSubtitleCueUseCase(_repository),
      };
}
