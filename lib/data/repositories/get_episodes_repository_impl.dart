import 'package:meiyou/core/resources/meta_provider.dart';
import 'package:meiyou/core/resources/response_state.dart';
import 'package:meiyou/core/utils/extenstions/episode.dart';
import 'package:meiyou/core/utils/extenstions/iterable.dart';
import 'package:meiyou/data/models/episode.dart';
import 'package:meiyou/data/models/media_details.dart';
import 'package:meiyou/data/models/season.dart';
import 'package:meiyou/domain/entities/episode.dart';
import 'package:meiyou/domain/entities/media_details.dart';
import 'package:meiyou/domain/entities/season.dart';
import 'package:meiyou/domain/repositories/cache_repository.dart';
import 'package:meiyou/domain/repositories/get_episodes_repository.dart';
import 'package:meiyou/domain/repositories/meta_provider_repository.dart';

class GetEpisodeRepositoryImpl implements GetEpisodesRepository {
  final MetaProviderRepository _metaProviderRepository;
  final CacheRespository _cacheRespository;
  final MediaDetails _mediaDetails;
  static const _episodesKey = 'meta-episodes';

  GetEpisodeRepositoryImpl(
      {required MetaProviderRepository metaProviderRepository,
      required CacheRespository cacheRespository,
      required MediaDetailsEntity mediaDetails})
      : _cacheRespository = cacheRespository,
        _metaProviderRepository = metaProviderRepository,
        _mediaDetails = MediaDetails.fromEntity(mediaDetails);



  @override
  Future<List<Episode>> getEpisodes(
      List<EpisodeEntity> episodes, SeasonEntity? season) async {
    final List<Episode> episodesToMap;
    final key = season?.number ?? 1;
    final cache =
        _cacheRespository.get<Map<num, List<EpisodeEntity>>>(_episodesKey);
    //checks if cache is exist beforehand
    if (cache != null) {
      //checks if the cache contains the given season
      if (cache.containsKey(key)) {
        episodesToMap = cache[key]!.mapAsList((it) => Episode.fromEntity(it));
      } else {
        //get new episodes for given seasons the adds them to new cache

        final getEpisodes = await _getEpisodes(
            season == null ? null : Season.fromEntity(season));

        if (getEpisodes != null) {
          cache[key] = getEpisodes;
          _cacheRespository.update(_episodesKey, cache);

          episodesToMap = getEpisodes;
        } else {
          episodesToMap = episodes.mapAsList((it) => Episode.fromEntity(it));
        }
      }
    } else {
      //fetchs fresh episodes then caches them
      final Map<num, List<EpisodeEntity>> map = {};
      if (_mediaDetails.mediaProvider == MediaProvider.tmdb) {
        for (var i = 0; i < (_mediaDetails.seasons?.length ?? 1); i++) {
          final currentSeason = _mediaDetails.seasons?[i];
          final response = await _getEpisodes(currentSeason);
          if (response != null) {
            map[currentSeason?.number ?? 1] = response;
          }
        }
      } else {
        final response =
            await _metaProviderRepository.fetchEpisodes(_mediaDetails);
        if (response is ResponseSuccess) {
          map[1] = response.data!;
        }
      }

      _cacheRespository.add(_episodesKey, data: map);
      episodesToMap = map[key]!.mapAsList((it) => Episode.fromEntity(it));
    }

    return List.generate(episodes.length, (i) {
      if (episodesToMap.length < episodes.length) {
        episodesToMap.fill(episodes.length, _mediaDetails);
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
  }

  Future<List<Episode>?> _getEpisodes(Season? season) async {
    final response =
        await _metaProviderRepository.fetchEpisodes(_mediaDetails, season);
    if (response is ResponseSuccess) {
      return response.data!.mapAsList((it) => Episode.fromEntity(it));
    }
    return null;
  }
}
