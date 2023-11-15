import 'dart:async';
import 'dart:convert';

import 'package:meiyou/core/resources/client.dart';
import 'package:meiyou/core/resources/extractors/video_extractor.dart';
import 'package:meiyou/core/resources/media_type.dart';
import 'package:meiyou/core/resources/providers/movie_provider.dart';
import 'package:meiyou/core/utils/encode.dart';
import 'package:meiyou/core/utils/extenstions/iterable.dart';
import 'package:meiyou/core/utils/extenstions/string.dart';
import 'package:meiyou/data/data_source/providers/movie_providers/extractors/movies_club.dart';
import 'package:meiyou/data/models/episode.dart';
import 'package:meiyou/data/models/movie.dart';
import 'package:meiyou/data/models/search_response.dart';
import 'package:meiyou/data/models/season.dart';
import 'package:meiyou/data/models/video_server.dart';
import 'package:ok_http_dart/ok_http_dart.dart';

class PressPlay extends MovieProvider {
  @override
  String get name => 'PressPlay';

  @override
  String get hostUrl => 'https://pressplay.top';

  @override
  Future<List<Episode>> loadEpisodes(String url) {
    return Future.value(List.from(jsonDecode(url)['episodes'])
        .mapAsList(_PressPlayEpisodeResponse.fromJson));
  }

  @override
  Future<Movie> loadMovie(String url) async {
    final iframe = await _extractIframe(url);

    Future<String> getIframe(String url) async {
      //why pressplay why
      return (await _extractIframe(url));
    }

    final a = (await client.get(await getIframe(iframe)));
    return a.json((json) {
      final obj = (json['simple-api'] as List)[0];
      return Movie(
          url: _PressPlayVideoServerResponse(
                  url: obj['iframe'] as String,
                  name: obj['name'] as String,
                  referer: iframe)
              .encode());
    });
  }

  @override
  Future<List<Season>> loadSeasons(String url) async {
    final iframe = await _extractIframe(url);
    final seasons = (await client.get(await _extractIframe(iframe))).json(
        (json) => (json['simple-api'] as List)
            .mapAsList(_PressPlaySeasonResponse.fromJson));

    final trueSeasonsNumber = {seasons.first.number};

    for (var i = 1; i < seasons.length; i++) {
      final value = seasons[i].number;
      trueSeasonsNumber.add(value);
    }

    final trueSeasons = <Season>[];

    for (var number in trueSeasonsNumber) {
      trueSeasons.add(Season(
          number: number,
          url: jsonEncode({
            'episodes': seasons.where((it) => it.number == number).mapAsList(
                (it) => {
                      'number': it.id,
                      'url': it.url,
                      'server': it.title!,
                      'referer': iframe
                    })
          })));
    }

    return trueSeasons..sort((a, b) => a.number.compareTo(b.number));
  }

  @override
  VideoExtractor loadVideoExtractor(VideoServer videoServer) {
    return MoviesClub(videoServer);
  }

  @override
  Future<List<VideoServer>> loadVideoServers(String url) async {
    final decoded = _PressPlayVideoServerResponse.decode(url);
    final serverUrl = (await client.get(decoded.url, referer: decoded.referer));

    final b = serverUrl.document.selectFirst('iframe.vidframe').attr('src');
    final referer = Uri.parse(decoded.url);
    return [
      VideoServer(url: b, name: decoded.name, extra: {
        'referer': '${referer.scheme}://${referer.host}/'
        // referer.host
      })
    ];
  }

  @override
  Future<List<SearchResponse>> search(String query) async {
    return (await client.get('$hostUrl/search?json=1&q=${encode(query)}')).json(
        (json) => (json['movies'] as List)
            .mapAsList((e) => _PressPlaySearchResponse.fromJson(hostUrl, e)));
  }

  Future<String> _extractIframe(String url) {
    return client.get(url).then((response) async {
      final doc = response.document;

      const playerQueryApi = 'data-cinemaplayer-query-api';

      final player = doc.selectFirst('div#cinemaplayer');
      final apiUrl = player.attr('data-cinemaplayer-api');
      if (apiUrl.contains('json')) {
        return apiUrl;
      }
      final id = player.attr('$playerQueryApi-id');
      final imdbId = player.attr('$playerQueryApi-imdb_id');
      final tmdbId = player.attr('$playerQueryApi-tmdb_id');
      final movieId = player.attr('$playerQueryApi-movie_id');
      final type = player.attr('$playerQueryApi-type');
      final title = player.attr('$playerQueryApi-title');
      final year = player.attr('$playerQueryApi-year');
      final season = player.attr('$playerQueryApi-season');
      final ip = player.attr('$playerQueryApi-ip');
      final hash = player.attr('$playerQueryApi-hash');
      final episode = player.attr('$playerQueryApi-episode');

      final params = {
        'hash': hash,
        'ip': ip,
        'episode': episode,
        'season': season,
        'year': year,
        'title': title,
        'type': type,
        'movie_id': movieId,
        'tmdb_id': tmdbId,
        'imdb_id': imdbId,
        'id': id,
      };

      final url = (await client.get('$hostUrl$apiUrl', params: params))
          .json((json) => (json['simple-api'] as List)[0]['iframe'] as String);

      return url;
    });
  }
}

class _PressPlayVideoServerResponse extends VideoServer {
  final String referer;
  const _PressPlayVideoServerResponse({
    required super.url,
    required super.name,
    required this.referer,
  });

  factory _PressPlayVideoServerResponse.fromJson(dynamic json) {
    return _PressPlayVideoServerResponse(
        name: json['name'], url: json['url'], referer: json['referer']);
  }

  String encode() => json.encode(toJson());

  factory _PressPlayVideoServerResponse.decode(String url) =>
      _PressPlayVideoServerResponse.fromJson(json.decode(url));

  Map<String, dynamic> toJson() {
    return {'name': name, 'url': url, 'referer': referer};
  }
}

class _PressPlayEpisodeResponse extends Episode {
  const _PressPlayEpisodeResponse({required super.number, super.url});

  factory _PressPlayEpisodeResponse.fromJson(
    dynamic json,
  ) {
    return _PressPlayEpisodeResponse(
      number: json['number'],
      url: _PressPlayVideoServerResponse(
              url: json['url'], name: json['server'], referer: json['referer'])
          .encode(),
    );
  }
}

class _PressPlaySeasonResponse extends Season {
  const _PressPlaySeasonResponse({
    required super.number,
    super.url,
    super.id,
    super.title,
  });

  factory _PressPlaySeasonResponse.fromJson(dynamic json) {
    return _PressPlaySeasonResponse(
        number: (json['season'] as String).toInt(),
        url: json['iframe'],
        id: (json['episode'] as String).toInt(),
        title: json['name']);
  }
}

class _PressPlaySearchResponse extends SearchResponse {
  const _PressPlaySearchResponse(
      {required super.title,
      required super.url,
      required super.cover,
      required super.type});

  factory _PressPlaySearchResponse.fromJson(String hosturl, dynamic json) {
    return _PressPlaySearchResponse(
        title: json['title'] ?? json['title_en'] ?? json['title_full'] ?? '',
        cover: hosturl + (json['poster'] as String),
        url: json['url'],
        type: json['type'].toString() == '0'
            ? MediaType.movie
            : MediaType.tvShow);
  }
}

