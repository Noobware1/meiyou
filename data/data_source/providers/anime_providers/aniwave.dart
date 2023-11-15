import 'dart:convert';

import 'package:meiyou/core/resources/client.dart';
import 'package:meiyou/core/resources/extractors/video_extractor.dart';
import 'package:meiyou/core/resources/providers/anime_provider.dart';
import 'package:meiyou/core/try_catch.dart';
import 'package:meiyou/core/utils/encode.dart';
import 'package:meiyou/core/utils/extenstions/iterable.dart';
import 'package:meiyou/core/utils/extenstions/list.dart';
import 'package:meiyou/core/utils/extenstions/string.dart';
import 'package:meiyou/data/models/episode.dart';
import 'package:meiyou/data/models/search_response.dart';
import 'package:meiyou/data/models/video_server.dart';
import 'package:ok_http_dart/dom.dart';
import 'package:ok_http_dart/html_paser.dart' as parser;
import 'package:ok_http_dart/ok_http_dart.dart';

import 'extractors/file_moon.dart';
import 'extractors/mp4upload.dart';
import 'extractors/mycloud.dart';

class Aniwave extends AnimeProvider {
  @override
  String get hostUrl => 'https://aniwave.to';

  @override
  Future<List<Episode>> loadEpisodes(String url) async {
    final id = (await client.get(url))
        .document
        .selectFirst('.brating > #w-rating')
        .attr('data-id');
    final vrf = await _getVrf(id);
    final episodeUrl =
        '$hostUrl/ajax/episode/list/$id?${vrf.query}=${encode(vrf.url, "%2B")}';

    return _AniwaveEpisode.toEpisodeResponse(
        (await client.get(episodeUrl)).aniwaveDocument);
  }

  @override
  VideoExtractor? loadVideoExtractor(VideoServer videoServer) {
    print(videoServer.url);
    switch (videoServer.name.substringBefore('-').trim()) {
      case 'Filemoon':
        return FileMoon(videoServer);
      case 'Mp4upload':
        return Mp4Upload(videoServer);
      case 'MyCloud':
      case 'Vidplay':
        return MyCloud(videoServer.copyWith(extra: {
          'api':
              '$_apiUrl/raw${name == 'Vidplay' ? "Vizcloud" : "Mcloud"}?apikey=$_apiKey'
        }));
      default:
        return null;
    }
  }

  @override
  Future<List<VideoServer>> loadVideoServers(String url) async {
    final servers = <VideoServer>[];
    final vrf = await _getVrf(url);

    final list = (await client
            .get('$hostUrl/ajax/server/list/$url?${vrf.query}=${vrf.url}'))
        .aniwaveDocument
        .select('.servers > .type');
    for (final it in list) {
      for (final ul in it.select('ul > li')) {
        servers.addIfNotNull(await tryAsync(() async {
          final linkId = ul.attr('data-link-id');
          final vrf = await _getVrf(linkId, 'ajax-server');
          final url = (await client.get(
                  '$hostUrl/ajax/server/$linkId?${vrf.query}=${encode(vrf.url)}'))
              .json(_AniwaveVideoServer.fromJson);
          return VideoServer(
            url: (await _decrypt(url.url)).url,
            name: '${ul.text} - ${it.selectFirst('label').text.trim()}',
          );
        }));
      }
    }
    return servers;
  }

  @override
  String get name => 'Aniwave';

  @override
  Future<List<SearchResponse>> search(String query) async {
    return (await client.get('$hostUrl/filter?keyword=${encode(query, '+')}'))
        .document
        .select('#list-items div.ani.poster.tip > a')
        .mapAsList((it) {
      final img = it.selectFirst('img');
      return SearchResponse.anime(
          title: img.attr('alt'),
          url: hostUrl + it.attr('href'),
          cover: img.attr('src'));
    });
  }

  static const String _apiUrl = 'https://9anime.eltik.net';

  //thanks enimax :)
  static const String _apiKey = 'a3d659c362504617a366d1e7557af46c';

  Future<_Vrf> _getVrf(String id, [String action = 'vrf']) async {
    return (await client.get('$_apiUrl/$action?query=$id&apikey=$_apiKey'))
        .json(_Vrf.fromJson);
  }

  Future<_Vrf> _decrypt(String query) async {
    return (await client.get('$_apiUrl/decrypt?query=$query&apikey=$_apiKey'))
        .json(_Vrf.fromJson);
  }
}

class _AniwaveVideoServer {
  final String url;
  final String? skipData;

  factory _AniwaveVideoServer.fromJson(dynamic json) {
    return _AniwaveVideoServer(
        json['result']['url'], json['result']['skip_data']);
  }

  _AniwaveVideoServer(this.url, this.skipData);
}

class _Vrf {
  final String url;
  final String query;

  factory _Vrf.fromJson(dynamic json) {
    return _Vrf(json["url"], json["vrfQuery"]);
  }

  const _Vrf(this.url, this.query);
}

class _AniwaveEpisode extends Episode {
  const _AniwaveEpisode({required super.number, super.url, super.title});

  static List<_AniwaveEpisode> toEpisodeResponse(Document doc) {
    final list = doc.select('ul.ep-range > li > a');
    final episodes = <_AniwaveEpisode>[];
    for (final element in list) {
      episodes
          .addIfNotNull(trySync(() => _AniwaveEpisode.fromElement(element)));
    }
    return episodes;
  }

  factory _AniwaveEpisode.fromElement(Element element) {
    final number = element.attr('data-num').toInt();
    final title = trySync<Element>(() => element.selectFirst('span'))?.text;

    final ids = element.attr('data-ids');
    return _AniwaveEpisode(url: ids, number: number, title: title);
  }
}

extension _JsonUtils on OkHttpResponse {
  T aniwaveJson<T>(T Function(dynamic json) transformer) {
    print(text);

    return transformer(jsonDecode(text.replaceAll('\\"', "'")));
  }

  Document get aniwaveDocument =>
      parser.parse(aniwaveJson((json) => json['result']));
}

void main(List<String> args) async {
  final servers =
      await Aniwave().loadVideoServers('HTWaA8kl,HTSfDswm,HTWZDsMv');
  for (final server in servers) {
    try {
      print(await Aniwave().loadVideoExtractor(server)?.extract());
    } catch (e, s) {
      print(e);
      print(s);
    }

    print('');
  }
}
