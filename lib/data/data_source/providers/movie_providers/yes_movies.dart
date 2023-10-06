import 'dart:convert';

import 'package:streamify/helpers/data_classes.dart';
import 'package:streamify/helpers/m3u8_helper.dart';
import 'package:streamify/helpers/utils.dart';
import 'package:streamify/providers/extractors/gogo_extractor.dart';
import 'package:streamify/providers/extractors/yes_movies_extractor.dart';

import 'base_movie_source_parser.dart';

class YesMoviesSearchResponse {
  final String title;
  final String cover;
  final String url;

  YesMoviesSearchResponse(
      {required this.title, required this.cover, required this.url});

  factory YesMoviesSearchResponse.fromJson(dynamic json, String hostUrl) {
    final id = json['s'].toString();
    return YesMoviesSearchResponse(
        title: json['t'].toString(),
        url: '$hostUrl/movie/$id.html',
        cover: 'https://img.vxdn.net/t-max/w_200/h_300/$id.jpg');
  }
}

class YesMovies extends MovieSource {
  @override
  // TODO: implement name
  String get name => 'YesMovies';

  @override
  // TODO: implement hostUrl
  String get hostUrl => 'https://ww.yesmovies.ag';

  final _tvRegex =
      RegExp(r'Season ([1-9]|[1-9]\d|100)\b|Season 0([1-9]|[1-9]\d|100)\b');

  @override
  Future<List<SearchResponse>?> search(String query) async {
    final season = RegExp(
        r'Season (?!1)([2-9]|[1-9]\d|100)\b|Season (?!01)0([2-9]|[1-9]\d|100)\b');
    try {
      final search = (await client.get(
              '$hostUrl/searching?q=${encode(query, "+")}&limit=40&offset=0'))
          .json();

      final data = List<dynamic>.from(search['data'])
          .map((e) => YesMoviesSearchResponse.fromJson(e, hostUrl))
          .toList();
      //data.removeWhere((element) => season.hasMatch(element.title));

      //print(data.map((e) => {e.title, e.cover, e.url}));
      final searchResponse = data.map((res) {
        if (_tvRegex.hasMatch(res.title)) {
          return SearchResponse(
              title: res.title,
              cover: res.cover,
              url: jsonEncode({"title": res.title, "url": res.url}),
              type: MediaType.tvShow);
        } else {
          return SearchResponse(
              title: res.title,
              cover: res.cover,
              url: res.url,
              type: MediaType.movie);
        }
      }).toList();
      return searchResponse;
    } catch (e) {
      print(e);
      return null;
    }
  }

  @override
  Future<Movie?> loadMovie(String url) async {
    try {
      final response = await client.get(url);

      final playUrl =
          RegExp(r'plyURL="(.+?)"').firstMatch(response.text)?.group(1);

      if (playUrl == null) return null;

      final mainUrl = base64Decode(playUrl).toUtf8String();

      final id = url.substringBefore('.html').substringAfterLast('-');

      final doc = response.document;

      final num = doc.selectFirst('#episodes-sv-1 > li').attr('data-id');

      final movieJson = Movie(
          url: json.encode(YesMoviesEpisodesUrlJson(
                  mainUrl: mainUrl,
                  id: id,
                  episode: num,
                  server: '1',
                  referer: url)
              .toJson()));
      return movieJson;
    } catch (e) {
      return null;
    }
  }

  @override
  Future<List<Episode>?> loadEpisodes(String url) async {
    try {
      final response = await client.get(url);

      final playUrl =
          RegExp(r'plyURL="(.+?)"').firstMatch(response.text)?.group(1);

      if (playUrl == null) return null;

      final mainUrl = base64Decode(playUrl).toUtf8String();

      final id = url.substringBefore('.html').substringAfterLast('-');

      final doc = response.document;

      final num =
          doc.select('#episodes-sv-1 > li').attr('data-id').reversed.toList();

      final episodeJson = List.generate(
          num.length,
          (i) => Episode(
              number: num[i],
              url: json.encode(YesMoviesEpisodesUrlJson(
                      mainUrl: mainUrl,
                      id: id,
                      episode: num[i],
                      server: '1',
                      referer: url)
                  .toJson())));

      return episodeJson;
    } catch (e) {
      return null;
    }
  }

  @override
  Future<List<Season>?> loadSeasons(String url) async {
    final decoded = YesMoviesEncoded.fromJson(url);
    try {
      final search = (await client.get(
              '$hostUrl/searching?q=${encode(decoded.title.substringBefore("- Season"), "+")}&limit=40&offset=0'))
          .json();

      final data = List<dynamic>.from(search['data'])
          .map((e) => YesMoviesSearchResponse.fromJson(e, hostUrl))
          .toList();
      final seasonsTitle = decoded.title.substringBefore(' - Season');
      final response = data
          .where((tv) =>
              _tvRegex.hasMatch(tv.title) &&
              tv.title.contains(seasonsTitle) &&
              tv.title.contains('Season'))
          .map<Season>((e) => Season(
              number: _tvRegex.firstMatch(e.title)?.group(1) ?? '1',
              seasonUrl: e.url))
          .toList();

      response.sort((a, b) => a.number.toInt().compareTo(b.number.toInt()));
      return response.toList();
    } catch (e) {
      print(e);
      return null;
    }
  }

  @override
  Future<List<VideoServer>?> loadVideoServers(String url) async {
    final decoded = YesMoviesEpisodesUrlJson.fromJson(jsonDecode(url));

    final headers = {
      'User-Agent':
          "Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:101.0) Gecko/20100101 Firefox/101.0",
      'Referer': decoded.referer,
      'Content-Type': "application/json",
      'X-Requested-With': "XMLHttpRequest",
    };

    final payload = {
      "m": decoded.id,
      "e": decoded.episode,
      "s": decoded.server
    };

    try {
      final response = (await client.post(
        '$hostUrl/datas',
        headers: headers,
        body: jsonEncode(payload),
      ))
          .json();
      final parsedDataResponse = YesMoviesDataResponse.fromJson(response);
      final url = '${decoded.mainUrl}/watch?v=${parsedDataResponse.url}';

      return [VideoServer(name: 'VidCloud9', serverUrl: url)];
    } catch (e) {
      return null;
    }
  }

  @override
  VideoExtractor loadVideoExtractor(VideoServer server) {
    return YesMovieExtractor(server);
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
}

class YesMoviesEncoded {
  final String title;
  final String url;

  const YesMoviesEncoded({required this.title, required this.url});

  factory YesMoviesEncoded.fromJson(String jsonString) {
    final json = jsonDecode(jsonString);
    return YesMoviesEncoded(
        title: json['title'].toString(), url: json['url'].toString());
  }
}

class YesMoviesEpisodesUrlJson {
  final String mainUrl;
  final String id;
  final String episode;
  final String server;
  final String referer;

  YesMoviesEpisodesUrlJson(
      {required this.mainUrl,
      required this.id,
      required this.referer,
      required this.episode,
      required this.server});

  factory YesMoviesEpisodesUrlJson.fromJson(Map<String, dynamic> json) {
    return YesMoviesEpisodesUrlJson(
        mainUrl: json['mainUrl'].toString(),
        id: json['id'].toString(),
        episode: json['e'].toString(),
        server: json['s'].toString(),
        referer: json['referer'].toString());
  }

  Map<String, String> toJson() {
    return Map<String, String>.from({
      'mainUrl': mainUrl,
      'id': id,
      'e': episode,
      's': server,
      'referer': referer
    });
  }
}

class YesMoviesDataResponse {
  final String url;
  final String ep;
  final String id;

  const YesMoviesDataResponse(this.url, this.id, this.ep);

  factory YesMoviesDataResponse.fromJson(dynamic json) {
    return YesMoviesDataResponse(
        json['url'].toString(), json['mid'].toString(), json['eps'].toString());
  }

  String decode() {
    return base64Decode(url).toUtf8String();
  }

  Map<String, String> toJson() {
    return Map<String, String>.from({'url': url, 'id': id, 'ep': ep});
  }
}
