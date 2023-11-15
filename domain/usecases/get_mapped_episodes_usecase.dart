import 'package:meiyou/core/usecases/usecase.dart';
import 'package:meiyou/domain/entities/episode.dart';
import 'package:meiyou/domain/entities/media_details.dart';
import 'package:meiyou/domain/entities/season.dart';
import 'package:meiyou/domain/repositories/cache_repository.dart';
import 'package:meiyou/domain/repositories/meta_provider_repository.dart';

class GetMappedEpisodesParams {
  final CacheRespository cacheRepository;
  final List<EpisodeEntity> episodes;
  final MediaDetailsEntity mediaDetails;
  final SeasonEntity? season;
  GetMappedEpisodesParams(
      {required this.cacheRepository,
      required this.episodes,
      required this.mediaDetails,
      this.season});
}

class GetMappedEpisodesUseCase
    implements UseCase<Future<List<EpisodeEntity>>, GetMappedEpisodesParams> {
  final MetaProviderRepository repository;

  GetMappedEpisodesUseCase(this.repository);

  @override
  Future<List<EpisodeEntity>> call(GetMappedEpisodesParams params) {
    return repository.getMappedEpisodes(params.episodes,
        cacheRespository: params.cacheRepository,
        mediaDetails: params.mediaDetails,
        season: params.season);
  }
}
