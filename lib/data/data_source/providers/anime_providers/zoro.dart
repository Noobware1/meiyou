import 'package:meiyou/core/resources/client.dart';
import 'package:meiyou/core/resources/extractors/video_extractor.dart';
import 'package:meiyou/core/resources/media_type.dart';
import 'package:meiyou/core/resources/providers/anime_provider.dart';
import 'package:meiyou/core/utils/extenstion.dart';
import 'package:meiyou/data/models/episode.dart';
import 'package:meiyou/data/models/search_response.dart';
import 'package:meiyou/data/models/video_server.dart';
import 'package:ok_http_dart/ok_http_dart.dart';
import 'package:ok_http_dart/html_paser.dart' as html_parser;

class Zoro extends AnimeProvider {
  @override
  String get name => 'Zoro';

  @override
  String get hostUrl => 'https://zoro.to';

  @override
  Future<List<SearchResponse>> search(String query) async {
    final document =
        (await client.get('/search?keyword=${encode(query)}"')).document;

    final response =
        document.select(".film_list-wrap > .flw-item > .film-poster").map((e) {
      final link = e.selectFirst("a").attr("data-id");
      final title = e.selectFirst("a").attr("title");
      final cover = e.selectFirst("img").attr("data-src");
      return SearchResponse(
          title: title, cover: cover, url: link, type: MediaType.anime);
    });

    return response.toList();
  }

  // @override
  // Future<LoadResponse?> load(
  //     {required SearchResponse data,
  //     List<Season>? seasons,
  //     Season? season}) async {
  //   List<Episode>? episodes = await loadEpisodes(data.url);

  //   return (episodes != null)
  //       ? LoadResponse.fromTvResponse(episodes: episodes)
  //       : null;
  // }

  @override
  Future<List<Episode>> loadEpisodes(String url) async {
    final res = (await client.get(
      "/ajax/v2/episode/list/$url",
    ))
        .json();
    final element = html_parser.parse(res['html']);

    final episodes = element.select(".detail-infor-content > div > a").map((e) {
      final title = e.attr("title");
      final number = e.attr("data-number").replaceFirst("\n", "").toNum();
      final id = e.attr("data-id");
      final filler = e.attr("class").contains("ssl-item-filler");

      return Episode(number: number, title: title, url: id, isFiller: filler);
    });
    return episodes.toList();
  }

  @override
  VideoExtractor loadVideoExtractor(VideoServer videoServer) {
    // TODO: implement loadVideoExtractor
    throw UnimplementedError();
  }

  @override
  Future<List<VideoServer>> loadVideoServer(String url) {
    // TODO: implement loadVideoServer
    throw UnimplementedError();
  }

  // @override
  // VideoExtractor? loadVideoExtractor(VideoServer server) {
  //   final domain = Uri.parse(server.serverUrl).host;
  //   if (domain.contains('rapid')) {
  //     return RapidCloudExtractor(server);
  //   } else if (domain.contains('sb')) {
  //     return StreamSBExtractor(server);
  //   } else {
  //     return null;
  //   }
  // }

  // @override
  // Future<List<VideoServer>?> loadVideoServers(String url) async {
  //   try {
  //     final res = (await _tryWithBothUrl(
  //             "/ajax/v2/episode/servers?episodeId=$url", true))
  //         .json();
  //     final Iterable<Future<VideoServer>> futures;
  //     final element = html.parse(res['html']);
  //     final list = element.select("div.server-item");
  //     if (list.first.attr('data-id').isEmpty) {
  //       final list2 =
  //           element.select('div.item.server-item').map((e) => _getServers(e));
  //       futures = list2;
  //     } else {
  //       futures = list.map((e) => _getServers(e));
  //     }
  //     // final idRegex = RegExp(r'data-id="(\d+)"').allMatches(res).map((e) async => );
  //     // final typeRegex = RegExp(r'data-type="(\w{3})"');
  //     // final nameRgexg = RegExp(r'>(\w+)<\/\w+>');

  //     final servers = await Future.wait(futures);
  //     return servers;
  //   } catch (_) {
  //     return null;
  //   }
  // }

  // Future<VideoServer> _getServers(Element e) async {
  //   final serverName =
  //       "${e.attr("data-type").toUpperCase()} - ${e.text.trim()}";
  //   final link = (await _tryWithBothUrl(
  //           "/ajax/v2/episode/sources?id=${e.attr("data-id")}", true))
  //       .json();

  //   return VideoServer(name: serverName, serverUrl: link['link']);
  //   // final ConsumetHandler _zoroHandler = ConsumetHandler();
  // }
}
