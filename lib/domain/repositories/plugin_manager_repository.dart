import 'package:meiyou/core/resources/response_state.dart';

import 'package:meiyou/data/models/media_details.dart';
import 'package:meiyou/domain/entities/homepage.dart';
import 'package:meiyou/domain/entities/search_response.dart';

abstract interface class PluginManagerRepository {
  Future<ResponseState<List<HomePageEntity>>> loadFullHomePage();

  Future<ResponseState<HomePageEntity>> loadHomePage(
      int page, HomePageDataEntity data);

  Future<ResponseState<List<SearchResponseEntity>>> search(String query);

  Future<ResponseState<MediaDetails>> loadMediaDetails(
      SearchResponseEntity searchResponse);
}
