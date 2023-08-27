import 'package:meiyou/core/resources/providers/base_provider.dart';
import 'package:meiyou/core/resources/response_state.dart';
import 'package:meiyou/core/usecases/usecase.dart';
import 'package:meiyou/domain/entities/episode.dart';
import 'package:meiyou/domain/repositories/watch_provider_repository.dart';

class LoadEpisodeParams {
  final BaseProvider provider;
  final String url;
  final num? seasonNumber;
  final List<EpisodeEntity>? episodes;

  const LoadEpisodeParams(
      {required this.provider,
      required this.url,
      this.seasonNumber,
      this.episodes});
}

class LoadEpisodeUseCase
    implements
        UseCase<Future<ResponseState<List<EpisodeEntity>>>, LoadEpisodeParams> {
  final WatchProviderRepository _repository;

  const LoadEpisodeUseCase(
    this._repository ) ;

  @override
  Future<ResponseState<List<EpisodeEntity>>> call(LoadEpisodeParams params) {
    return _repository.loadEpisodes(
        params.provider, params.url, params.seasonNumber, params.episodes);
  }
}
