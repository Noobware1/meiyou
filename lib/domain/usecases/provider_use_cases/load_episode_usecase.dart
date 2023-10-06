import 'package:meiyou/core/resources/providers/base_provider.dart';
import 'package:meiyou/core/resources/response_state.dart';
import 'package:meiyou/core/usecases/usecase.dart';
import 'package:meiyou/domain/entities/episode.dart';
import 'package:meiyou/domain/entities/season.dart';
import 'package:meiyou/domain/repositories/watch_provider_repository.dart';

class LoadEpisodeParams {
  final BaseProvider provider;
  final String url;
  final SeasonEntity? season;

  const LoadEpisodeParams({
    required this.provider,
    required this.url,
    this.season,
  });
}

class LoadEpisodeUseCase
    implements
        UseCase<Future<ResponseState<List<EpisodeEntity>>>, LoadEpisodeParams> {
  final WatchProviderRepository _repository;

  const LoadEpisodeUseCase(this._repository);

  @override
  Future<ResponseState<List<EpisodeEntity>>> call(LoadEpisodeParams params) {
    return _repository.loadEpisodes(
      provider: params.provider,
      url: params.url,
      season: params.season,
    );
  }
}
