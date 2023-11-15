import 'package:meiyou/core/resources/provider_type.dart';
import 'package:meiyou/core/resources/providers/base_provider.dart';
import 'package:meiyou/data/models/episode.dart';
import 'package:meiyou/data/models/main_page.dart';
import 'package:meiyou/data/models/media_details.dart';
import 'package:meiyou/data/models/results.dart';
import 'package:meiyou/data/models/season.dart';

abstract class MetaProvider extends BaseProvider {
  @override
  ProviderType get providerType => ProviderType.meta;

  Future<MetaResults> fetchSearch(String query,
      {int page = 1, bool isAdult = false});

  Future<MediaDetails> fetchMediaDetails(int id, String mediaType);

  Future<MainPage> fetchMainPage();

  Future<List<Episode>> fetchEpisodes(MediaDetails media, [
    Season? season,
  ]);
}
