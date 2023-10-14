import 'dart:convert';

import 'package:meiyou/core/resources/client.dart';
import 'package:meiyou/core/resources/extractors/video_extractor.dart';
import 'package:meiyou/core/resources/media_type.dart';
import 'package:meiyou/core/resources/providers/movie_provider.dart';
import 'package:meiyou/core/try_catch.dart';
import 'package:meiyou/core/utils/encode.dart';
import 'package:meiyou/core/utils/extenstions/iterable.dart';
import 'package:meiyou/core/utils/extenstions/string.dart';
import 'package:meiyou/data/models/episode.dart';
import 'package:meiyou/data/models/movie.dart';
import 'package:meiyou/data/models/search_response.dart';
import 'package:meiyou/data/models/season.dart';
import 'package:meiyou/data/models/video_server.dart';
import 'package:ok_http_dart/ok_http_dart.dart';

import 'extractors/speedo_stream.dart';

class YoMovies extends MovieProvider {
  @override
  String get name => 'YoMovies';

  @override
  String get hostUrl => 'https://yomovies.network';

  @override
  Future<List<SearchResponse>> search(String query) async {
    return (await client.get('$hostUrl?s=${encode(query, '+')}'))
        .document
        .select('.movies-list.movies-list.movies-list-full > div > a')
        .mapAsList((it) {
      final url = it.attr('href');
      return SearchResponse(
          title: it.selectFirst('span.mli-info > h2').text,
          cover:
              trySync(() => it.selectFirst('img').attr('data-original')) ?? '',
          url: url,
          type:
              (url.contains('/series/')) ? MediaType.tvShow : MediaType.movie);
    });
  }

  @override
  Future<List<Episode>> loadEpisodes(String url) async {
    return (json.decode(url) as List).mapAsList((it) => Episode.fromJson(it));
  }

  @override
  Future<Movie> loadMovie(String url) async {
    final movieUrl = await _extractIframe(url);
    return Movie(url: movieUrl);
  }

  Future<String> _extractIframe(String url) async {
    final res = await client.get(url);
    final iframe =
        res.document.selectFirst('#tab1 > div.movieplay > iframe').attr('src');
    return iframe;
  }

  @override
  Future<List<Season>> loadSeasons(String url) async {
    final episodes = (await client.get(url))
        .document
        .select('.tvseason > div.les-content > a')
        .mapAsList((it) {
      return Episode(
              number: it.text.substringAfter('Episode ').toNum(),
              url: it.attr('href'))
          .toJson();
    });

    return [Season(number: 1, url: json.encode(episodes))];
  }

  @override
  Future<List<VideoServer>> loadVideoServers(String url) async {
    final name =
        Uri.tryParse(url)?.host.substringBeforeLast('.').toUpperCaseFirst() ??
            'SpeedoStream';
    final VideoServer server;
    if (url.startsWith(hostUrl)) {
      server = VideoServer(url: (await _extractIframe(url)), name: name);
    } else {
      server = VideoServer(url: url, name: name);
    }
    return [server.copyWith(referer: '$hostUrl/')];
  }

  @override
  VideoExtractor loadVideoExtractor(VideoServer videoServer) {
    return SpeedoStreamExtractor(videoServer);
  }
}



