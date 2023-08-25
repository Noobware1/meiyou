import 'dart:async';
import 'package:meiyou/core/resources/client.dart';
import 'package:meiyou/core/resources/extractors/video_extractor.dart';
import 'package:meiyou/core/resources/media_type.dart';
import 'package:meiyou/core/resources/providers/anime_provider.dart';
import 'package:meiyou/core/utils/encode.dart';
import 'package:meiyou/data/models/episode.dart';
import 'package:meiyou/data/models/search_response.dart';
import 'package:meiyou/data/models/video_server.dart';
import 'package:ok_http_dart/ok_http_dart.dart';

class AnimePahe extends AnimeProvider {
  @override
  String get name => 'AnimePahe';

  @override
  String get hostUrl => 'https://animepahe.ru';

  // @override
  // Future<LoadResponse?> load(
  //     {required SearchResponse data,
  //     List<Season>? seasons,
  //     Season? season}) async {
  //   List<Episode>? episodes = await loadEpisodes(data.url);

  //   return (episodes != null)
  //       ? LoadResponse.fromTvResponse(episodes: episodes)
  //       : null;
  // }

  Stream<List<Episode>> _getEpisode(int total, String id) async* {
    for (var i = 2; i < total + 1; i++) {
      final res = (await client
              .get('$hostUrl/api?m=release&id=$id&sort=episode_asc&page=$i'))
          .json();
      yield _episodeFromApi(res, id);
    }
  }

  List<Episode> _episodeFromApi(dynamic json, String id) {
    final episodes = List.from(json['data']).map((data) {
      return Episode(
          thumbnail: data['snapshot'],
          url: '$hostUrl/play/$id/${data['session']}',
          number: data['episode'] as num);
    }).toList();
    return episodes;
  }

  @override
  Future<List<Episode>> loadEpisodes(String url) async {
    final res = (await client
            .get('$hostUrl/api?m=release&id=$url&sort=episode_asc&page=1'))
        .json();
    final lastPage = int.parse(res['last_page']?.toString() ?? '1');
    if (lastPage == 1) {
      return _episodeFromApi(res, url);
    } else {
      final completer = Completer<List<Episode>>();

      final List<Episode> episodes = [..._episodeFromApi(res, url)];
      _getEpisode(lastPage, url).listen((data) {
        episodes.addAll(data);
      }, onDone: () => {completer.complete(episodes)});

      return completer.future;
    }
  }

  // @override
  // VideoExtractor? loadVideoExtractor(VideoServer server) {
  //   return KwikExtractor(server);
  // }

//  @override
//   Future<List<VideoServer>?> loadVideoServers(String url) async {
//     final res = (await client.get(url)).document;
//     final servers = res.select('#resolutionMenu > .dropdown-item').map((it) {
//       return VideoServer(
//           name: it.text.replaceFirst('·', ''),
//           serverUrl: it.attr('data-src'),
//           referer: '$hostUrl/',
//           extra: {'quality': '${it.attr('data-resolution')}p'});
//     }).toList();
//     return servers;
//   }

  @override
  Future<List<SearchResponse>> search(String query) async {
    final search =
        await client.get('$hostUrl/api?m=search&q=${encode(query)}', headers: {
      "User-Agent":
          "Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:101.0) Gecko/20100101 Firefox/101.0",
      "Referer": hostUrl,
      "X-Requested-With": "XMLHttpRequest"
    });

    return search.json(_searchResponsefromApi);
  }

  List<SearchResponse> _searchResponsefromApi(dynamic json) {
    final data = List<dynamic>.from(json['data']).map((list) {
      return SearchResponse(
          title: list['title'],
          cover: list['poster'],
          url: list['session'],
          type: MediaType.anime);
    }).toList();
    return data;
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
