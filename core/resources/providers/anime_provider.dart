import 'package:meiyou/core/resources/provider_type.dart';
import 'package:meiyou/core/resources/providers/watch_provider.dart';
import 'package:meiyou/data/models/episode.dart';
import 'package:meiyou/data/models/search_response.dart';

abstract class AnimeProvider extends WatchProvider {
  @override
  ProviderType get providerType => ProviderType.anime;

  Future<List<SearchResponse>> search(String query);

  Future<List<Episode>> loadEpisodes(String url);
}
