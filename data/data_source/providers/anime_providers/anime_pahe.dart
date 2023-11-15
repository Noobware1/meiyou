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

  @override
  Future<List<Episode>> loadEpisodes(String url) async {
    final res = (await client
            .get('$hostUrl/api?m=release&id=$url&sort=episode_asc&page=1'))
        .json();
    final lastPage = int.parse(res['last_page']?.toString() ?? '1');

    return [
      for (var i = 1; i <= lastPage; i++)
        (await client
                .get('$hostUrl/api?m=release&id=$url&sort=episode_asc&page=$i'))
            .json((json) {
          return (json['data'] as List).mapAsList((data) {
            return Episode(
                thumbnail: data['snapshot'],
                url: '$hostUrl/play/$url/${data['session']}',
                number: data['episode'] as num);
          });
        })
    ].faltten();
  }

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
    return (json['data'] as List).mapAsList((list) {
      return SearchResponse(
          title: list['title'],
          cover: list['poster'],
          url: list['session'],
          type: MediaType.anime);
    });
  }

  @override
  VideoExtractor loadVideoExtractor(VideoServer videoServer) {
    return Kwik(videoServer);
  }
}
