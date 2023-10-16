import 'package:meiyou/core/resources/client.dart';
import 'package:meiyou/core/resources/extractors/video_extractor.dart';
import 'package:meiyou/core/resources/providers/anime_provider.dart';
import 'package:meiyou/core/try_catch.dart';
import 'package:meiyou/core/utils/encode.dart';
import 'package:meiyou/core/utils/extenstions/iterable.dart';
import 'package:meiyou/core/utils/extenstions/string.dart';
import 'package:meiyou/data/data_source/providers/anime_providers/extractors/rapid_cloud.dart';
import 'package:meiyou/data/models/episode.dart';
import 'package:meiyou/data/models/search_response.dart';
import 'package:meiyou/data/models/video_server.dart';
import 'package:ok_http_dart/ok_http_dart.dart';
import 'package:ok_http_dart/html_paser.dart' as html_parser;

class AniWatch extends AnimeProvider {
  @override
  String get name => 'AniWatch';

  @override
  String get hostUrl => 'https://aniwatch.to';

  late final _headers = {
    'X-Requested-With': 'XMLHttpRequest',
    'referer': hostUrl,
  };

  late final _embedHeaders = {"referer": '$hostUrl/'};

  @override
  Future<List<SearchResponse>> search(String query) async {
    return (await client.get('$hostUrl/search?keyword=${encode(query)}',
            headers: _headers))
        .document
        .select(".film_list-wrap > .flw-item > .film-poster")
        .mapAsList((e) {
      return SearchResponse.anime(
        title: e.selectFirst("a").attr("title"),
        cover: e.selectFirst("img").attr("data-src"),
        url: e.selectFirst("a").attr("data-id"),
      );
    });
  }

  @override
  Future<List<Episode>> loadEpisodes(String url) async {
    return (await client.get("$hostUrl/ajax/v2/episode/list/$url",
            headers: _headers))
        .json((json) => html_parser.parse(json['html']))
        .select("div.ss-list > a")
        .mapAsList((e) {
      final title = e.attr('title');
      final number = e.attr("data-number").toNum();
      final id = e.attr("data-id");
      final filler = e.attr("class").contains("ssl-item-filler");

      return Episode(number: number, title: title, url: id, isFiller: filler);
    });
  }

  @override
  VideoExtractor? loadVideoExtractor(VideoServer videoServer) {
    final url = videoServer.url;
    if (url.contains('megacloud') || url.contains('rapidcloud')) {
      return RapidCloud(videoServer);
    }
    return null;
  }

  @override
  Future<List<VideoServer>> loadVideoServers(String url) async {
    return (await (await client.get(
                '$hostUrl/ajax/v2/episode/servers?episodeId=$url',
                headers: _headers))
            .json((json) => html_parser.parse(json['html']))
            .select('div.item.server-item')
            .mapAsList((it) async {
      final url = (await client.get(
              '$hostUrl/ajax/v2/episode/sources?id=${it.attr('data-id')}',
              headers: _embedHeaders))
          .jsonSafe((json) => json["link"] as String);
      if (url == null) return null;
      return VideoServer(
        url: url,
        name: "${it.attr('data-type').toUpperCase()} - ${it.text}"
            .replaceAll(RegExp(r'\s+'), ' '),
      );
    }).tryWait)
        .nonNullsList;
  }
}
