import 'package:meiyou/core/constants/path.dart';
import 'package:meiyou/core/constants/request_time_outs.dart';
import 'package:meiyou/core/resources/expections.dart';
import 'package:meiyou/core/resources/meta_provider.dart';
import 'package:meiyou/core/resources/response_state.dart';
import 'package:meiyou/core/utils/data_converter/converters.dart';
import 'package:meiyou/core/utils/extenstions/episode.dart';
import 'package:meiyou/core/utils/extenstions/iterable.dart';
import 'package:meiyou/core/utils/extenstions/list.dart';
import 'package:meiyou/core/utils/mapping/anilist_to_tmdb.dart';
import 'package:meiyou/core/utils/network.dart';
import 'package:meiyou/data/data_source/providers/meta_providers/anilist.dart';
import 'package:meiyou/data/data_source/providers/meta_providers/tmdb.dart';
import 'package:meiyou/data/models/episode.dart';
import 'package:meiyou/data/models/main_page.dart';
import 'package:meiyou/data/models/media_details.dart';
import 'package:meiyou/data/models/meta_response.dart';
import 'package:meiyou/data/models/results.dart';
import 'package:meiyou/data/models/row.dart';
import 'package:meiyou/data/models/season.dart';
import 'package:meiyou/domain/entities/media_details.dart';
import 'package:meiyou/domain/entities/meta_response.dart';
import 'package:meiyou/domain/entities/movie.dart';
import 'package:meiyou/domain/entities/season.dart';
import 'package:meiyou/domain/entities/episode.dart';
import 'package:meiyou/domain/repositories/cache_repository.dart';
import 'package:meiyou/domain/repositories/meta_provider_repository.dart';

class MetaProviderRepositoryImpl implements MetaProviderRepository {
  final TMDB _tmdb;
  final Anilist _anilist;

  MetaProviderRepositoryImpl(TMDB tmdb, Anilist anilist)
      : _tmdb = tmdb,
        _anilist = anilist;

  @override
  Future<ResponseState<List<Episode>>> fetchEpisodes(MediaDetailsEntity media,
      [SeasonEntity? season]) {
    return tryWithAsync(() async {
      final mediaDetails = MediaDetails.fromEntity(media);
      if (mediaDetails.mediaProvider == MediaProvider.anilist) {
        return _anilist.fetchEpisodes(mediaDetails);
      }

      return _tmdb.fetchEpisodes(
          mediaDetails, season != null ? Season.fromEntity(season) : null);
    }, timeout: tenSecondTimeOut);
  }

  @override
  Future<ResponseState<MainPage>> fetchMainPage() {
    return tryWithAsync(() async {
      final futures =
          await Future.wait([_anilist.fetchMainPage(), _tmdb.fetchMainPage()]);

      final rows = <MetaRow>[];

      rows.addAll([...(futures[0].rows), ...(futures[1].rows)]);

      final bannerRow = MetaRow.buildBannerList(
          rows
              .firstWhere((it) => it.rowTitle == 'Trending Anime')
              .resultsEntity
              .metaResponses
              .mapAsList((it) => MetaResponse.fromEntity(it)),
          rows
              .firstWhere((it) => it.rowTitle == 'Trending')
              .resultsEntity
              .metaResponses
              .mapAsList((it) => MetaResponse.fromEntity(it)));

      return MainPage([bannerRow, ...rows]);
    }, timeout: tenSecondTimeOut);
  }

  @override
  Future<ResponseState<MediaDetails>> fetchMediaDetails(
      MetaResponseEntity response) {
    return tryWithAsync(() async {
      final metaResponse = MetaResponse.fromEntity(response);

      final MediaDetails mediaDetails;
      if (metaResponse.mediaProvider == MediaProvider.anilist) {
        mediaDetails = await _anilist.fetchMediaDetails(
            metaResponse.id, metaResponse.mediaType!);
      } else {
        final MediaDetails? map;
        if (!metaResponse.isAnime()) {
          map = null;
        } else {
          map = await mapTmdbToAnilist(metaResponse, _anilist);
        }
        mediaDetails = map ??
            await _tmdb.fetchMediaDetails(
                metaResponse.id, metaResponse.mediaType!);
      }
      return mediaDetails;
    });
  }

  @override
  Future<List<Episode>> getMappedEpisodes(List<EpisodeEntity> episodes,
      {SeasonEntity? season,
      required CacheRespository cacheRespository,
      required MediaDetailsEntity mediaDetails}) async {
    final media = MediaDetails.fromEntity(mediaDetails);
    final episodesKey = '${mediaDetails.id}_meta-episodes';
    try {
      final List<Episode> episodesToMap;
      final key = season?.number ?? 1;
      final cache =
          await cacheRespository.getFromIOCache<Map<num, List<Episode>>>(
              episodesKey, CacheWriters.seasonEpisodeWriter.readFromJson);

      //checks if cache is exist beforehand
      if (cache != null) {
        //checks if the cache contains the given season
        if (cache.containsKey(key)) {
          episodesToMap = cache[key]!.mapAsList((it) => Episode.fromEntity(it));
        } else {
          //get new episodes for given seasons the adds them to new cache

          final getEpisodes = await _getEpisodes(
              (season == null ? null : Season.fromEntity(season)), media);

          if (getEpisodes != null) {
            cache[key] = getEpisodes;
            cacheRespository.updateIOCacheValue(episodesKey,
                CacheWriters.seasonEpisodeWriter.writeToJson(cache));

            episodesToMap = getEpisodes;
          } else {
            episodesToMap = episodes.mapAsList((it) => Episode.fromEntity(it));
          }
        }
      } else {
        //fetchs fresh episodes then caches them
        final Map<num, List<Episode>> map = {};
        if (media.mediaProvider == MediaProvider.tmdb) {
          for (var i = 0; i < (media.seasons?.length ?? 1); i++) {
            final currentSeason = media.seasons?[i];
            final response = await _getEpisodes(
                currentSeason != null ? Season.fromEntity(currentSeason) : null,
                media);
            if (response != null) map[currentSeason?.number ?? 1] = response;
          }
        } else {
          final response = await fetchEpisodes(media);
          if (response is ResponseSuccess) {
            map[1] = response.data!;
          }
        }

        cacheRespository.addIOCache(
            episodesKey, CacheWriters.seasonEpisodeWriter.writeToJson(map));
        episodesToMap = map[key]!.mapAsList((it) => Episode.fromEntity(it));
      }

      return List.generate(episodes.length, (i) {
        if (episodesToMap.length < episodes.length) {
          episodesToMap.fill(episodes.length, media);
        }

        return Episode(
            number: episodes[i].number,
            desc: episodes[i].desc ?? episodesToMap[i].desc,
            isFiller: episodes[i].isFiller ?? episodesToMap[i].isFiller,
            rated: episodes[i].rated ?? episodesToMap[i].rated,
            thumbnail: episodes[i].thumbnail ?? episodesToMap[i].thumbnail,
            title: episodes[i].title ?? episodesToMap[i].title,
            url: episodes[i].url);
      });
    } catch (_) {
      return episodes.mapAsList((it) => Episode.fromEntity(it).copyWith(
            title: it.title ?? 'Episode ${it.number}',
            thumbnail: it.thumbnail ?? media.bannerImage ?? media.poster,
          ));
    }
  }

  Future<List<Episode>?> _getEpisodes(
      Season? season, MediaDetails mediaDetails) async {
    final response = await fetchEpisodes(mediaDetails, season);
    if (response is ResponseSuccess) {
      return response.data!.mapAsList((it) => Episode.fromEntity(it));
    }
    return null;
  }

  @override
  Future<ResponseState<MetaResults>> fetchSearch(String query,
      {int page = 1, bool isAdult = false}) {
    return tryWithAsync(() async {
      final results = <MetaResponse>[];

      final future = await Future.wait([
        _tmdb.fetchSearch(query, page: page, isAdult: isAdult),
        _anilist.fetchSearch(query, page: page, isAdult: isAdult)
      ]);

      results.addAll(future[0]
          .metaResponses
          .whereSafe((it) => !(it as MetaResponse).isAnime())
          .map((it) => MetaResponse.fromEntity(it)));
      results.addAll(
          future[1].metaResponses.map((it) => MetaResponse.fromEntity(it)));

      if (results.isNotEmpty) {
        return MetaResults(totalPage: 1, metaResponses: results);
      }
      throw const MeiyouException('The search response is empty',
          type: MeiyouExceptionType.providerException);
    }, timeout: twentySecondTimeOut);
  }

  @override
  MovieEntity getMappedMovie(MovieEntity movie,
      {required MediaDetailsEntity mediaDetails}) {
    return MovieEntity(
        url: movie.url,
        cover: movie.cover ?? mediaDetails.bannerImage ?? mediaDetails.poster,
        description: movie.description ?? mediaDetails.description,
        title: movie.title ?? mediaDetails.title,
        rated: movie.rated ?? mediaDetails.averageScore);
  }
}
