import 'dart:convert';

import 'package:ok_http_dart/ok_http_dart.dart';
import 'package:streamify/helpers/data_classes.dart';
import 'package:streamify/helpers/m3u8_helper.dart';
import 'package:streamify/helpers/utils.dart';
import 'package:streamify/providers/extractors/vidmoly_extractor.dart';
import 'package:streamify/providers/movie_providers/base_movie_source_parser.dart';

class YoMovies extends MovieSource {
  @override
  String get name => 'YoMovies';

  @override
  String get hostUrl => 'https://yomovies.hair';

  @override
  Future<List<SearchResponse>?> search(String query) async {
    final res = await client.get('$hostUrl?s=${encode(query, '+')}');
    final search = res.document
        .select('.movies-list.movies-list.movies-list-full > div > a')
        .map((it) {
      final url = it.attr('href');
      return SearchResponse(
          title: it.selectFirst('span.mli-info > h2').text,
          cover: it.selectFirst('img').attr('src'),
          url: url,
          type: (url.contains('series')) ? MediaType.tvShow : MediaType.movie);
    }).toList();

    return search;
  }

  Future<LoadResponse?> load(
      {required SearchResponse data,
      List<Season>? seasons,
      Season? season}) async {
    //print(data.title);
    final LoadResponse? response;
    if (data.type == MediaType.movie) {
      final movie = await loadMovie(data.url);

      response = movie != null ? LoadResponse.fromMovie(movie: movie) : null;
    } else {
      final List<Episode>? episode;
      if (seasons == null) {
        final allSeasons = await loadSeasons(data.url);
        if (allSeasons == null || allSeasons.isEmpty) {
          episode = await loadEpisodes(data.url);
          response = (episode != null)
              ? LoadResponse.fromTvResponse(episodes: episode, seasons: seasons)
              : null;
        } else {
          episode = await loadEpisodes(
              allSeasons[season!.number.toInt() - 1].seasonUrl);
          response = (episode != null)
              ? LoadResponse.fromTvResponse(
                  episodes: episode, seasons: allSeasons)
              : null;
        }
      } else {
        episode =
            await loadEpisodes(seasons[season!.number.toInt() - 1].seasonUrl);
        response = (episode != null)
            ? LoadResponse.fromTvResponse(episodes: episode, seasons: seasons)
            : null;
      }
    }

    return response;
  }

  @override
  Future<List<Episode>?> loadEpisodes(String url) async {
    final data = json.decode(url);
    final episodes = List<dynamic>.from(data)
        .map(
            (ep) => Episode(number: ep['number'], url: ep['episodeUrl']))
        .toList();

    return episodes;
  }

  @override
  Future<Movie?> loadMovie(String url) async {
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
  Future<List<Season>?> loadSeasons(String url) async {
    final res = await client.get(url);
    final episodes =
        res.document.select('.tvseason > div.les-content > a').map((it) {
      return {
        'number': it.text.substringAfter('Episode '),
        'episodeUrl': it.attr('href')
      };
    }).toList();

    return [Season(number: '1', seasonUrl: json.encode(episodes))];
  }

  @override
  Future<List<VideoServer>?> loadVideoServers(String url) async {
    if (url.startsWith('//')) {
      return null;
    }
    const name = 'SpeedoStream';
    if (url.contains('speedo')) {
      return [VideoServer(name: name, serverUrl: url, referer: hostUrl)];
    } else {
      try {
        final serverUrl = await _extractIframe(url);
        return [VideoServer(name: 'S', serverUrl: serverUrl, referer: hostUrl)];
      } catch (e) {
        return null;
      }
    }
  }

  @override
  VideoExtractor? loadVideoExtractor(VideoServer server) {
    if (server.serverUrl.contains('speedo')) {
      return SpeedoStreamExtractor(
        server,
      );
    } else {
      return null;
    }
  }
}

class SpeedoStreamExtractor extends VideoExtractor {
  @override
  // TODO: implement name
  String get name => 'SpeedoStream';
  @override
  // TODO: implement hostUrl
  String get hostUrl => server.serverUrl.substringBeforeLast('/');

  @override
  // TODO: implement doesRequireReferer
  bool get doesRequireReferer => true;

  SpeedoStreamExtractor(super.server);

  @override
  Future<VideoFile?> extractor([String referer = '']) async {
    try {
      final serverUrl = server.serverUrl;
      final headers = {"Referer": '$hostUrl/'};

      final text =
          (await client.get(serverUrl, headers: {"Referer": server.referer!}))
              .text;

      final RegExp fileRegex = RegExp(r'sources:\s\[{file:"(.*)"}\]');

      final masterUrl = fileRegex.firstMatch(text)?.group(1);

      if (masterUrl == null) {
        return null;
      }

      final file = (await client.get(masterUrl, headers: headers)).text;
      return toM3u8Helper(name, masterUrl, headers: headers);
    } catch (e, stack) {
      print(stack);
      return null;
    }
  }
}
