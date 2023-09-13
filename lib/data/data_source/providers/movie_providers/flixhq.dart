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

class Flixhq extends MovieProvider {
  @override
  String get name => 'FlixHQ';

  //have to add corsproxy to avoid annoying handshake error
  @override
  String get hostUrl => 'https://corsproxy.io/?https://flixhq.to';

  String _extractIdFromUrl(String url) {
    return url.substringAfterLast('-');
  }

  @override
  Future<List<Episode>> loadEpisodes(String url) {
    return client.get('$hostUrl/ajax/season/episodes/$url').then((response) =>
        response.document.select('ul.nav > li > a').mapAsList((it) => Episode(
              number: RegExp(r'\d+')
                  .firstMatch(it.selectFirst('strong').text)!
                  .group(0)!
                  .toNum(),
              url: '$hostUrl/ajax/episode/servers/${it.attr('data-id')}',
            )));
  }

  @override
  Future<List<Season>> loadSeasons(String url) {
    return client.get('$hostUrl/ajax/season/list/${_extractIdFromUrl(url)}',
        headers: {
          "Referer": url
        }).then((res) => res.document
        .select('.dropdown-menu.dropdown-menu-new > a')
        .mapAsList((it) => Season(
            number: it.text.substringAfter('Season ').toNum(),
            url: it.attr('data-id'))));
  }

  @override
  Future<List<VideoServer>> loadVideoServers(String url) {
    return client.get(url).then((res) async {
      final servers = <VideoServer?>[];
      final idRegex = RegExp(r'-(\d+)');

      for (var it in res.document.select('ul.nav > li > a')) {
        servers.add((await client.get(
                '$hostUrl/ajax/get_link/${idRegex.firstMatch(it.attr("id"))?.group(1)}',
                headers: {
              "X-Requested-With": "XMLHttpRequest",
            }))
            .jsonSafe((json) => VideoServer(
                url: json['link'] as String, name: it.attr('title'))));
      }

      return servers.nonNulls.toList();
    });
  }

  String _encode(String query) => encode(query, '-');

  @override
  Future<List<SearchResponse>> search(String query) {
    return client.get('$hostUrl/search/${_encode(query)}', headers: {
      "Referer": "$hostUrl/home",
    }).then((res) => res.document
            .select('.film_list-wrap > div > div.film-poster')
            .mapAsList((it) {
          final url = it.selectFirst('a').attr('href');
          return SearchResponse(
              title: it.selectFirst('a').attr('title'),
              cover: it.selectFirst('img').attr('data-src'),
              url: '$hostUrl$url',
              type: (url.contains('tv') ? MediaType.tvShow : MediaType.movie));
        }));
  }

  @override
  Future<Movie> loadMovie(String url) {
    return Future.value(
        Movie(url: '$hostUrl/ajax/episode/list/${_extractIdFromUrl(url)}'));
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
