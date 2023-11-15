import 'package:meiyou/core/resources/client.dart';
import 'package:meiyou/core/resources/extractors/video_extractor.dart';
import 'package:meiyou/core/resources/media_type.dart';
import 'package:meiyou/core/resources/providers/movie_provider.dart';
import 'package:meiyou/core/utils/encode.dart';
import 'package:meiyou/core/utils/extenstions/iterable.dart';
import 'package:meiyou/core/utils/extenstions/string.dart';
import 'package:meiyou/data/data_source/providers/movie_providers/extractors/vidcloud.dart';
import 'package:meiyou/data/models/episode.dart';
import 'package:meiyou/data/models/movie.dart';
import 'package:meiyou/data/models/search_response.dart';
import 'package:meiyou/data/models/season.dart';
import 'package:meiyou/data/models/video_server.dart';
import 'package:ok_http_dart/ok_http_dart.dart';

class Sflix extends MovieProvider {
  @override
  String get name => 'Sflix';

  @override
  String get hostUrl => 'https://sflix.to';

  @override
  Future<List<Episode>> loadEpisodes(String url) async {
    return client.get('$hostUrl/ajax/season/episodes/$url').then((response) {
      return response.document
          .select('div.swiper-container > div > div > div')
          .mapAsList((it) {
        final details = it.selectFirst('div.film-detail');
        final img = it.selectFirst('a > img').attr('src');
        return Episode(
          number: RegExp(r'\d+')
              .firstMatch(details.selectFirst('div.episode-number').text)!
              .group(0)!
              .toNum(),
          url: '$hostUrl/ajax/episode/servers/${it.attr('data-id')}',
          title: details.selectFirst('h3.film-name').text.trimNewLines(),
          thumbnail: img.startsWith('http') ? img : '',
        );
      })
        ..removeWhere((it) => it.number == 0);
    });
  }

  @override
  Future<Movie> loadMovie(String url) async {
    return Movie(url: '$hostUrl/ajax/episode/list/$url');
  }

  @override
  Future<List<Season>> loadSeasons(String url) {
    return client.get('$hostUrl/ajax/season/list/$url').then((res) {
      return res.document
          .select('div.dropdown-menu.dropdown-menu-model > a')
          .mapAsList((it) {
        return Season(
            number: it.text.substringAfter('Season ').toNum(),
            url: it.attr('data-id'));
      });
    });
  }

  @override
  Future<List<VideoServer>> loadVideoServers(String url) async {
    return client.get(url).then((res) async {
      final servers = <VideoServer?>[];

      for (var it in res.document.select('ul.ulclear.fss-list > li > a')) {
        servers.add((await client.get(
                '$hostUrl/ajax/sources/${it.attr("data-id")}',
                headers: {"X-Requested-With": "XMLHttpRequest"}))
            .jsonSafe((json) => VideoServer(
                url: json['link'] as String,
                name: it.text.replaceFirst('Server', '').trimNewLines())));
      }

      return servers.nonNulls.toList();
    });
  }

  String _encode(
    String query,
  ) =>
      encode(query, '-');

  @override
  Future<List<SearchResponse>> search(String query) {
    return client
        .get('$hostUrl/search/${_encode(query)}', referer: '$hostUrl/')
        .then((res) {
      return res.document
          .select('div.flw-item > div.film-poster')
          .mapAsList((it) {
        final a = it.selectFirst('a');
        final url = a.attr('href');
        return SearchResponse(
            title: a.attr('title'),
            cover: it.selectFirst('img').attr('data-src'),
            url: url.substringAfterLast('-'),
            type: (url.contains('movie') ? MediaType.movie : MediaType.tvShow));
      });
    });
  }

  @override
  VideoExtractor? loadVideoExtractor(VideoServer videoServer) {
    final url = videoServer.url;

    if (url.contains('doki') || url.contains('rabbit')) {
      return VidCloud(videoServer);
    }
    return null;
  }
}

void main(List<String> args) async {
  // print("""Server
  //               UpCloud"""
  //     .trimNewLines());
  final a = Sflix();
  (await a.loadVideoServers('https://sflix.to/ajax/episode/servers/1376287'))
      .forEach(print);
}
