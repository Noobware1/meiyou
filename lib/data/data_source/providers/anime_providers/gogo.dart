import 'package:meiyou/core/resources/client.dart';
import 'package:meiyou/core/resources/extractors/video_extractor.dart';
import 'package:meiyou/core/resources/media_type.dart';
import 'package:meiyou/core/resources/providers/anime_provider.dart';
import 'package:meiyou/core/utils/encode.dart';
import 'package:meiyou/core/utils/extenstions/iterable.dart';
import 'package:meiyou/core/utils/extenstions/string.dart';
import 'package:meiyou/core/utils/httpify.dart';
import 'package:meiyou/data/data_source/providers/anime_providers/extractors/gogo_cdn.dart';
import 'package:meiyou/data/models/episode.dart';
import 'package:meiyou/data/models/search_response.dart';
import 'package:meiyou/data/models/video_server.dart';
import 'package:ok_http_dart/ok_http_dart.dart';

class Gogo extends AnimeProvider {
  @override
  String get name => 'Gogo';
  @override
  String get hostUrl => 'https://gogoanime.hu';

  @override
  Future<List<SearchResponse>> search(String query) {
    return client
        .get('$hostUrl/search.html?keyword=${encode(query)}')
        .then((response) {
      return response.document.select('.items > li').mapAsList((it) {
        final title = it.selectFirst('p.name > a').text;
        final element = it.selectFirst('div.img > a');
        final cover = element.selectFirst('img').attr('src');
        final url = hostUrl + element.attr('href');
        return SearchResponse(
            title: title, url: url, cover: cover, type: MediaType.anime);
      });
    });
  }

  @override
  Future<List<Episode>> loadEpisodes(String url) async {
    final animePage = (await client.get(url)).document;

    final epEnd =
        animePage.select('ul#episode_page > li > a').attr('ep_end').last;

    final id = animePage
        .selectFirst('.anime_info_episodes_next > #movie_id')
        .attr('value');
    final alias = animePage
        .selectFirst('.anime_info_episodes_next >.alias_anime')
        .attr('value');
    return (await client.get(
            'https://ajax.gogo-load.com/ajax/load-list-episode?ep_start=0&ep_end=$epEnd&id=$id&alias=$alias'))
        .document
        .select('#episode_related > li > a')
        .mapAsList((it) {
          final num = it.selectFirst('div.name').text.replaceFirst('EP ', '');
          return Episode(
              number: num.toNum(), url: hostUrl + it.attr('href').trim());
        })
        .reversed
        .toList();
  }

  @override
  VideoExtractor? loadVideoExtractor(VideoServer videoServer) {
    final url = videoServer.url;
    if (url.contains('/streaming.php?') || url.contains('/embedplus?')) {
      return GogoCDN(videoServer);
    }
    return null;
  }

  @override
  Future<List<VideoServer>> loadVideoServers(String url) {
    return client.get(url).then((response) {
      return response.document
          .select('.anime_muti_link > ul > li > a')
          .mapAsList((it) {
        final name = it.text.replaceFirst('Choose this server', '').trim();
        final url = httpify(it.attr('data-video'));
        return VideoServer(url: url, name: name);
      });
    });
  }
}
