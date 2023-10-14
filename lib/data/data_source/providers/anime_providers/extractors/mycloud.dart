import 'package:meiyou/core/resources/client.dart';
import 'package:meiyou/core/utils/extenstions/iterable.dart';
import 'package:meiyou/data/models/subtitle.dart';
import 'package:meiyou/data/models/video.dart';
import 'package:meiyou/core/resources/extractors/video_extractor.dart';
import 'package:meiyou/core/utils/extenstions/string.dart';
import 'package:meiyou/data/models/video_container.dart';

class MyCloud extends VideoExtractor {
  MyCloud(super.videoServer);

  @override
  Future<VideoContainer> extract() async {
    final token = (await client.get('https://vidstream.pro/futoken')).text;
    final query = hostUrl.substringAfterLast('/').substringBefore('?');

    final raw = (await client.post(videoServer.extra!['api'],
            headers: {"Content-Type": "application/x-www-form-urlencoded"},
            body: {'query': query, 'futoken': token}))
        .json((json) {
      print(json);
      return '${(json['rawURL'] as String)}?${hostUrl.substringAfter('?')}'
          .appendAutoStart;
    });
    print(raw);

    return (await client.get(raw, headers: {
      'Referer': hostUrl.appendAutoStart,
      "X-requested-with": "XMLHttpRequest"
    }))
        .json((json) => _SourceResponse.fromJson(json['result']));
  }

  @override
  String get name => 'mcloud';
}

extension _String on String {
  String get appendAutoStart => '$this&autostart=true';
}

class _SourceResponse extends VideoContainer {
  const _SourceResponse({required super.videos, super.subtitles});

  factory _SourceResponse.fromJson(dynamic json) {
    return _SourceResponse(
        videos: (json['sources'] as List).mapAsList((it) =>
            Video.hlsMaster((it['file'] as String).replaceFirst('#.mp4', ''))),
        subtitles: (json['tracks'] as List?)?.mapAsList((it) =>
            Subtitle.withSubtitleFromatFromUrl(
                it['file'], it['label'] ?? it['kind']))
          ?..removeWhere((element) => element.lang == 'thumbnails'));
  }
}
