import 'package:meiyou/core/resources/extractors/video_extractor.dart';
import 'package:meiyou/core/resources/provider_type.dart';
import 'package:meiyou/core/resources/providers/base_provider.dart';
import 'package:meiyou/core/resources/response_state.dart';
import 'package:meiyou/domain/entities/episode.dart';
import 'package:meiyou/domain/entities/movie.dart';
import 'package:meiyou/domain/entities/search_response.dart';
import 'package:meiyou/domain/entities/season.dart';
import 'package:meiyou/domain/entities/video_server.dart';

abstract interface class WatchProviderRepository {
  String getMediaTitle();

  SearchResponseEntity findBestSearchResponse(
      List<SearchResponseEntity> responses, ProviderType type);

  Future<ResponseState<List<SearchResponseEntity>>> search(
    BaseProvider provider, {
    String? query,
  });

  Future<ResponseState<List<SearchResponseEntity>>> searchWithQuery(
      BaseProvider provider, String query);

  Future<ResponseState<List<SearchResponseEntity>>> searchUsingMedia(
    BaseProvider provider,
  );

  Future<ResponseState<List<EpisodeEntity>>> loadEpisodes(
      BaseProvider provider, String url, int? seasonNumber,
      List<EpisodeEntity>? episodes);

  Future<ResponseState<List<SeasonEntity>>> loadSeason(
      BaseProvider provider, String url);

  Future<ResponseState<MovieEntity>> loadMovie(
      BaseProvider provider, String url);

  Future<ResponseState<List<VideoSeverEntity>>> loadVideoServers(
      BaseProvider provider, String url);

  VideoExtractor? loadVideoExtractor(
      BaseProvider provider, VideoSeverEntity videoServer);
}
