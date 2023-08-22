import 'package:meiyou/core/resources/provider_type.dart';
import 'package:meiyou/core/resources/providers/watch_provider.dart';
import 'package:meiyou/data/models/episode.dart';
import 'package:meiyou/data/models/movie.dart';
import 'package:meiyou/data/models/search_response.dart';
import 'package:meiyou/data/models/season.dart';

abstract class MovieProvider extends WatchProvider {
  @override
  ProviderType get providerType => ProviderType.movie;

  Future<List<SearchResponse>> search(String query);

  Future<List<Episode>> loadEpisodes(String url);

  Future<Movie> loadMovie(String url);

  Future<List<Season>> loadSeasons(String url);
}
