import 'dart:async';
import 'package:meiyou/core/resources/client.dart';
import 'package:meiyou/core/resources/extractors/video_extractor.dart';
import 'package:meiyou/core/resources/media_type.dart';
import 'package:meiyou/core/resources/providers/anime_provider.dart';
import 'package:meiyou/core/utils/encode.dart';
import 'package:meiyou/core/utils/extenstions/iterable.dart';
import 'package:meiyou/data/data_source/providers/anime_providers/extractors/kwik.dart';
import 'package:meiyou/data/models/episode.dart';
import 'package:meiyou/data/models/search_response.dart';
import 'package:meiyou/data/models/video_server.dart';
import 'package:ok_http_dart/ok_http_dart.dart';

class AnimePahe extends AnimeProvider {
  @override
  String get name => 'AnimePahe';

  @override
  String get hostUrl => 'https://animepahe.ru';

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
      final List<Episode> episodes = [..._episodeFromApi(res, url)];

      for (var i = 2; i < lastPage + 1; i++) {
        episodes.addAll((await client
                .get('$hostUrl/api?m=release&id=$url&sort=episode_asc&page=$i'))
            .json((json) => _episodeFromApi(json, url)));
      }
      return episodes;
    }
  }

  // @override
  // VideoExtractor? loadVideoExtractor(VideoServer server) {
  //   return KwikExtractor(server);
  // }

  @override
  Future<List<VideoServer>> loadVideoServers(String url) async {
    return (await client.get(url))
        .document
        .select('#resolutionMenu > .dropdown-item')
        .mapAsList((it) {
      return VideoServer(
          name: it.text.replaceFirst('·', ''),
          url: it.attr('data-src'),
          extra: {
            'referer': '$hostUrl/',
            'quality': '${it.attr('data-resolution')}p'
          });
    });
  }

  @override
  Future<List<SearchResponse>> search(String query) {
    return client.get('$hostUrl/api?m=search&q=${encode(query)}', headers: {
      "User-Agent":
          "Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:101.0) Gecko/20100101 Firefox/101.0",
      "Referer": hostUrl,
      "X-Requested-With": "XMLHttpRequest"
    }).then((response) => response.json(_searchResponsefromApi));
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
    return Kwik(videoServer);
  }
}

