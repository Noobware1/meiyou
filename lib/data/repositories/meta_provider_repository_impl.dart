import 'package:meiyou/core/resources/expections.dart';
import 'package:meiyou/core/resources/meta_provider.dart';
import 'package:meiyou/core/resources/response_state.dart';
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
import 'package:meiyou/domain/entities/season.dart';
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

      // final List<Episode> episodes = [];
      return _tmdb.fetchEpisodes(
          mediaDetails, season != null ? Season.fromEntity(season) : null);
      // await asyncForLoop(
      //     end: media.seasons!.length,
      //     fun: (index) =>
      //         _tmdb.fetchEpisodes(mediaDetails, mediaDetails.seasons?[index]),
      //     cancelOnError: true,
      //     onData: (data) => episodes.addAll(data),
      //     onError: (error, stackTrace) =>
      //         throw MeiyouException(error.toString(), stackTrace: stackTrace),
      //     onDone: () => episodes);

      // retusrn completer.future.timeout(const Duration(minutes: 30));
    });
  }

  //  Stream<List<Episode>> _episodeStream(MediaDetails media) async* {
  //     assert(media.seasons != null);
  //     for (var i = 0; i < media.seasons!.length; i++) {
  //       final season = media.seasons![i];
  //       final episodes = await _tmdb.fetchEpisodes(media, season as Season);
  //       if (episodes is ResponseSuccess) {
  //         yield episodes;
  //       } else {
  //         defaultEpisodeGeneration(media, season.totalEpisode ?? 1);
  //       }
  //     }
  //   }

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
    });
  }

  @override
  Future<ResponseState<MediaDetails>> fetchMediaDetails(
      MetaResponseEntity response) {
    return tryWithAsync(() async {
      final metaResponse = MetaResponse.fromEntity(response);

      final MediaDetails mediaDetails;
      if (metaResponse.mediaProvider == MediaProvider.tmdb &&
          metaResponse.isAnime()) {
        final map = await mapTmdbToAnilist(metaResponse, _anilist);

        mediaDetails = map ??
            await _tmdb.fetchMediaDetails(
                metaResponse.id, metaResponse.mediaType!);
      } else if (metaResponse.mediaProvider == MediaProvider.anilist) {
        mediaDetails = await _anilist.fetchMediaDetails(
            metaResponse.id, metaResponse.mediaType!);
      } else {
        mediaDetails = await _tmdb.fetchMediaDetails(
            metaResponse.id, metaResponse.mediaType!);
      }
      return mediaDetails;
    });
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
    });
  }
}
