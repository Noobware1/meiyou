import 'package:meiyou/core/resources/response_state.dart';
import 'package:meiyou_extenstions/models.dart';

abstract class PluginRepository {
  Future<ResponseState<List<HomePage>>> loadFullHomePage();

  Future<ResponseState<HomePage>> loadHomePage(int page, HomePageData data);

  Future<ResponseState<List<SearchResponse>>> search(String query);

  Future<ResponseState<MediaDetails>> loadMediaDetails(
      SearchResponse searchResponse);

  Future<ResponseState<List<ExtractorLink>>> loadLinks(String url);

  Future<ResponseState<Media?>> loadMedia(ExtractorLink link);

  Stream<(ExtractorLink, Media)> loadLinkAndMediaStream(String url);
}
