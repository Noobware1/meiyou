import 'package:meiyou/core/constants/api_constants.dart';
import 'package:meiyou/core/resources/client.dart';
import 'package:meiyou/core/resources/media_type.dart';
import 'package:meiyou/core/resources/response_state.dart';
import 'package:meiyou/core/resources/providers/meta_provider.dart';
import 'package:meiyou/data/models/episode.dart';
import 'package:meiyou/data/models/main_page.dart';
import 'package:meiyou/data/models/media_details.dart';
import 'package:meiyou/data/models/results.dart';
import 'package:meiyou/data/models/row.dart';
import 'package:meiyou/data/models/season.dart';

class TMDB extends MetaProvider {
  @override
  String get name => 'TMDB';

  static const String _search =
      '$TMDB_API_URL/search/multi?api_key=$TMDB_APIKEY&language=en-US&query=';

  static const String _netflix =
      // "$TMDB_API_URL/discover/tv?api_key=$TMDB_APIKEY&with_networks=213&watch_region=IN";
      "$TMDB_API_URL/discover/tv?api_key=$TMDB_APIKEY&with_watch_providers=8&sort_bypopularity.desc&watch_region=IN";

  static const String _amazon =
      "$TMDB_API_URL/discover/tv?api_key=$TMDB_APIKEY&with_networks=1024";

  static const String _disney =
      "$TMDB_API_URL/discover/tv?api_key=$TMDB_APIKEY&with_networks=2739";

  static const String _hulu =
      "$TMDB_API_URL/discover/tv?api_key=$TMDB_APIKEY&with_networks=453";

  static const String _appleTv =
      "$TMDB_API_URL/discover/tv?api_key=$TMDB_APIKEY&with_networks=2552";

  static const String _hbo =
      "$TMDB_API_URL/discover/tv?api_key=$TMDB_APIKEY&with_networks=49";

  static const String _topRatedMovies =
      "$TMDB_API_URL/movie/top_rated?api_key=$TMDB_APIKEY&region=US";

  static const String _topRatedTvShows =
      "$TMDB_API_URL/tv/top_rated?api_key=$TMDB_APIKEY&region=US";

  static const String _upcomingMovies =
      "$TMDB_API_URL/movie/upcoming?api_key=$TMDB_APIKEY&region=US";

  static const String _trending =
      "$TMDB_API_URL/trending/all/day?api_key=$TMDB_APIKEY&region=US";

  static const String _popularMovies =
      "$TMDB_API_URL/movie/popular?api_key=$TMDB_APIKEY&region=US";

  static const String _popularTvShows =
      "$TMDB_API_URL/tv/popular?api_key=$TMDB_APIKEY&region=US";

  static const String _airingToday =
      "$TMDB_API_URL/tv/airing_today?api_key=$TMDB_APIKEY&region=US";

  static const String _movieGenres =
      "$TMDB_API_URL/genre/movie/list?api_key=$TMDB_APIKEY&language=en-US";

  static const String _tvGenres =
      "$TMDB_API_URL/genre/tv/list?api_key=$TMDB_APIKEY&language=en-US";

  @override
  Future<MediaDetails> fetchMediaDetails(int id, String mediaType) async {
    final response = await client.get(
        '$TMDB_API_URL/$mediaType/$id?api_key=$TMDB_APIKEY&append_to_response=credits,external_ids,videos,recommendations');
    if (!response.success) ResponseFailed.fromTMDB();

    return response.json((json) => MediaDetails.fromTMDB(json, mediaType));
  }

  @override
  Future<MetaResults> fetchSearch(String query,
      {int page = 1, bool isAdult = false}) {
    return client.get('$_search$query&page=$page&include_adult=$isAdult').then(
        (response) => response.json((json) => MetaResults.fromTMDB(json, '')));
  }

  @override
  Future<List<Episode>> fetchEpisodes(
    MediaDetails media, [
    Season? season,
  ]) async {
    return (await client.get(
            "$TMDB_API_URL/tv/${media.id}/season/${season?.number ?? 1}?api_key=$TMDB_APIKEY&language=en-US"))
        .json((json) {
      final episodes = <Episode>[];
      for (final episode in (json['episodes'] as List)) {
        episodes.add(Episode.fromTMDB(episode));
      }
      return episodes;
    });
  }

  @override
  Future<MainPage> fetchMainPage() async {
    final map = {
      'Trending': _fetchTrending,
      'Trending On Netflix': _fetchNetflixShows,
      'Trending On Amazon': _fetchAmazonShows,
      'Top Rated': _fetchTopRated,
    };

    final results = await Future.wait(map.values.map((e) => e.call()));

    final rows = <MetaRow>[];
    for (var i = 0; i < results.length; i++) {
      rows.add(MetaRow(
          rowTitle: map.keys.elementAt(i),
          resultsEntity: results[i],
          loadMoreData: map.values.elementAt(i)));
    }

    return MainPage(rows);
  }

  Future<MetaResults> _fetchTopRatedTvShows([int page = 1]) async =>
      (await client.get('$_topRatedTvShows&page=$page'))
          .json((json) => MetaResults.fromTMDB(json, MediaType.tvShow));

  Future<MetaResults> _fetchAmazonShows([int page = 1]) async =>
      (await client.get('$_amazon&page=$page'))
          .json((json) => MetaResults.fromTMDB(json, MediaType.tvShow));

  Future<MetaResults> _fetchPopularMovies([int page = 1]) async =>
      (await client.get('$_popularMovies&page=$page'))
          .json((json) => MetaResults.fromTMDB(json, MediaType.movie));

  Future<MetaResults> _fetchTopRated([int page = 1]) async =>
      (await client.get('$_topRatedMovies&page=$page'))
          .json((json) => MetaResults.fromTMDB(json, MediaType.movie));

  Future<MetaResults> _fetchPopularTvShows([int page = 1]) async =>
      (await client.get('$_popularTvShows&page=$page'))
          .json((json) => MetaResults.fromTMDB(json, MediaType.tvShow));

  Future<MetaResults> _fetchNetflixShows([int page = 1]) async =>
      (await client.get('$_netflix&page=$page'))
          .json((json) => MetaResults.fromTMDB(json, MediaType.tvShow));

  Future<MetaResults> _fetchTrending([int page = 1]) async =>
      (await client.get('$_trending&page=$page'))
          .json((json) => MetaResults.fromTMDB(json, null));
}
