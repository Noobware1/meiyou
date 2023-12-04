import 'package:meiyou/domain/repositories/video_player_repository.dart';
import 'package:meiyou/domain/usecases/video_player_repository_usecases/change_episode_usecase.dart';
import 'package:meiyou/domain/usecases/video_player_repository_usecases/change_source.dart';
import 'package:meiyou/domain/usecases/video_player_repository_usecases/get_video_title_usecase.dart';
import 'package:meiyou/domain/usecases/video_player_repository_usecases/load_player_usecase.dart';

class VideoPlayerRepositoryUseCases {
  final LoadPlayerUseCase loadPlayerUseCase;
  final GetVideoTitleUseCase getVideoTitleUseCase;
  final ChangeSourceUseCase changeSourceUseCase;
  final ChangeEpisodeUseCase changeEpisodeUseCase;

  VideoPlayerRepositoryUseCases(VideoPlayerRepository repository)
      : loadPlayerUseCase = LoadPlayerUseCase(repository),
        getVideoTitleUseCase = GetVideoTitleUseCase(repository),
        changeSourceUseCase = ChangeSourceUseCase(repository),
        changeEpisodeUseCase = ChangeEpisodeUseCase(repository);
}
