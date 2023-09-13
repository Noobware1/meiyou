import 'package:meiyou/core/resources/response_state.dart';
import 'package:meiyou/domain/entities/media_details.dart';
import 'package:meiyou/domain/entities/meta_response.dart';
import 'package:meiyou/domain/entities/movie.dart';
import 'package:meiyou/domain/entities/results.dart';
import 'package:meiyou/domain/entities/main_page.dart';
import 'package:meiyou/domain/entities/episode.dart';
import 'package:meiyou/domain/entities/season.dart';

import 'cache_repository.dart';

abstract interface class MetaProviderRepository {
  Future<ResponseState<MetaResultsEntity>> fetchSearch(
    String query, {
    int page = 1,
    bool isAdult = false,
  });

  Future<ResponseState<MediaDetailsEntity>> fetchMediaDetails(
    MetaResponseEntity response,
  );

  Future<ResponseState<MainPageEntity>> fetchMainPage();

  Future<ResponseState<List<EpisodeEntity>>> fetchEpisodes(
    MediaDetailsEntity media, [
    SeasonEntity? season,
  ]);

  Future<List<EpisodeEntity>> getMappedEpisodes(List<EpisodeEntity> episodes,
      {SeasonEntity? season,
      required CacheRespository cacheRespository,
      required MediaDetailsEntity mediaDetails});

  MovieEntity getMappedMovie(MovieEntity movie,
      {required MediaDetailsEntity mediaDetails});
}
