import 'package:meiyou/core/resources/response_state.dart';
import 'package:meiyou/core/utils/try_catch.dart';
import 'package:meiyou/domain/repositories/plugin_repository.dart';
import 'package:meiyou_extenstions/models.dart';

class PluginRepositoryImpl implements PluginRepository {
  final BasePluginApi api;

  PluginRepositoryImpl({required this.api});

  HomePageData getMainPageData(HomePage homePage) {
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
      SearchResponse searchResponse) {
    return ResponseState.tryWithAsync(() {
      return api.loadMediaDetails(searchResponse);
    });
  }

  @override
  Future<ResponseState<List<ExtractorLink>>> loadLinks(String url) {
    return ResponseState.tryWithAsync(() => api.loadLinks(url));
  }

  @override
  Future<ResponseState<Media?>> loadMedia(ExtractorLink link) {
    return ResponseState.tryWithAsync(() => api.loadMedia(link));
  }

  @override
  Stream<(ExtractorLink, Media)> loadLinkAndMediaStream(String url) async* {
  
    final responseLinks = await loadLinks(url);

    if (responseLinks is ResponseFailed) {
      throw responseLinks.error!;
    }
    for (var e in responseLinks.data!) {
      final media = await ResponseState.tryWithAsync(() => api.loadMedia(e));
      if (media is ResponseFailed) {
        yield* Stream.error(media.error!);
      } else if (media is ResponseSuccess && media.data != null) {
        yield (e, media.data!);
      }
    }
  }

  @override
  Future<ResponseState<HomePage>> loadHomePage(int page, HomePageData data) {
    return ResponseState.tryWithAsync(() => api.loadHomePage(
        page,
        HomePageRequest(
            name: data.name,
            data: data.data,
            horizontalImages: data.horizontalImages)));
  }
}
