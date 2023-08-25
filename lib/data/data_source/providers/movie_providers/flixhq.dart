import 'dart:convert';
import 'package:meiyou/core/resources/client.dart';
import 'package:meiyou/core/resources/extractors/video_extractor.dart';
import 'package:meiyou/core/resources/media_type.dart';
import 'package:meiyou/core/resources/providers/movie_provider.dart';
import 'package:meiyou/core/utils/encode.dart';
import 'package:meiyou/core/utils/extenstions/iterable.dart';
import 'package:meiyou/core/utils/extenstions/string.dart';
import 'package:meiyou/data/models/episode.dart';
import 'package:meiyou/data/models/movie.dart';
import 'package:meiyou/data/models/search_response.dart';
import 'package:meiyou/data/models/season.dart';
import 'package:meiyou/data/models/video_server.dart';
import 'package:ok_http_dart/ok_http_dart.dart';

class Flixhq extends MovieProvider {
  @override
  String get name => 'FlixHQ';

  @override
  String get hostUrl => 'https://flixhq.to';

  // static const _headers = {
  //   'User-Agent':
  //       'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:101.0) Gecko/20100101 Firefox/101.0',
  //   'X-Requested-With': 'XMLHttpRequest',
  //   'Connection': 'keep-alive',
  //   'Cookie': 'show_share=true'
  // };

  String _extractIdFromUrl(String url) {
    return url.substringAfterLast('-');
  }

  String _encodeWithReferer(String url, String referer) {
    return jsonEncode({'url': url, 'referer': referer});
  }

  @override
  Future<List<Episode>> loadEpisodes(String url) async {
    final decoded = jsonDecode(url);
    final id = decoded['url'] as String;
    final referer = decoded['referer'] as String;

    final res = await retryOnHandshakeException(
      '$hostUrl/ajax/v2/season/episodes/$id',
      headers: {"Referer": referer},
    );

    final episodes = res!.document.select('ul.nav > li > a').map((it) {
      return Episode(
        number: RegExp(r'\d+')
            .firstMatch(it.selectFirst('strong').text)!
            .group(0)!
            .toNum(),
        url: _encodeWithReferer(
            '$hostUrl/ajax/v2/episode/servers/${it.attr('data-id')}', referer),
      );
    }).toList();

    return episodes;
  }

  // @override
  // Future<Movie> loadMovie(String url) {
  //   return Future.value(Movie(
  //       url: _encodeWithReferer(
  //           '$hostUrl/ajax/movie/episodes/${_extractIdFromUrl(url)}', url)));
  // }

  @override
  Future<List<Season>> loadSeasons(String url) async {
    final res = await retryOnHandshakeException(
      '$hostUrl/ajax/v2/tv/seasons/${_extractIdFromUrl(url)}',
      headers: {"Referer": url},
      // followRedircts: true
    );
    // if (res == null) return null;
    final seasons =
        res!.document.select('.dropdown-menu.dropdown-menu-new > a').map((it) {
      return Season(
          number: it.text.substringAfter('Season ').toNum(),
          url: _encodeWithReferer(it.attr('data-id'), url));
    }).toList();

    return seasons;
  }

  // @override
  // VideoExtractor? loadVideoExtractor(VideoServer server) {
  //   final host = Uri.parse(server.serverUrl).host;

  //   if (host.contains('doki')) {
  //     return VidCloudExtractor(server);
  //   } else {
  //     return null;
  //   }
  // }

  // @override
  // Future<List<VideoServer>?> loadVideoServers(String url) async {
  //   final decoded = jsonDecode(url);
  //   final ajaxUrl = decoded['url'] as String;
  //   final referer = decoded['referer'] as String;
  //   final OkHttpResponse? res = await retryOnHandshakeException(ajaxUrl);

  //   if (res == null) return null;
  //   final futures = res.document.select('ul.nav > li > a').map((it) async {
  //     final id = RegExp(r'-(\d+)').firstMatch(it.attr("id"))?.group(1);
  //     final name = it.attr('title');

  //     final json = (await retryOnHandshakeException(
  //             '$hostUrl/ajax/get_link/$id',
  //             headers: {
  //           "Referer": referer,
  //           "X-Requested-With": "XMLHttpRequest",
  //         }))
  //         ?.json();
  //     return json != null
  //         ? VideoServer(name: name, serverUrl: json['link'])
  //         : null;
  //   });
  //   final servers = await Future.wait(futures);
  //   return servers.generateNonNullableList();
  // }

  @override
  Future<List<SearchResponse>> search(String query) async {
    final doc = await client.get('$hostUrl/search/${encode(query)}', headers: {
      "Referer": "$hostUrl/home",
    });

    return doc.document
        .select('.film_list-wrap > div > div.film-poster')
        .mapAsList((it) {
      final url = it.selectFirst('a').attr('href');
      return SearchResponse(
          title: it.selectFirst('a').attr('title'),
          cover: it.selectFirst('img').attr('data-src'),
          url: '$hostUrl$url',
          type: (url.contains('tv') ? MediaType.tvShow : MediaType.movie));
    });
  }

  static Future<OkHttpResponse?> retryOnHandshakeException(String url,
      {Map<String, String>? headers}) async {
    OkHttpResponse? res;
    final session = client.session();
    final stopwatch = Stopwatch()..start();
    for (var i = 0; i < 10; i++) {
      if (stopwatch.elapsedMilliseconds > 15000) break;
      try {
        res = await session.get(url, headers: headers);
        if (res.success) {
          break;
        } else {
          continue;
        }
      } catch (e) {
        continue;
      }
    }
    session.close();
    stopwatch.stop();

    return res;
  }

  @override
  Future<Movie> loadMovie(String url) {
    // TODO: implement loadMovie
    throw UnimplementedError();
  }

  @override
  VideoExtractor loadVideoExtractor(VideoServer videoServer) {
    // TODO: implement loadVideoExtractor
    throw UnimplementedError();
  }

  @override
  Future<List<VideoServer>> loadVideoServers(String url) {
    // TODO: implement loadVideoServer
    throw UnimplementedError();
  }
}


