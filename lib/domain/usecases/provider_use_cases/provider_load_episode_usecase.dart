import 'package:meiyou/core/resources/providers/base_provider.dart';
import 'package:meiyou/core/resources/response_state.dart';
import 'package:meiyou/core/usecases/usecase.dart';
import 'package:meiyou/domain/entities/episode.dart';
import 'package:meiyou/domain/repositories/watch_provider_repository.dart';

class ProviderLoadEpisodeUseCase
    implements UseCase<Future<ResponseState<List<EpisodeEntity>>>, String> {
  final WatchProviderRepository _repository;
  final BaseProvider _provider;

  const ProviderLoadEpisodeUseCase(
      {required WatchProviderRepository repository,
      required BaseProvider provider})
      : _repository = repository,
        _provider = provider;

  @override
  Future<ResponseState<List<EpisodeEntity>>> call(String params) {
    return _repository.loadEpisodes(_provider, params);
  }
}
