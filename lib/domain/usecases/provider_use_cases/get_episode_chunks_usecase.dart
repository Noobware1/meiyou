import 'package:meiyou/core/usecases/usecase.dart';
import 'package:meiyou/domain/entities/episode.dart';
import 'package:meiyou/domain/repositories/watch_provider_repository.dart';

class GetEpisodeChunksUseCase
    implements UseCase<Map<String, List<EpisodeEntity>>, List<EpisodeEntity>> {
  final WatchProviderRepository _repository;

  GetEpisodeChunksUseCase(this._repository);

  @override
  Map<String, List<EpisodeEntity>> call(List<EpisodeEntity> params) {
    return _repository.getEpisodeChunks(params);
  }
}
