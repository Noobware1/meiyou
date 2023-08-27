import 'package:meiyou/core/resources/expections.dart';
import 'package:meiyou/core/resources/extractors/video_extractor.dart';
import 'package:meiyou/core/resources/provider_type.dart';
import 'package:meiyou/core/resources/providers/anime_provider.dart';
import 'package:meiyou/core/resources/providers/base_provider.dart';
import 'package:meiyou/core/resources/providers/movie_provider.dart';
import 'package:meiyou/core/resources/providers/tmdb_provider.dart';
import 'package:meiyou/core/resources/response_state.dart';
import 'package:meiyou/core/utils/comparing_strings.dart';
import 'package:meiyou/core/utils/extenstions/iterable.dart';
import 'package:meiyou/core/utils/extenstions/string.dart';
import 'package:meiyou/core/utils/generate_episode_chunks.dart';
import 'package:meiyou/core/utils/network.dart';
import 'package:meiyou/data/models/episode.dart';
import 'package:meiyou/data/models/media_details.dart';
import 'package:meiyou/data/models/movie.dart';
import 'package:meiyou/data/models/search_response.dart';
import 'package:meiyou/data/models/season.dart';
import 'package:meiyou/data/models/video_server.dart';
import 'package:meiyou/domain/entities/episode.dart';
import 'package:meiyou/domain/entities/media_details.dart';
import 'package:meiyou/domain/entities/search_response.dart';
import 'package:meiyou/domain/entities/video_server.dart';
import 'package:meiyou/domain/repositories/watch_provider_repository.dart';

class WatchProviderRepositoryImpl implements WatchProviderRepository {
  final MediaDetails _media;

  WatchProviderRepositoryImpl(
    MediaDetailsEntity media,
  ) : _media = MediaDetails.fromEntity(media);

  MovieProvider _getMovieProvider(BaseProvider provider) =>
      provider as MovieProvider;
  AnimeProvider _getAnimeProvider(BaseProvider provider) =>
      provider as AnimeProvider;
  TMDBProvider _getTMDBProvider(BaseProvider provider) =>
      provider as TMDBProvider;
  bool isTMDBProvider(BaseProvider provider) => provider is TMDBProvider;

  bool isAnimeProvider(BaseProvider provider) => provider is AnimeProvider;
  bool isMovieProvider(BaseProvider provider) => provider is MovieProvider;

  @override
  Future<ResponseState<List<EpisodeEntity>>> loadEpisodes(BaseProvider provider,
      String url, num? seasonNumber, List<EpisodeEntity>? episodes) {
    return tryWithAsync(() async {
      final List<Episode> getEpisodes;
      if (provider.providerType == ProviderType.meta) {
        throw UnimplementedError();
      } else if (isAnimeProvider(provider)) {
        getEpisodes = await _getAnimeProvider(provider).loadEpisodes(url);
      } else if (isTMDBProvider(provider)) {
        getEpisodes = await _getTMDBProvider(provider).loadEpisodes(
            Season(
              id: url.toInt(),
              number: seasonNumber ?? 1,
            ),
            episodes!.mapAsList((it) => Episode.fromEntity(it)));
      } else {
        getEpisodes = await _getMovieProvider(provider).loadEpisodes(url);
      }
      return getEpisodes;
    }, timeout: const Duration(seconds: 10));
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
      } else if (isTMDBProvider(provider)) {
        if (_media.seasons == null) {
          throw const MeiyouException(
              'Seasons is null, either the seasons from the [MediaDetails] is null or the mediaType is not correct');
        }
        return _getTMDBProvider(provider)
            .loadSeasons(url, _media.seasons!.mapAsList(Season.fromEntity));
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
  Future<ResponseState<List<VideoServer>>> loadVideoServers(
      BaseProvider provider, String url) {
    return tryWithAsync(() async {
      if (isMovieProvider(provider)) {
        return _getMovieProvider(provider).loadVideoServers(url);
      } else if (isAnimeProvider(provider)) {
        return _getAnimeProvider(provider).loadVideoServers(url);
      } else {
        throw UnimplementedError();
      }
    });
  }

  @override
  SearchResponse findBestSearchResponse(
      List<SearchResponseEntity> responses, ProviderType type) {
    final String? title;
    final titles = responses.map((it) => it.title).toList();
    if (type == ProviderType.anime) {
      title = _media.romaji ?? _media.title ?? _media.native;
    } else {
      title = _media.title ?? _media.romaji ?? _media.native;
    }

    final index = findBestMatch(title ?? '', titles).index;

    return SearchResponse.fromEntity(responses[index]);
  }

  @override
  String getMediaTitle() =>
      _media.title ?? _media.romaji ?? _media.native ?? '';

  @override
  Future<ResponseState<List<SearchResponseEntity>>> search(
    BaseProvider provider, {
    String? query,
  }) {
    if (isTMDBProvider(provider)) {
      return tryWithAsync(() => _getTMDBProvider(provider).search(_media));
    }
    if (query != null) {
      return searchWithQuery(provider, query);
    }
    return searchUsingMedia(provider);
  }

  @override
  Future<ResponseState<List<SearchResponseEntity>>> searchUsingMedia(
      BaseProvider provider) {
    final String query;
    if (isAnimeProvider(provider)) {
      query = _media.romaji ?? _media.title ?? _media.native ?? '';
    } else {
      query = getMediaTitle();
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

  @override
  Map<String, List<EpisodeEntity>> getEpisodeChunks(
      List<EpisodeEntity> episodes) {
    return GenerateEpisodesChunks.buildEpisodesResponse(
        episodes.mapAsList((it) => Episode.fromEntity(it)));
  }
}
