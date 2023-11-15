import 'package:meiyou/core/resources/provider_type.dart';
import 'package:meiyou/data/models/media_details.dart';
import 'package:meiyou/data/models/search_response.dart';
import 'package:meiyou/data/models/episode.dart';
import 'package:meiyou/data/models/season.dart';
import 'package:meiyou/data/models/movie.dart';
import 'package:meiyou/core/resources/providers/watch_provider.dart';

abstract class TMDBProvider extends WatchProvider {
  Future<List<SearchResponse>> search(MediaDetails media) {
    return Future.value([
      SearchResponse(
          title: media.title ?? media.romaji ?? media.native ?? 'No Title',
          url: media.id.toString(),
          cover: media.poster ?? '',
          type: media.mediaType)
    ]);
  }

  Future<Movie> loadMovie(String id);

  Future<List<Season>> loadSeasons(String id, List<Season> seasons);

  Future<List<Episode>> loadEpisodes(Season season);

  @override
  ProviderType get providerType => ProviderType.tmdb;
}
