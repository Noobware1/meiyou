import 'package:meiyou/domain/repositories/video_player_repository.dart';
import 'package:meiyou/domain/usecases/video_player_repository_usecases/change_episode_usecase.dart';
import 'package:meiyou/domain/usecases/video_player_repository_usecases/change_source_usecase.dart';
import 'package:meiyou/domain/usecases/video_player_repository_usecases/convert_extracted_videodata_list_usecase.dart';
import 'package:meiyou/domain/usecases/video_player_repository_usecases/get_default_subtitle_usecase.dart';
import 'package:meiyou/domain/usecases/video_player_repository_usecases/get_subtitle_cues_usecase.dart';
import 'package:meiyou/domain/usecases/video_player_repository_usecases/get_video_title_usecase.dart';
import 'package:meiyou/domain/usecases/video_player_repository_usecases/load_player_usecase.dart';

class VideoPlayerRepositoryUseCases {
  final LoadPlayerUseCase loadPlayerUseCase;
  final GetDefaultSubtitleUseCase getDefaultSubtitleUseCase;
  final GetSubtitleCuesUseCase getSubtitleCuesUseCase;
  final GetVideoTitleUseCase getVideoTitleUseCase;
  final ChangeSourceUseCase changeSourceUseCase;
  final ChangeEpisodeUseCase changeEpisodeUseCase;
  final ConvertExtractedVideoDataListUseCase
      convertExtractedVideoDataListUseCase;

  VideoPlayerRepositoryUseCases(VideoPlayerRepository repository)
      : loadPlayerUseCase = LoadPlayerUseCase(repository),
        getDefaultSubtitleUseCase = GetDefaultSubtitleUseCase(repository),
        getSubtitleCuesUseCase = GetSubtitleCuesUseCase(repository),
        getVideoTitleUseCase = GetVideoTitleUseCase(repository),
        changeSourceUseCase = ChangeSourceUseCase(repository),
        changeEpisodeUseCase = ChangeEpisodeUseCase(repository),
        convertExtractedVideoDataListUseCase =
            ConvertExtractedVideoDataListUseCase(repository);


}
