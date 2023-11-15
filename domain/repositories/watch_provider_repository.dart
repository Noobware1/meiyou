import 'package:meiyou/core/resources/expections.dart';
import 'package:meiyou/core/resources/extractors/video_extractor.dart';
import 'package:meiyou/core/resources/provider_type.dart';
import 'package:meiyou/core/resources/providers/base_provider.dart';
import 'package:meiyou/core/resources/response_state.dart';
import 'package:meiyou/domain/entities/episode.dart';
import 'package:meiyou/domain/entities/movie.dart';
import 'package:meiyou/domain/entities/search_response.dart';
import 'package:meiyou/domain/entities/season.dart';
import 'package:meiyou/domain/entities/video_container.dart';
import 'package:meiyou/domain/entities/video_server.dart';
import 'package:meiyou/domain/repositories/cache_repository.dart';
import 'package:meiyou/domain/usecases/get_mapped_episodes_usecase.dart';

abstract interface class WatchProviderRepository {
  String getMediaTitle();

  SearchResponseEntity findBestSearchResponse(
      List<SearchResponseEntity> responses, ProviderType type);

  Future<ResponseState<List<SearchResponseEntity>>> search(
    BaseProvider provider, {
    String? query,
    required CacheRespository cacheRespository,
  });

  Future<ResponseState<List<SearchResponseEntity>>> searchWithQuery(
      BaseProvider provider, String query);

  Future<ResponseState<List<SearchResponseEntity>>> searchUsingMedia(
    BaseProvider provider,
  );

  Future<ResponseState<List<EpisodeEntity>>> loadEpisodes({
    required BaseProvider provider,
    required String url,
    SeasonEntity? season,
  });

  Future<ResponseState<List<SeasonEntity>>> loadSeason(
      BaseProvider provider, String url);

  Future<ResponseState<MovieEntity>> loadMovie(
      BaseProvider provider, String url, CacheRespository cacheRespository);

  Future<ResponseState<List<VideoSeverEntity>>> loadVideoServers(
      BaseProvider provider, String url);

  VideoExtractor? loadVideoExtractor(
      BaseProvider provider, VideoSeverEntity videoServer);

  Map<String, List<EpisodeEntity>> getEpisodeChunks(
      List<EpisodeEntity> episodes);

  Future<ResponseState<Map<num, List<EpisodeEntity>>>> loadSeasonsAndEpisodes(
      {required BaseProvider provider,
      required SearchResponseEntity searchResponse,
      required GetMappedEpisodesUseCase getMappedEpisodesUseCase,
      required CacheRespository cacheRespository,
      void Function(MeiyouException exception)? errorCallback});

  Future<SearchResponseEntity?> loadSavedSearchResponse(
      String savePath, BaseProvider provider);

  Future<void> saveSearchResponse({
    required String savePath,
    required BaseProvider provider,
    required SearchResponseEntity searchResponse,
  });

  Future<ResponseState<Map<String, VideoContainerEntity>>> loadServerAndVideo({
    required BaseProvider provider,
    required String url,
    required CacheRespository cacheRespository,
    void Function(Map<String, VideoContainerEntity> data)? onData,
    void Function(
            MeiyouException error, Map<String, VideoContainerEntity>? data)?
        onError,
  });
}
