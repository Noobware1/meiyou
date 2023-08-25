import 'package:meiyou/core/resources/client.dart';
import 'package:meiyou/core/resources/extractors/video_extractor.dart';
import 'package:meiyou/core/resources/media_type.dart';
import 'package:meiyou/core/resources/providers/anime_provider.dart';
import 'package:meiyou/core/utils/extenstions/map.dart';
import 'package:meiyou/data/models/episode.dart';
import 'package:meiyou/data/models/search_response.dart';
import 'package:meiyou/data/models/video_server.dart';

class KickAssAnime extends AnimeProvider {
  @override
  String get name => 'KickAssAnime';

  @override
  String get hostUrl => 'https://kickassanime.am';

  @override
  Future<List<Episode>> loadEpisodes(String url) async {
    final session = client.session();
    try {
      final locale =
          (await session.get(url)).json((json) => (json['locales'] as List)[0]);

      final episodeUrl = '$url/episodes';

      Map<String, String> params(int page) =>
          {"ep": "1", "page": page.toString(), "lang": locale};

      final res = (await session.get(episodeUrl, params: params(1)))
          .json(_KickAssAnimeEpisodeJson.fromJson);
      final episodes = <Episode>[...res.result!.map((it) => it.toEpisode())];

      for (var i = 1; i < res.pages!.length; i++) {
        final data = await session.get(episodeUrl, params: params(i));

        final episode = data.json(_KickAssAnimeEpisodeJson.fromJson);
        episodes.addAll(episode.result!.map((e) => e.toEpisode()));
      }

      return episodes;
    } finally {
      session.close();
    }
  }

  @override
  Future<List<SearchResponse>> search(String query) async {
    final response = await client.post('$hostUrl/api/search',
        body: {"query": query}.toJson(),
        headers: {"Content-Type": "application/json"});
    return response
        .json((json) => (json as List).map((it) {
              final parsed = _KickAssAnimeSearchResponseJson.fromJson(it);
              return SearchResponse(
                  title: parsed.titleEn ?? parsed.title ?? '',
                  url: '$hostUrl/api/show/${parsed.slug}',
                  cover: hostUrl + parsed.poster,
                  type: MediaType.anime);
            }))
        .toList();
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

class _KickAssAnimeEpisodeJson {
  final int? currentPage;
  final List<_Page>? pages;
  final List<_Result>? result;

  const _KickAssAnimeEpisodeJson({
    this.currentPage,
    this.pages,
    this.result,
  });

  factory _KickAssAnimeEpisodeJson.fromJson(dynamic json) =>
      _KickAssAnimeEpisodeJson(
        currentPage: json["current_page"],
        pages: json["pages"] == null
            ? []
            : List<_Page>.from(json["pages"]!.map((x) => _Page.fromJson(x))),
        result: json["result"] == null
            ? []
            : List<_Result>.from(
                json["result"]!.map((x) => _Result.fromJson(x))),
      );
}

class _Page {
  final int? number;
  final String? from;
  final String? to;
  final List<double>? eps;

  _Page({
    this.number,
    this.from,
    this.to,
    this.eps,
  });

  factory _Page.fromJson(Map<String, dynamic> json) => _Page(
        number: json["number"],
        from: json["from"],
        to: json["to"],
        eps: json["eps"] == null
            ? []
            : List<double>.from(json["eps"]!.map((x) => x?.toDouble())),
      );
}

class _Result {
  final String? slug;
  final String? title;
  final num? durationMs;
  final num? episodeNumber;
  final String? episodeString;
  final String? thumbnail;

  const _Result({
    this.slug,
    this.title,
    this.durationMs,
    this.episodeNumber,
    this.episodeString,
    this.thumbnail,
  });

  Episode toEpisode() => Episode(
      number: episodeNumber!, title: title, thumbnail: thumbnail, url: slug!);

  factory _Result.fromJson(Map<String, dynamic> json) => _Result(
        slug: json["slug"],
        title: json["title"],
        durationMs: json["duration_ms"],
        episodeNumber: json["episode_number"],
        episodeString: json["episode_string"],
        thumbnail: json["thumbnail"] == null
            ? null
            : _Poster.fromJson(json["thumbnail"]).poster,
      );
}

class _KickAssAnimeSearchResponseJson {
  final String slug;
  final String? title;
  final String? titleEn;
  final String poster;

  const _KickAssAnimeSearchResponseJson({
    required this.slug,
    required this.title,
    required this.titleEn,
    required this.poster,
  });

  factory _KickAssAnimeSearchResponseJson.fromJson(Map<String, dynamic> json) {
    return _KickAssAnimeSearchResponseJson(
      slug: json["slug"],
      title: json["title"],
      titleEn: json["title_en"],
      poster: _Poster.fromJson(json["poster"]).poster,
    );
  }
}

class _Poster {
  // final List<String> formats;
  final String? sm;
  final String? hq;

  String get poster => "/image/poster/${(hq ?? sm ?? '')}";

  _Poster({
    // required this.formats,
    this.sm,
    this.hq,
  });

  factory _Poster.fromJson(Map<String, dynamic> json) {
    final formats = List.from(json["formats"].map((x) => x.toString()));
    return _Poster(
      sm: json["sm"] != null ? "${json["sm"]}.${formats[0]}" : null,
      hq: json["hq"] != null ? "${json["sm"]}.${formats[1]}" : null,
    );
  }
}

void main(List<String> args) async {
  final Stopwatch stopwatch = Stopwatch()..start();
  final a = await KickAssAnime()
      .loadEpisodes('https://kickassanime.am/api/show/one-piece-0948');
  print(a.length);
  print(stopwatch.elapsed.toString());
}
