import 'package:meiyou/data/models/extractor_link.dart';
import 'package:meiyou/data/models/homepage.dart';
import 'package:meiyou/data/models/media_details.dart';
import 'package:meiyou/data/models/search_response.dart';
import 'package:meiyou/domain/entities/media.dart';

abstract class BasePluginApi {
  BasePluginApi();

  Iterable<HomePageData> get homePage;

  Future<HomePage> loadHomePage(int page, HomePageRequest request);

  Future<List<SearchResponse>> search(String query);

  Future<MediaDetails> loadMediaDetails(SearchResponse searchResponse);

  Future<List<ExtractorLink>> loadLinks(String url);

  Future<MediaEntity?> loadMedia(ExtractorLink link);
}
