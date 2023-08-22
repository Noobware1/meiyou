import 'package:meiyou/core/resources/client.dart';
import 'package:meiyou/core/resources/extractors/video_extractor.dart';
import 'package:meiyou/core/resources/media_type.dart';
import 'package:meiyou/core/resources/providers/movie_provider.dart';
import 'package:meiyou/core/utils/extenstion.dart';
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

  // Future<LoadResponse?> load(
  //     {required SearchResponse data,
  //     List<Season>? seasons,
  //     Season? season}) async {
  //   //print(data.title);
  //   final LoadResponse? response;
  //   if (data.type == MediaType.movie) {
  //     final movie = await loadMovie(data.url);

  //     response = movie != null ? LoadResponse.fromMovie(movie: movie) : null;
  //   } else {
  //     final List<Episode>? episode;
  //     if (seasons == null) {
  //       final allSeasons = await loadSeasons(data.url);
  //       if (allSeasons == null || allSeasons.isEmpty) {
  //         episode = await loadEpisodes(data.url);
  //         response = (episode != null)
  //             ? LoadResponse.fromTvResponse(episodes: episode, seasons: seasons)
  //             : null;
  //       } else {
  //         episode = await loadEpisodes(
  //             allSeasons[season!.number.toInt() - 1].seasonUrl);
  //         response = (episode != null)
  //             ? LoadResponse.fromTvResponse(
  //                 episodes: episode, seasons: allSeasons)
  //             : null;
  //       }
  //     } else {
  //       episode =
  //           await loadEpisodes(seasons[season!.number.toInt() - 1].seasonUrl);
  //       response = (episode != null)
  //           ? LoadResponse.fromTvResponse(episodes: episode, seasons: seasons)
  //           : null;
  //     }
  //   }

  //   return response;
  // }

  @override
  Future<List<Episode>> loadEpisodes(String url) async {
    final res = await client.get('$hostUrl/ajax/v2/season/episodes/$url');
    print(res.text);

    final episodes =
        res.document.select('div.swiper-container > div > div > div').map((it) {
      final details = it.selectFirst('div.film-detail');
      final img = it.selectFirst('a > img').attr('src');
      return Episode(
        number: RegExp(r'\d+')
            .firstMatch(details.selectFirst('div.episode-number').text)!
            .group(0)!
            .toNum(),
        title: details.selectFirst('h3.film-name').text.trimNewLines(),
        thumbnail: img.startsWith('http') ? img : '',
        url: '$hostUrl/ajax/v2/episode/servers/${it.attr('data-id')}',
      );
    }).toList();
    episodes.removeWhere((episode) => episode.number == 0);
    return episodes;
  }

  // @override
  // Future<Movie> loadMovie(String url) async {
  //   // final res = await client.get(url);
  //   // final id = RegExp(r"episodeId:\s'(\d+)'").firstMatch(res.text)!.group(1)!;
  //   return Movie(url: '$hostUrl/ajax/movie/episodes/$url');
  //   //   return Future.value(
  //   //       Movie(movieUrl: '$hostUrl/ajax/movie/episode/servers/$url'));
  // }

  @override
  Future<List<Season>> loadSeasons(String url) async {
    final res = await client.get('$hostUrl/ajax/v2/tv/seasons/$url');
    final seasons = res.document
        .select('div.dropdown-menu.dropdown-menu-model > a')
        .map((it) {
      return Season(
          number: it.text.substringAfter('Season ').toNum(),
          url: it.attr('data-id'));
    }).toList();

    return seasons;
  }

  // @override
  // VideoExtractor? loadVideoExtractor(VideoServer server) {
  //   final host = Uri.parse(server.serverUrl).host;

  //   if (host.contains('doki')) {
  //     return VidCloudExtractor(server);
  //   } else if (host.contains('rabbit')) {
  //     return VidCloudExtractor(server);
  //   } else {
  //     return null;
  //   }
  // }

  // @override
  // Future<List<VideoServer>?> loadVideoServers(String url) async {
  //   final res = await client.get(url, headers: {
  //     "X-Requested-With": "XMLHttpRequest",
  //   });

  //   final futures = res.document.select('ul > li > a').map((it) async {
  //     final name = it.text.substringAfter('Server').trimNewLines();
  //     final json =
  //         (await client.get('$hostUrl/ajax/sources/${it.attr("data-id")}'))
  //             .json();
  //     return VideoServer(name: name.trim(), serverUrl: json['link'] ?? '');
  //   });
  //   final servers = await Future.wait(futures);
  //   return servers;
  // }

  @override
  Future<List<SearchResponse>> search(String query) async {
    final doc = await client.get('$hostUrl/search/${encode(query)}', headers: {
      'User-Agent':
          'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:101.0) Gecko/20100101 Firefox/101.0',
      'Referer': '$hostUrl/',
    });
    final search = doc.document.select('.flw-item > div.film-poster').map((it) {
      final a = it.selectFirst('a');
      final url = a.attr('href');
      return SearchResponse(
          title: a.attr('title'),
          cover: it.selectFirst('img').attr('data-src'),
          url: url.substringAfterLast('-'),
          type: (url.contains('movie') ? MediaType.movie : MediaType.tvShow));
    });
    return search.toList();
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
  Future<List<VideoServer>> loadVideoServer(String url) {
    // TODO: implement loadVideoServer
    throw UnimplementedError();
  }
}
