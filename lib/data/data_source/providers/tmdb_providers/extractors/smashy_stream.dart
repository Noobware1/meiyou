import 'dart:convert';

import 'package:meiyou/core/resources/client.dart';
import 'package:meiyou/core/resources/extractors/video_extractor.dart';
import 'package:meiyou/core/utils/encode.dart';
import 'package:meiyou/core/utils/extenstions/iterable.dart';
import 'package:meiyou/data/models/subtitle.dart';
import 'package:meiyou/data/models/video.dart';
import 'package:meiyou/data/models/video_container.dart';
import 'package:meiyou/data/models/video_server.dart';

class SmashyStreamExtractor extends VideoExtractor {
  SmashyStreamExtractor(super.videoServer);

  @override
  String get name => '[${videoServer.name}]';

  @override
  Future<VideoContainer> extract() {
    throw UnimplementedError();
  }

  String getReferer() => videoServer.extra!['referer'] as String;

  Future<VideoContainer> extractfix(String url) {
    return client.get(url, referer: getReferer()).then((response) {
      final json = jsonDecode(
          '{${RegExp(r'("file".*)}\);').firstMatch(response.text)!.group(1)!}}');

      List<String> getList(String name, [bool Function(String)? test]) {
        return (json[name] as String).split(',')
          ..removeWhere(test ?? (it) => it.isEmpty);
      }

      final titleAndUrlRegex = RegExp(r'\[(.*)\](.*)');

      List<String> getGroups(String text) => titleAndUrlRegex
          .firstMatch(text)!
          .groups([1, 2]).mapAsList((it) => it!);

      final files =
          getList('file', (str) => str.contains('auto') || str.isEmpty)
              .mapAsList((it) {
        final groups = getGroups(it);
        return Video.withFromatAndQuailty(groups[1], groups[0]);
      });

      final subtitles = getList('subtitle').mapAsList((it) {
        final groups = getGroups(it);
        return Subtitle.withSubtitleFromatFromUrl(
            groups[1], groups[0].replaceFirst('[', ''));
      });

      return VideoContainer(videos: files, subtitles: subtitles);
    });
  }

  extractdude(String url) async {
    final doc = client.get(url, referer: getReferer());
    final corsUrl =
        'https://embed.smashystream.com/cors.php?https://watchonline.ag';
    Future<Map<String, dynamic>> search(String query, String type) async =>
        (await client.get(
                '$corsUrl/api/v1/${type == "movie" ? "movies" : "shows"}?per-page=5&filters[q]=${encode(query)}'))
            .json((json) => json['items'] as Map<String, dynamic>);
    final json = await search('', '');
    final slug = json['slug'];

    Future<
        String> getSlug(String query, String type) async => (await client.get(
            '$corsUrl/api/v1/${type == "movie" ? "movies" : "shows"}?per-page=5&filters[q]=${encode(query)}'))
        .json((json) => json["items"]['slug'].toString());
  }
}

void main(List<String> args) async {
// {Player L, https://embed.smashystream.com/lktv09.php?imdb=tt0903747&season=1&episode=1}
// {Player D (Hindi)  , https://embed.smashystream.com/dude11_tv.php?imdb=tt0903747&season=1&episode=1}
// {Player H  , https://embed.smashystream.com/hdw.php?imdb=tt0903747&season=1&episode=1}
// {Player FX, https://embed.smashystream.com/fx555.php?tmdb=1396&season=1&episode=1}
// {Player ES  , https://embed.smashystream.com/ems.php?imdb=tt0903747&season=1&episode=1}
// {Player S, https://embed.smashystream.com/supertv.php?tmdb=1396&season=1&episode=1}
// {Player C  , https://embed.smashystream.com/cf.php?imdb=tt0903747&season=1&episode=1}
  // final a = SmashyStreamExtractor(const VideoServer(
  //     url:
  //         'https://embed.smashystream.com/fix05.php?tmdb=1396&season=1&episode=1',
  //     name: '',
  //     extra: {
  //       'referer':
  //           'https://embed.smashystream.com/playere.php?tmdb=1396&season=1&episode=1'
  //     }));
  // final b = await a.extractfix(a.videoServer.url);
  // b.videos.forEach((it) {
  //   print({it.url, it.quality, it.fromat});
  // });

  // b.subtitles!.forEach((it) {
  //   print({it.url, it.lang, it.format});
  // });

  final a = await client.get(
      'https://embed.smashystream.com/lktv09.php?imdb=tt9362722',
      referer: 'https://embed.smashystream.com/playere.php?imdb=tt9362722');
  print(a.text);
}
