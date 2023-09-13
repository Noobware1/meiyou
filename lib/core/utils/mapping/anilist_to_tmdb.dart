import 'package:meiyou/core/resources/meta_provider.dart';
import 'package:meiyou/core/resources/providers/meta_provider.dart';
import 'package:meiyou/core/utils/mapping/functions.dart';
import 'package:meiyou/core/utils/snaitize_title.dart';
import 'package:meiyou/data/data_source/providers/meta_providers/anilist.dart';
import 'package:meiyou/data/data_source/providers/meta_providers/tmdb.dart';
import 'package:meiyou/data/models/media_details.dart';
import 'package:meiyou/data/models/meta_response.dart';

Future<MediaDetails> mapMedia(MediaDetails media, TMDB tmdb) async {
  final title =
      sanitizeTitle(media.title ?? media.romaji ?? media.native ?? '');
  final tmdbResponse = await tmdb.fetchSearch(title.toLowerCase());
  final results =
      filterResults(media.startDate, tmdbResponse, MediaProvider.tmdb);
  if (results == null) return media;
  final best = findBestMatchingTitle(results, title);
  if (best == null) return media;

  return media.copyWith(
      bannerImage: best.bannerImage,
      poster: best.poster,
      extrenalIds: {
        'tmdb': best.id.toString(),
        ...media.extrenalIds ?? const {}
      });
}

Future<MetaResponse> mapAnilistResponse(
    MetaResponse mainApiResponse, TMDB tmdb) async {
  final title = sanitizeTitle(mainApiResponse.title ??
      mainApiResponse.romanji ??
      mainApiResponse.native ??
      '');
  final tmdbResponse = await tmdb.fetchSearch(title.toLowerCase());
  final results =
      filterResults(mainApiResponse.airDate, tmdbResponse, MediaProvider.tmdb);
  if (results == null) return mainApiResponse;
  final best = findBestMatchingTitle(results, title);
  if (best == null) return mainApiResponse;
  return mainApiResponse.copyWith(
      bannerImage: best.bannerImage, poster: best.poster);
}

Future<MediaDetails?> mapTmdbToAnilist(
  MetaResponse mainApiResponse,
  Anilist anilist,
) async {
  // final media = (await anilist.fetchMediaDetails(
  //         mainApiResponse.id, mainApiResponse.mediaType!))
  //     ;
  final title = sanitizeTitle(mainApiResponse.title ??
      mainApiResponse.romanji ??
      mainApiResponse.native!);

  final anilistSearchResponse = await anilist.fetchSearch(title.toLowerCase());
  final results = filterResults(
      mainApiResponse.airDate, anilistSearchResponse, MediaProvider.anilist);
  if (results == null) return null;
  final best = findBestMatchingTitle(results, title);
  if (best == null) return null;
  // print(best.id);
  final anilistMedia = await anilist.fetchMediaDetails(best.id, '');
  // print(anilistMedia);
  return anilistMedia.copyWith(
      bannerImage: mainApiResponse.bannerImage,
      poster: mainApiResponse.poster,
      extrenalIds: {
        'tmdb': best.id.toString(),
        // ....extrenalIds ?? {}
      });
}
