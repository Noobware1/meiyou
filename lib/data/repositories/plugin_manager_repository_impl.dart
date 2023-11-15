import 'package:meiyou/core/plugin/base_plugin_api.dart';
import 'package:meiyou/core/resources/response_state.dart';
import 'package:meiyou/core/utils/try_catch.dart';
import 'package:meiyou/data/models/homepage.dart';
import 'package:meiyou/data/models/media_details.dart';
import 'package:meiyou/data/models/search_response.dart';
import 'package:meiyou/domain/entities/homepage.dart';
import 'package:meiyou/domain/entities/search_response.dart';
import 'package:meiyou/domain/repositories/plugin_manager_repository.dart';

class PluginManagerRepositoryImpl implements PluginManagerRepository {
  final BasePluginApi api;

  PluginManagerRepositoryImpl({required this.api});

  HomePageData getMainPageData(HomePageEntity homePage) {
    return api.homePage.firstWhere((e) => e.name == homePage.data.name);
  }

  @override
  Future<ResponseState<List<HomePage>>> loadFullHomePage() {
    return ResponseState.tryWithAsync(() async {
      final list = <HomePage>[];
      for (var data in api.homePage) {
        final homePage = await tryAsync(() => api.loadHomePage(
            1,
            HomePageRequest(
                name: data.name,
                data: data.data,
                horizontalImages: data.horizontalImages)));
        if (homePage != null && homePage.data.data.isNotEmpty) {
          list.add(homePage);
        }
      }
      return list.isEmpty ? throw Exception('Could\'t Load HomePage!') : list;
    });
  }

  @override
  Future<ResponseState<List<SearchResponse>>> search(String query) {
    return ResponseState.tryWithAsync(() {
      return api.search(query);
    });
  }

  @override
  Future<ResponseState<MediaDetails>> loadMediaDetails(
      SearchResponseEntity searchResponse) {
    return ResponseState.tryWithAsync(() {
      return api.loadMediaDetails(SearchResponse.fromEntity(searchResponse));
    });
  }

  @override
  Future<ResponseState<HomePage>> loadHomePage(
      int page, HomePageDataEntity data) {
    return ResponseState.tryWithAsync(() => api.loadHomePage(
        page,
        HomePageRequest(
            name: data.name,
            data: data.data,
            horizontalImages: data.horizontalImages)));
  }
}
