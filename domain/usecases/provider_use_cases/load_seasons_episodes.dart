import 'package:meiyou/core/resources/expections.dart';
import 'package:meiyou/core/resources/providers/base_provider.dart';
import 'package:meiyou/core/resources/response_state.dart';
import 'package:meiyou/core/usecases/usecase.dart';
import 'package:meiyou/domain/entities/episode.dart';
import 'package:meiyou/domain/entities/search_response.dart';
import 'package:meiyou/domain/repositories/cache_repository.dart';
import 'package:meiyou/domain/repositories/watch_provider_repository.dart';
import 'package:meiyou/domain/usecases/get_mapped_episodes_usecase.dart';

class LoadSeasonsEpisodesUseCaseParams {
  final BaseProvider provider;
  final SearchResponseEntity searchResponse;
  final CacheRespository cacheRespository;

  final GetMappedEpisodesUseCase getMappedEpisodesUseCase;
  final void Function(MeiyouException error)? errorCallback;

  const LoadSeasonsEpisodesUseCaseParams(
      {required this.provider,
      required this.searchResponse,
      required this.getMappedEpisodesUseCase,
      required this.cacheRespository,
      this.errorCallback});
}

class LoadSeasonsEpisodesUseCase extends UseCase<
    Future<ResponseState<Map<num, List<EpisodeEntity>>>>,
    LoadSeasonsEpisodesUseCaseParams> {
  final WatchProviderRepository _repository;

  LoadSeasonsEpisodesUseCase(this._repository);

  @override
  Future<ResponseState<Map<num, List<EpisodeEntity>>>> call(
      LoadSeasonsEpisodesUseCaseParams params) {
    return _repository.loadSeasonsAndEpisodes(
        provider: params.provider,
        searchResponse: params.searchResponse,
        getMappedEpisodesUseCase: params.getMappedEpisodesUseCase,
        cacheRespository: params.cacheRespository,
        errorCallback: params.errorCallback);
  }
}
