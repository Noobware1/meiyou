import 'dart:convert';
import 'package:meiyou/core/resources/enime.dart';
import 'package:meiyou/core/resources/mal.dart';
import 'package:meiyou/core/resources/media_type.dart';
import 'package:meiyou/core/resources/meta_provider.dart';
import 'package:meiyou/core/resources/queries.dart';
import 'package:meiyou/core/resources/providers/meta_provider.dart';
import 'package:meiyou/core/utils/extenstions/string.dart';
import 'package:meiyou/core/utils/mapping/map_episodes.dart';
import 'package:meiyou/data/data_source/providers/meta_providers/tmdb.dart';
import 'package:meiyou/data/models/episode.dart';
import 'package:meiyou/data/models/main_page.dart';
import 'package:meiyou/data/models/media_details.dart';
import 'package:meiyou/data/models/results.dart';
import 'package:meiyou/core/resources/client.dart';
import 'package:meiyou/core/constants/api_constants.dart';
import 'package:meiyou/data/models/row.dart';
import 'package:meiyou/data/models/season.dart';

class Anilist extends MetaProvider {
  @override
  String get name => 'Anilist';

  @override
  Future<MediaDetails> fetchMediaDetails(int id, String mediaType) =>
      _makeRequest(generateMediaQuery(id), MediaDetails.fromAnilist);

  @override
  Future<MetaResults> fetchSearch(String query,
          {int page = 1, bool isAdult = false}) =>
      _makeRequest(generateSearchQuery(query), MetaResults.fromAnilist);

  Future<MetaResults> _fetchPopular([int page = 1]) =>
      _makeRequest(generatePopularQuery(), MetaResults.fromAnilist);

  Future<MetaResults> _fetchRecentlyAdded([int page = 1]) {
    return _makeRequest(generateRecentlyAdded(page: page),
        MetaResults.fromAnilistRecentlyUpdated);
  }

  Future<MetaResults> fetchTrending([int page = 1]) =>
      _makeRequest(generateTrendingQuery(page), MetaResults.fromAnilist);

  Future<T> _makeRequest<T>(
      String query, T Function(dynamic json) fromJson) async {
    final res = await client.post(ANILIST_API_URL,
        body: json.encode(
          <String, String>{'query': query},
        ),
        headers: ANILIST_REQUEST_HEADERS);

    // if (!res.success) ResponseFailed.fromAnilist();
    final queryParsed = res.json(fromJson);
    return queryParsed;
  }

  @override
  Future<MainPage> fetchMainPage() async {
    final rowFunctions = [
      _fetchRecentlyAdded,
      fetchTrending,
      _fetchPopular,
    ];

    final results = await Future.wait(rowFunctions.map((it) => it.call()));

    final rows = <MetaRow>[];
    for (var i = 0; i < results.length; i++) {
      rows.add(MetaRow(
          rowTitle: rowTitles[i],
          resultsEntity: results[i],
          loadMoreData: rowFunctions[i]));
    }

    return MainPage(rows);
    // results.map((it) => MetaRow(rowTitle: ro, resultsEntity: resultsEntity))
  }

  @override
  Future<List<Episode>> fetchEpisodes(
    MediaDetails media, [
    Season? season,
  ]) async {
    final tmdbId = media.extrenalIds?['tmdb'];

    if (media.mediaProvider != MediaProvider.tmdb &&
            tmdbId != null &&
            media.mediaType != MediaType.movie.toUpperCase()
        // (!media.isLongFinished || !media.isLongOnGoing)
        ) {
      return mapEpisodes(media, tmdbId.toInt(), TMDB());
    } else {
      final enimeResponse = await Enime().fetchEpisodeByAnilistId(media.id);
      return enimeResponse ??
          await MyAnimeList().fetchEpisode(media) ??
          defaultEpisodeGeneration(
              media, media.totalEpisode ?? media.currentNumberEpisode!);
    }
  }

  static const rowTitles = <String>[
    'Recently Added',
    'Trending Anime',
    'Popular Anime'
  ];
}
