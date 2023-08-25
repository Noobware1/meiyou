import 'package:meiyou/core/resources/client.dart';
import 'package:meiyou/core/resources/extractors/video_extractor.dart';
import 'package:meiyou/core/resources/media_type.dart';
import 'package:meiyou/core/resources/providers/anime_provider.dart';
import 'package:meiyou/core/utils/encode.dart';
import 'package:meiyou/core/utils/extenstions/iterable.dart';
import 'package:meiyou/core/utils/extenstions/string.dart';
import 'package:meiyou/core/utils/httpify.dart';
import 'package:meiyou/data/models/episode.dart';
import 'package:meiyou/data/models/search_response.dart';
import 'package:meiyou/data/models/video_server.dart';
import 'package:ok_http_dart/ok_http_dart.dart';

class Gogo extends AnimeProvider {
  @override
  String get name => 'Gogo';
  @override
  String get hostUrl => 'https://gogoanime.cl';

  @override
  Future<List<SearchResponse>> search(String query) async {
    final response =
        await client.get('$hostUrl/search.html?keyword=${encode(query)}');

    return response.document.select('.items > li').map((it) {
      final title = it.selectFirst('p.name > a').text;
      final element = it.selectFirst('div.img > a');
      final cover = element.selectFirst('img').attr('src');
      final url = element.attr('href');
      return SearchResponse(
          title: title, url: url, cover: cover, type: MediaType.anime);
    }).toList();
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
    final res = await client.get(url);
    final animePage = res.document;
    final ep_end =
        animePage.select('ul#episode_page > li > a').attr('ep_end').last;

    final id = animePage
        .selectFirst('.anime_info_episodes_next > #movie_id')
        .attr('value');
    final alias = animePage
        .selectFirst('.anime_info_episodes_next >.alias_anime')
        .attr('value');
    final ajaxRequest = await client.get(
        'https://ajax.gogo-load.com/ajax/load-list-episode?ep_start=0&ep_end=$ep_end&id=$id&alias=$alias');

    final episodeList = ajaxRequest.document;
    final episodes = episodeList
        .select('#episode_related > li > a')
        .mapAsList((it) {
          final num = it.selectFirst('div.name').text.replaceFirst('EP ', '');
          return Episode(
              number: num.toNum(), url: hostUrl + it.attr('href').trim());
        })
        .reversed
        .toList();

    return episodes;
  }

  @override
  VideoExtractor? loadVideoExtractor(VideoServer videoServer) {
    return null;
  }

  @override
  Future<List<VideoServer>> loadVideoServers(String url) async {
    final page = await client.get(url);
    final episodePage = page.document;
    return episodePage.select('.anime_muti_link > ul > li > a').mapAsList((it) {
      final name = it.text.replaceFirst('Choose this server', '').trim();
      final url = httpify(it.attr('data-video'));
      return VideoServer(url: url, name: name);
    });
  }
}


// @override
// VideoExtractor? loadVideoExtractor(VideoServer server) {
//   final serverUrl = server.serverUrl;
//   if (serverUrl.contains('sb')) {
//     return StreamSBExtractor(server);
//   } else if (serverUrl.contains('dood')) {
//     return DoodExtractor(server);
//   } else if (serverUrl.contains('streaming.php?') ||
//       serverUrl.contains('embedplus?')) {
//     return GogoExtractor(server);
//   } else {
//     return null;
//   }
// }


