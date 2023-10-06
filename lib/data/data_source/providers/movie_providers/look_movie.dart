import 'dart:convert';

import 'package:meiyou/core/resources/client.dart';
import 'package:meiyou/core/resources/extractors/video_extractor.dart';
import 'package:meiyou/core/resources/media_type.dart';
import 'package:meiyou/core/resources/providers/movie_provider.dart';
import 'package:meiyou/core/utils/encode.dart';
import 'package:meiyou/core/utils/extenstions/iterable.dart';
import 'package:meiyou/core/utils/extenstions/string.dart';
import 'package:meiyou/core/utils/fix_tmdb_image.dart';
import 'package:meiyou/data/data_source/providers/movie_providers/extractors/look_movie.dart';
import 'package:meiyou/data/models/episode.dart';
import 'package:meiyou/data/models/movie.dart';
import 'package:meiyou/data/models/search_response.dart';
import 'package:meiyou/data/models/season.dart';
import 'package:meiyou/data/models/video_server.dart';

class LookMovie extends MovieProvider {
  @override
  String get hostUrl => "https://corsproxy.io/?https://lookmovie.foundation";

  @override
  String get name => 'LookMovie';

  String? cookie;

  @override
  Future<List<Episode>> loadEpisodes(String url) async {
    final decoded = jsonDecode(url) as Map;
    final List<Episode> episodes = [];

    for (var e in (decoded['episodes'] as List)) {
      var episode = Episode.fromJson(e);

      episodes.add(episode.copyWith(
          url:
              '$hostUrl/api/v1/security/episode-access?id_episode=${episode.url}&hash=${decoded['hash']}&expires=${decoded['expires']}'));
    }

    return episodes;
  }

  @override
  Future<Movie> loadMovie(String url) async {
    return client
        .get('$hostUrl/movies/play/$url', cookie: cookie)
        .then((response) {
      final text = response.text;

      final id = RegExp(r'id_movie:\s(.*),').firstMatch(text)!.group(1);

      final hash = _hashRegex.firstMatch(text)?.group(2);
      final expires = _expiresRegex.firstMatch(text)!.group(1)!;
      final poster = RegExp(r'movie_poster:\s(.*),').firstMatch(text)?.group(1);
      final title = RegExp(r'title:\s(.*),').firstMatch(text)?.group(1);

      final url =
          '$hostUrl/api/v1/security/movie-access?id_movie=$id&hash=$hash&expires=$expires';

      return Movie(url: url, cover: poster, title: title);
    });
  }

  @override
  Future<List<Season>> loadSeasons(String url) async {
    return client
        .get('$hostUrl/shows/play/$url', cookie: cookie)
        .then((response) {
      final text = response.text;

      final seasons = <Season>[];

      final hash = _hashRegex.firstMatch(text)!.group(1)!;

      final expires = _expiresRegex.firstMatch((text))!.group(1)!;

      _fixJsonString(
              RegExp(r"window\.seasons='(.*?)';").firstMatch(text)!.group(1)!)
          .entries
          .forEach((e) {
        if (!e.key.toString().startsWith('meta')) {
          seasons.add(_LookMovieSeason.fromMapEntry(e, hash, expires));
        }
      });
      return seasons;
    });
  }

  @override
  VideoExtractor loadVideoExtractor(VideoServer videoServer) {
    return LookMovieExtractor(videoServer);
  }

  @override
  Future<List<VideoServer>> loadVideoServers(String url) async {
    return [
      VideoServer(
          url: url,
          name: 'LookMovie [Main]',
          extra: {'cookie': cookie!, 'url': hostUrl})
    ];
  }

  @override
  Future<List<SearchResponse>> search(String query) async {
    cookie = await _getCookie();
    final list = <SearchResponse>[];

    for (var e in (await Future.wait([
      client
          .get('$hostUrl/api/v1/movies/do-search/?q=${encode(query)}',
              cookie: cookie)
          .then((value) => value.json(
              (e) => LookMovieSearchResponse.fromResponse(e, MediaType.movie))),
      client
          .get('$hostUrl/api/v1/shows/do-search/?q=${encode(query)}',
              cookie: cookie)
          .then((value) => value.json(
              (e) => LookMovieSearchResponse.fromResponse(e, MediaType.tvShow)))
    ]))) {
      list.addAll(e);
    }

    return list;
  }

  Future<String> _getCookie() async {
    return _extractCookie((await client.get(hostUrl)).headers);
  }

  Map _fixJsonString(String jsonString) {
//fuck you look movie
    return jsonDecode(jsonDecode('"${jsonString.replaceAll("\\'", '')}"'))
        as Map;
  }

  String _extractCookie(Map<String, String> headers) =>
      headers['set-cookie'].toString();

  final _hashRegex = RegExp(r'''hash:\s'(.*)',|hash:\s"(.*)",''');
  final _expiresRegex = RegExp(r'expires:\s(\d+)');
}

class _LookMovieSeason extends Season {
  const _LookMovieSeason({required super.number, required super.url});

  factory _LookMovieSeason.fromMapEntry(
      MapEntry entry, String hash, String expires) {
    return _LookMovieSeason(
        number: entry.key.toString().toNum(),
        url: jsonEncode({
          'hash': hash,
          'expires': expires,
          'episodes': (entry.value['episodes'] as Map)
              .values
              .mapAsList((it) => _LookMovieEpisode.fromJson(it).toJson()),
        }));
  }
}

class _LookMovieEpisode extends Episode {
  const _LookMovieEpisode(
      {required super.number,
      super.url,
      super.thumbnail,
      super.desc,
      super.title});

  String get encode => jsonEncode(toJson());

  factory _LookMovieEpisode.fromJson(dynamic json) {
    return _LookMovieEpisode(
        number: json['episode_number'].toString().toNum(),
        thumbnail:
            json['still_path'] != null ? getImageUrl(json['still_path']) : null,
        url: json['id_episode'],
        desc: json['description'],
        title: json['title']);
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'number': number,
      'url': url,
      'title': title,
      'thumbnail': thumbnail,
      'desc': desc,
    };
  }
}

class LookMovieSearchResponse extends SearchResponse {
  const LookMovieSearchResponse(
      {required super.title,
      required super.url,
      required super.cover,
      required super.type});

  factory LookMovieSearchResponse.fromJson(dynamic json, String type) {
    return LookMovieSearchResponse(
        title: json['title'],
        url: json['slug'],
        cover: json['poster'],
        type: type);
  }

  static List<LookMovieSearchResponse> fromResponse(dynamic json, String type) {
    final List<LookMovieSearchResponse> list = [];
    for (var e in (json['result'] as List)) {
      list.add(LookMovieSearchResponse.fromJson(e, type));
    }
    return list;
  }
}
