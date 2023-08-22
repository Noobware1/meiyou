import 'package:meiyou/core/resources/expections.dart';
import 'package:meiyou/core/resources/extractors/video_extractor.dart';
import 'package:meiyou/core/resources/provider_type.dart';
import 'package:meiyou/core/resources/providers/anime_provider.dart';
import 'package:meiyou/core/resources/providers/base_provider.dart';
import 'package:meiyou/core/resources/providers/movie_provider.dart';
import 'package:meiyou/core/resources/response_state.dart';
import 'package:meiyou/core/utils/network.dart';
import 'package:meiyou/data/models/episode.dart';
import 'package:meiyou/data/models/media_details.dart';
import 'package:meiyou/data/models/movie.dart';
import 'package:meiyou/data/models/search_response.dart';
import 'package:meiyou/data/models/season.dart';
import 'package:meiyou/data/models/video_server.dart';
import 'package:meiyou/domain/entities/media_details.dart';
import 'package:meiyou/domain/entities/search_response.dart';
import 'package:meiyou/domain/entities/video_server.dart';
import 'package:meiyou/domain/repositories/watch_provider_repository.dart';

class WatchProviderRepositoryImpl implements WatchProviderRepository {
  final MediaDetails _media;

  WatchProviderRepositoryImpl(
    MediaDetailsEntity media,
  ) : _media = MediaDetails.fromMediaDetailsEntity(media);

  MovieProvider _getMovieProvider(BaseProvider provider) =>
      provider as MovieProvider;
  AnimeProvider _getAnimeProvider(BaseProvider provider) =>
      provider as AnimeProvider;
  bool isAnimeProvider(BaseProvider provider) => provider is AnimeProvider;
  bool isMovieProvider(BaseProvider provider) => provider is MovieProvider;

  @override
  Future<ResponseState<List<Episode>>> loadEpisodes(
      BaseProvider provider, String url) {
    return tryWithAsync(() async {
      final List<Episode> episodes;
      if (provider.providerType == ProviderType.meta) {
        throw UnimplementedError();
      } else if (isAnimeProvider(provider)) {
        episodes = await _getAnimeProvider(provider).loadEpisodes(url);
      } else {
        episodes = await _getMovieProvider(provider).loadEpisodes(url);
      }
      return episodes;
    });
  }

  @override
  Future<ResponseState<Movie>> loadMovie(BaseProvider provider, String url) {
    return tryWithAsync(() async {
      if (isMovieProvider(provider)) {
        return _getMovieProvider(provider).loadMovie(url);
      } else {
        throw MeiyouException(
            'Load Movie is Not Supported on ${provider.providerType}');
      }
    });
  }

  @override
  Future<ResponseState<List<Season>>> loadSeason(
      BaseProvider provider, String url) {
    return tryWithAsync(() async {
      if (isMovieProvider(provider)) {
        return _getMovieProvider(provider).loadSeasons(url);
      } else {
        throw MeiyouException(
            'load Season is not supported on ${provider.providerType}');
      }
    });
  }

  @override
  VideoExtractor? loadVideoExtractor(
      BaseProvider provider, VideoSeverEntity videoServer) {
    if (isMovieProvider(provider)) {
      return _getMovieProvider(provider)
          .loadVideoExtractor(videoServer as VideoServer);
    } else if (isAnimeProvider(provider)) {
      return _getAnimeProvider(provider)
          .loadVideoExtractor(videoServer as VideoServer);
    } else {
      throw UnimplementedError();
    }
  }

  @override
  Future<ResponseState<List<VideoServer>>> loadVideoServer(
      BaseProvider provider, String url) {
    return tryWithAsync(() async {
      if (isMovieProvider(provider)) {
        return _getMovieProvider(provider).loadVideoServer(url);
      } else if (isAnimeProvider(provider)) {
        return _getAnimeProvider(provider).loadVideoServer(url);
      } else {
        throw UnimplementedError();
      }
    });
  }

  @override
  Future<ResponseState<List<SearchResponseEntity>>> searchUsingMedia(
      BaseProvider provider) {
    final String query;
    if (isAnimeProvider(provider)) {
      query = _media.romaji ?? _media.title ?? _media.native ?? '';
    } else {
      query = _media.title ?? _media.native ?? '';
    }
    return searchWithQuery(provider, query);
  }

  @override
  Future<ResponseState<List<SearchResponseEntity>>> searchWithQuery(
      BaseProvider provider, String query) {
    return tryWithAsync(() async {
      if (isMovieProvider(provider)) {
        return _getMovieProvider(provider).search(query);
      } else if (isAnimeProvider(provider)) {
        return _getAnimeProvider(provider).search(query);
      } else {
        throw UnimplementedError();
      }
    });
  }
}
