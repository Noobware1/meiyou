import 'dart:async';
import 'dart:convert';

import 'package:meiyou/core/constants/path.dart';
import 'package:meiyou/core/constants/request_time_outs.dart';
import 'package:meiyou/core/resources/expections.dart';
import 'package:meiyou/core/resources/extractors/video_extractor.dart';
import 'package:meiyou/core/resources/media_type.dart';
import 'package:meiyou/core/resources/prefrences.dart';
import 'package:meiyou/core/resources/provider_type.dart';
import 'package:meiyou/core/resources/providers/anime_provider.dart';
import 'package:meiyou/core/resources/providers/base_provider.dart';
import 'package:meiyou/core/resources/providers/movie_provider.dart';
import 'package:meiyou/core/resources/providers/tmdb_provider.dart';
import 'package:meiyou/core/resources/response_state.dart';
import 'package:meiyou/core/utils/comparing_strings.dart';
import 'package:meiyou/core/utils/data_converter/converters.dart';
import 'package:meiyou/core/utils/extenstions/iterable.dart';
import 'package:meiyou/core/utils/fix_file_name.dart';
import 'package:meiyou/core/utils/generate_episode_chunks.dart';
import 'package:meiyou/core/utils/network.dart';
import 'package:meiyou/data/models/episode.dart';
import 'package:meiyou/data/models/media_details.dart';
import 'package:meiyou/data/models/movie.dart';
import 'package:meiyou/data/models/search_response.dart';
import 'package:meiyou/data/models/season.dart';
import 'package:meiyou/data/models/video_container.dart';
import 'package:meiyou/data/models/video_server.dart';
import 'package:meiyou/domain/entities/episode.dart';
import 'package:meiyou/domain/entities/media_details.dart';
import 'package:meiyou/domain/entities/search_response.dart';
import 'package:meiyou/domain/entities/season.dart';
import 'package:meiyou/domain/entities/video_container.dart';
import 'package:meiyou/domain/entities/video_server.dart';
import 'package:meiyou/domain/repositories/cache_repository.dart';
import 'package:meiyou/domain/repositories/watch_provider_repository.dart';
import 'package:meiyou/domain/usecases/get_mapped_episodes_usecase.dart';

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
  Future<ResponseState<List<EpisodeEntity>>> loadEpisodes(
      {required BaseProvider provider,
      required String url,
      SeasonEntity? season}) {
    return tryWithAsync(() async {
      final List<Episode> getEpisodes;

      if (provider.providerType == ProviderType.meta) {
        throw UnimplementedError();
      } else if (isAnimeProvider(provider)) {
        getEpisodes = await _getAnimeProvider(provider).loadEpisodes(url);
      } else if (isTMDBProvider(provider)) {
        getEpisodes = await _getTMDBProvider(provider).loadEpisodes(
            season != null
                ? Season.fromEntity(season)
                : const Season(number: 1));
      } else {
        getEpisodes = await _getMovieProvider(provider).loadEpisodes(url);
      }

      return getEpisodes;
    }, timeout: thirtySecondTimeOut);
  }

  @override
  Future<ResponseState<Movie>> loadMovie(
      BaseProvider provider, String url, CacheRespository cacheRespository) {
    return tryWithAsync(() async {
      final cache = await tryWithAsyncSafe(() =>
          cacheRespository.getFromIOCache<Movie>(
              '${getFileNameFromUrl(url)}_movie.cache',
              CacheWriters.movieWriter.readFromJson));

      if (cache != null) return cache;

      final ResponseState<Movie> response;
      if (isTMDBProvider(provider)) {
        response =
            await tryWithAsync(() => _getTMDBProvider(provider).loadMovie(url));
      } else if (isMovieProvider(provider)) {
        response = await tryWithAsync(
            () => _getMovieProvider(provider).loadMovie(url));
      } else {
        throw MeiyouException(
            'Load Movie is Not Supported on ${provider.providerType}');
      }
      if (response is ResponseFailed) {
        throw response.error!;
      }

      cacheRespository.addIOCache('${getFileNameFromUrl(url)}_movie.cache',
          CacheWriters.movieWriter.writeToJson(response.data!));
      return response.data!;
    }, timeout: twentySecondTimeOut);
  }

  @override
  Future<ResponseState<List<Season>>> loadSeason(
      BaseProvider provider, String url) {
    return tryWithAsync(() async {
      final List<Season> seasons;

      if (isMovieProvider(provider)) {
        seasons = await _getMovieProvider(provider).loadSeasons(url);
      } else if (isTMDBProvider(provider)) {
        if (_media.seasons == null) {
          throw const MeiyouException(
              'Seasons is null, either the seasons from the [MediaDetails] is null or the mediaType is not correct');
        }
        seasons =
            await _getTMDBProvider(provider).loadSeasons(url, _media.seasons!);
      } else {
        throw MeiyouException(
            'load Season is not supported on ${provider.providerType}');
      }

      return seasons;
    }, timeout: twentySecondTimeOut);
  }

  @override
  VideoExtractor? loadVideoExtractor(
      BaseProvider provider, VideoSeverEntity videoServer) {
    final VideoExtractor? extractor;
    if (isMovieProvider(provider)) {
      extractor = _getMovieProvider(provider)
          .loadVideoExtractor(videoServer as VideoServer);
    } else if (isAnimeProvider(provider)) {
      extractor = _getAnimeProvider(provider)
          .loadVideoExtractor(videoServer as VideoServer);
    } else if (isTMDBProvider(provider)) {
      extractor = _getTMDBProvider(provider)
          .loadVideoExtractor(videoServer as VideoServer);
    } else {
      throw UnimplementedError();
    }

    return extractor;
  }

  @override
  Future<ResponseState<List<VideoServer>>> loadVideoServers(
      BaseProvider provider, String url) {
    return tryWithAsync(() async {
      if (isMovieProvider(provider)) {
        return _getMovieProvider(provider).loadVideoServers(url);
      } else if (isAnimeProvider(provider)) {
        return _getAnimeProvider(provider).loadVideoServers(url);
      } else if (isTMDBProvider(provider)) {
        return _getTMDBProvider(provider).loadVideoServers(url);
      } else {
        throw UnimplementedError();
      }
    }, timeout: twentySecondTimeOut);
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
      BaseProvider provider,
      {String? query,
      required CacheRespository cacheRespository}) {
    return tryWithAsync(() async {
      final cache = await tryWithAsyncSafe(() =>
          cacheRespository.getFromIOCache(
              _SavePaths.searchResponsePath(provider, _media, query),
              CacheWriters.searchResponseListWriter.readFromJson));
      if (cache != null) return cache;
      final ResponseState<List<SearchResponse>> response;
      if (isTMDBProvider(provider)) {
        response =
            await tryWithAsync(() => _getTMDBProvider(provider).search(_media));
      } else if (query != null) {
        response = await searchWithQuery(provider, query);
      } else {
        response = await searchUsingMedia(provider);
      }

      if (response is ResponseFailed) {
        throw response.error!;
      } else {
        await tryWithAsyncSafe(() => cacheRespository.addIOCache(
            _SavePaths.searchResponsePath(provider, _media, query),
            CacheWriters.searchResponseListWriter.writeToJson(response.data!)));

        return response.data!;
      }
    }, timeout: twentySecondTimeOut);
  }

  void _checksAreParamsVaild(
      BaseProvider provider, SearchResponseEntity searchResponseEntity) {
    if (searchResponseEntity.type == MediaType.anime &&
        provider.providerType != ProviderType.anime) {
      throw ArgumentError.value(searchResponseEntity, null,
          'Cannot load anime in ${provider.name} because it has type ${provider.providerType}');
    } else if ((searchResponseEntity.type == MediaType.movie ||
                searchResponseEntity.type == MediaType.tvShow) &&
            provider.providerType == ProviderType.anime ||
        provider.providerType == ProviderType.meta) {
      throw ArgumentError.value(searchResponseEntity, null,
          'Cannot load anime on ${provider.name} because it has type ${provider.providerType}');
    }
  }

  @override
  Future<ResponseState<Map<num, List<Episode>>>> loadSeasonsAndEpisodes(
      {required BaseProvider provider,
      required SearchResponseEntity searchResponse,
      required GetMappedEpisodesUseCase getMappedEpisodesUseCase,
      required CacheRespository cacheRespository,
      void Function(MeiyouException exception)? errorCallback}) {
    return tryWithAsync(() async {
      _checksAreParamsVaild(provider, searchResponse);

      final cache = await tryWithAsyncSafe(() =>
          cacheRespository.getFromIOCache(
              _SavePaths.episodesPath(provider, searchResponse),
              CacheWriters.seasonEpisodeWriter.readFromJson));

      if (cache != null) return cache;

      final Map<num, List<Episode>> map = {};

      ResponseState<List<EpisodeEntity>> episodeResponse;

      if (isAnimeProvider(provider)) {
        episodeResponse = await loadEpisodes(
          provider: provider,
          url: searchResponse.url,
        );
        if (episodeResponse is ResponseFailed) {
          throw episodeResponse.error!;
          // errorCallback?.call(episodeResponse.error!)
        } else {
          map[0] = (await getMappedEpisodesUseCase.call(GetMappedEpisodesParams(
                  cacheRepository: cacheRespository,
                  episodes: episodeResponse.data!,
                  mediaDetails: _media)))
              .mapAsList(Episode.fromEntity);
        }
      } else {
        final seasons = await loadSeason(provider, searchResponse.url);
        if (seasons is ResponseFailed) {
          throw seasons.error!;
        }

        for (final season in seasons.data!) {
          episodeResponse = await loadEpisodes(
              provider: provider, url: season.url!, season: season);
          // MetaProviderRepositoryImpl().getMappedEpisodes(episodes, cacheRespository: cacheRespository, mediaDetails: _media)
          if (episodeResponse is ResponseFailed) {
            errorCallback?.call(episodeResponse.error!);
          } else {
            map[season.number] = (await getMappedEpisodesUseCase.call(
                    GetMappedEpisodesParams(
                        cacheRepository: cacheRespository,
                        episodes: episodeResponse.data!,
                        mediaDetails: _media,
                        season: season)))
                .mapAsList(Episode.fromEntity);
          }
        }
      }

      await tryWithAsyncSafe<void>(() => cacheRespository.addIOCache(
            _SavePaths.episodesPath(provider, searchResponse),
            CacheWriters.seasonEpisodeWriter.writeToJson(map),
          ));

      return map;
    }, timeout: thirtySecondTimeOut);
  }

  @override
  Future<ResponseState<List<SearchResponse>>> searchUsingMedia(
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
  Future<ResponseState<List<SearchResponse>>> searchWithQuery(
      BaseProvider provider, String query) {
    return tryWithAsync(() async {
      if (isMovieProvider(provider)) {
        return _getMovieProvider(provider).search(query);
      } else if (isAnimeProvider(provider)) {
        return _getAnimeProvider(provider).search(query);
      } else {
        throw UnimplementedError();
      }
    }, timeout: twentySecondTimeOut);
  }

  @override
  Future<SearchResponse?> loadSavedSearchResponse(
      String savePath, BaseProvider provider) async {
    return await loadData(
        savePath:
            savePath + '\\' + _SavePaths.saveResponsePath(provider, _media),
        transFormer: SearchResponse.fromJson,
        onError: (e) => print(e));
  }

  @override
  Future<void> saveSearchResponse({
    required String savePath,
    required BaseProvider provider,
    required SearchResponseEntity searchResponse,
  }) async {
    return await saveData(
        savePath:
            savePath + '\\' + _SavePaths.saveResponsePath(provider, _media),
        data: jsonEncode(SearchResponse.fromEntity(searchResponse).toJson()),
        onCompleted: () => print('data written successFul'),
        onError: (e) => print(e));
  }

  @override
  Map<String, List<EpisodeEntity>> getEpisodeChunks(
      List<EpisodeEntity> episodes) {
    return GenerateEpisodesChunks.buildEpisodesResponse(
        episodes.mapAsList((it) => Episode.fromEntity(it)));
  }

  @override
  Future<ResponseState<Map<String, VideoContainer>>> loadServerAndVideo({
    required BaseProvider provider,
    required String url,
    required CacheRespository cacheRespository,
    void Function(Map<String, VideoContainerEntity> data)? onData,
    void Function(
            MeiyouException error, Map<String, VideoContainerEntity>? data)?
        onError,
  }) {
    return tryWithAsync(() async {
      final cache = await tryWithAsyncSafe(() =>
          cacheRespository.getFromIOCache(
              _SavePaths.serverAndVideoPath(provider, url),
              CacheWriters.videoServerVideoContainerMapWriter.readFromJson));

      if (cache != null) return cache;

      final response = await loadVideoServers(provider, url);
      if (response is ResponseFailed) {
        throw response.error!;
      } else {
        final Map<String, VideoContainer> data = {};
        for (final server in response.data!) {
          final extractor = loadVideoExtractor(provider, server);
          if (extractor != null) {
            try {
              final extracted = await extractor.extract();
              data[server.name] = extracted;
              onData?.call(data);
            } catch (e, stack) {
              onError?.call(
                  MeiyouException(
                    e.toString(),
                    stackTrace: stack,
                    type: MeiyouExceptionType.providerException,
                  ),
                  data);
            }
          }
        }
        if (data.isNotEmpty) {
          await tryWithAsyncSafe(() => cacheRespository.addIOCache(
              _SavePaths.serverAndVideoPath(provider, url),
              CacheWriters.videoServerVideoContainerMapWriter
                  .writeToJson(data)));
        }
        return data;
      }
    }, timeout: fourtySecondTimeOut);
  }
}

class _SavePaths {
  static String saveResponsePath(BaseProvider provider, MediaDetails media) =>
      '${provider.name}_${media.id}';

  static String episodesPath(
          BaseProvider provider, SearchResponseEntity searchResponse) =>
      '${provider.name}_${fixFileName(searchResponse.title)}_episodes.cache';

  static String searchResponsePath(BaseProvider provider, MediaDetails media,
          [String? query]) =>
      '${provider.name}_${fixFileName(query ?? media.mediaTitle)}';

  static String serverAndVideoPath(BaseProvider provider, String url) =>
      '${provider.name}_${url.hashCode}';
}
