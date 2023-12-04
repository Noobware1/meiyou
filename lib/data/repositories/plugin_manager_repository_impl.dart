import 'package:meiyou/core/plugin/base_plugin_api.dart';
import 'package:meiyou/core/resources/response_state.dart';
import 'package:meiyou/core/utils/try_catch.dart';
import 'package:meiyou/data/models/extractor_link.dart';
import 'package:meiyou/data/models/homepage.dart';
import 'package:meiyou/data/models/media_details.dart';
import 'package:meiyou/data/models/search_response.dart';
import 'package:meiyou/domain/entities/extractor_link.dart';
import 'package:meiyou/domain/entities/homepage.dart';
import 'package:meiyou/domain/entities/media.dart';
import 'package:meiyou/domain/entities/search_response.dart';
import 'package:meiyou/domain/repositories/plugin_manager_repository.dart';
import 'package:meiyou/presentation/providers/lol.dart';

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
  Future<ResponseState<List<ExtractorLink>>> loadLinks(String url) {
    return ResponseState.tryWithAsync(() => api.loadLinks(url));
  }

  @override
  Future<ResponseState<MediaEntity?>> loadMedia(ExtractorLinkEntity link) {
    return ResponseState.tryWithAsync(
        () => api.loadMedia(ExtractorLink.fromEntity(link)));
  }

  @override
  Stream<(ExtractorLink, MediaEntity)> loadLinkAndMediaStream(
      String url) async* {
    for (var i in videos) {
      yield ((ExtractorLink.fromEntity(i.link), i.video));
    }

    // final responseLinks = await loadLinks(url);

    // if (responseLinks is ResponseFailed) {
    //   throw responseLinks.error!;
    // }
    // for (var e in responseLinks.data!) {
    //   final media = await ResponseState.tryWithAsync(() => api.loadMedia(e));
    //   if (media is ResponseFailed) {
    //     yield* Stream.error(media.error!);
    //   } else if (media is ResponseSuccess && media.data != null) {
    //     yield (e, media.data!);
    //   }
    // }
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
