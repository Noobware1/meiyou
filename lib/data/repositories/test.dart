import 'package:meiyou/core/plugin/base_plugin_api.dart';
import 'package:meiyou/core/utils/unwrap.dart';
import 'package:meiyou/data/models/extractor_link.dart';
import 'package:meiyou/data/models/homepage.dart';
import 'package:meiyou/data/models/media_item/anime.dart';
import 'package:meiyou/data/models/media_item/movie.dart';
import 'package:meiyou/data/models/media_item/tv_series.dart';
import 'package:meiyou/data/models/plugin.dart';
import 'package:meiyou/data/models/search_response.dart';
import 'package:meiyou/data/repositories/plugin_repository_impl.dart';
import 'package:meiyou/domain/entities/media.dart';

class TestPlugin {
  final Plugin plugin;
  late final BasePluginApi api;
  TestPlugin(this.plugin) {
    try {
      api = PluginRepositoryImpl('').loadPlugin(plugin);
    } catch (e, s) {
      print('========== Failed To Load Plugin - ${plugin.name} ==========');
      print(e);
      print(s);
    }
  }

  Future<void> runFullTest(String query) async {
    await testLoadHomePage();
    print('============= END =============');
    final search = await testSearch(query);
    print('============= END =============');
    final url = await testMediaDetails(search);
    print('============= END =============');
    if (url == null) return;

    final link = await testLoadLinks(url);
    print('============= END =============');
    await testLoadMedia(link);
    print('============= END =============');
  }

  Future<void> testLoadHomePage() async {
    print('========== Starting LoadHomePage ==========');
    try {
      for (var i in api.homePage) {
        final homePage = await api.loadHomePage(
            1,
            HomePageRequest(
                name: i.name,
                data: i.data,
                horizontalImages: i.horizontalImages));
        print(unwrapValue<HomePage>(homePage));
        print(homePage.page);
        print(homePage.hasNextPage);
      }
    } catch (e, s) {
      print('========== Failed LoadHomePage ==========');
      rethrow;
    }
  }

  Future<SearchResponse> testSearch(String query) async {
    print('========== Starting Search With $query ==========');
    try {
      final search = await api.search(query);
      for (var i in search) {
        print(unwrapValue<SearchResponse>(i));
      }

      return search.first;
    } catch (e, s) {
      print('========== Failed Search with $query ==========');
      rethrow;
    }
  }

  Future<String?> testMediaDetails(SearchResponse searchResponse) async {
    searchResponse = unwrapValue<SearchResponse>(searchResponse);
    print(
        '========== Starting LoadMediaDetails With $searchResponse ==========');
    try {
      final details = await api.loadMediaDetails(searchResponse);
      print(unwrapValue(details));
      final mediaItem = details.mediaItem;
      if (mediaItem is Anime) {
        return mediaItem.episodes.first.data;
      } else if (mediaItem is Movie) {
        return mediaItem.url;
      } else if (mediaItem is TvSeries) {
        return mediaItem.data.first.episodes.first.data;
      } else {
        return null;
      }
    } catch (e, s) {
      print(
          '========== Failed LoadMediaDetails with $searchResponse ==========');
      rethrow;
    }
  }

  Future<ExtractorLink> testLoadLinks(String url) async {
    print('========== Starting LoadLinks With $url ==========');
    try {
      final links = await api.loadLinks(url);
      for (var i in links) {
        print(unwrapValue<ExtractorLink>(i));
      }

      return links.first;
    } catch (e, s) {
      print('========== Failed LoadLinks with $url ==========');
      rethrow;
    }
  }

  Future<MediaEntity?> testLoadMedia(ExtractorLink extractorLink) async {
    extractorLink = unwrapValue<ExtractorLink>(extractorLink);
    print('========== Starting LoadMedia With $extractorLink ==========');
    try {
      final value = await api.loadMedia(extractorLink);
      print(value);
      return value;
    } catch (e, s) {
      print('========== Failed LoadMedia with $extractorLink ==========');
      rethrow;
    }
  }
}
