import 'package:meiyou/core/usecases_container/usecase_container.dart';
import 'package:meiyou/core/usecases/usecase.dart';
import 'package:meiyou/domain/repositories/watch_provider_repository.dart';
import 'package:meiyou/domain/usecases/provider_use_cases/find_best_search_response.dart';
import 'package:meiyou/domain/usecases/provider_use_cases/get_episode_chunks_usecase.dart';
import 'package:meiyou/domain/usecases/provider_use_cases/load_episode_usecase.dart';
import 'package:meiyou/domain/usecases/provider_use_cases/load_movie_usecase.dart';
import 'package:meiyou/domain/usecases/provider_use_cases/load_saved_search_response.dart';
import 'package:meiyou/domain/usecases/provider_use_cases/load_seasons_episodes.dart';
import 'package:meiyou/domain/usecases/provider_use_cases/load_seasons_use_case.dart';
import 'package:meiyou/domain/usecases/provider_use_cases/load_server_and_video_usecase.dart';
import 'package:meiyou/domain/usecases/provider_use_cases/load_video_extractor_usecase.dart';
import 'package:meiyou/domain/usecases/provider_use_cases/load_video_server_usecase.dart';
import 'package:meiyou/domain/usecases/provider_use_cases/save_search_response.dart';
import 'package:meiyou/domain/usecases/provider_use_cases/search_use_case.dart';

class WatchProviderRepositoryContainer
    extends UseCaseContainer<WatchProviderRepositoryContainer> {
  final WatchProviderRepository _repository;

  WatchProviderRepositoryContainer(this._repository);

  // String get findBestSearchResponseUseCase => 'findBestSearhResponseUseCase';
  // String get loadEpisodesUseCase => 'loadEpisodesUseCase';
  // String get loadMovieUseCase => 'loadMovieUseCase';
  // String get loadSeasonUseCase => 'loadSeasonUseCase';
  // String get getEpisodeChunksUseCase => 'getEpisodeChunksUseCase';
  // String get loadSearchUseCase => 'loadSearchUseCase';
  // String get loadVideoServersUseCase => 'loadVideoServersUseCase';
  // String get loadVideoExtractorUseCase => 'loadVideoExtractorUseCase';

  @override
  Set<UseCase> get usecases => {
        // loadSearchUseCase:
        LoadSearchUseCase(_repository),
        // findBestSearchResponseUseCase:
        FindBestSearchResponseUseCase(_repository),
        // loadEpisodesUseCase:
        LoadEpisodeUseCase(_repository),
        // loadMovieUseCase:
        LoadMovieUseCase(_repository),
        // loadSeasonUseCase:
        LoadSeasonsUseCase(_repository),
        // loadVideoExtractorUseCase:
        LoadVideoExtractorUseCase(_repository),
        // loadVideoServersUseCase:
        LoadVideoServersUseCase(_repository),
        // getEpisodeChunksUseCase:
        GetEpisodeChunksUseCase(_repository),

        LoadSeasonsEpisodesUseCase(_repository),

        LoadSavedSearchResponseUseCase(_repository),

        SaveSearchResponseUseCase(_repository),

        LoadServerAndVideoUseCase(_repository),
      };
}
