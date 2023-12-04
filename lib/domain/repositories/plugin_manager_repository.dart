import 'package:meiyou/core/resources/response_state.dart';
import 'package:meiyou/domain/entities/extractor_link.dart';

import 'package:meiyou/domain/entities/homepage.dart';
import 'package:meiyou/domain/entities/media.dart';
import 'package:meiyou/domain/entities/media_details.dart';
import 'package:meiyou/domain/entities/search_response.dart';

abstract interface class PluginManagerRepository {
  Future<ResponseState<List<HomePageEntity>>> loadFullHomePage();

  Future<ResponseState<HomePageEntity>> loadHomePage(
      int page, HomePageDataEntity data);

  Future<ResponseState<List<SearchResponseEntity>>> search(String query);

  Future<ResponseState<MediaDetailsEntity>> loadMediaDetails(
      SearchResponseEntity searchResponse);

  Future<ResponseState<List<ExtractorLinkEntity>>> loadLinks(String url);

  Future<ResponseState<MediaEntity?>> loadMedia(ExtractorLinkEntity link);

  Stream<(ExtractorLinkEntity, MediaEntity)> loadLinkAndMediaStream(String url);
}
