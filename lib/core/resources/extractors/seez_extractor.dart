import 'package:meiyou/core/resources/client.dart';
import 'package:meiyou/core/resources/extractors/video_extractor.dart';
import 'package:meiyou/core/utils/extenstion.dart';
import 'package:meiyou/core/utils/m3u8_parser/m3u8_parser.dart';
import 'package:meiyou/data/models/subtitle.dart';
import 'package:meiyou/data/models/video_container.dart';

class SeezExtractor extends VideoExtractor {
  SeezExtractor(super.videoServer);

  @override
  String get name => 'ReWatch';

  @override
  Future<VideoContainer> extract() async {
    final response = (await client.get(hostUrl,
            referer: videoServer.extra!['referer'] as String))
        .text;

    final token = RegExp(r"window\._token\s*=\s*'([a-f0-9]+)'")
        .firstMatch(response)!
        .group(1)!;

    final key = RegExp(r'video_key"\svalue="([a-f0-9]+)">')
        .firstMatch(response)!
        .group(1)!;

    final data = (await client.get(
            '${hostUrl.substringBefore("/embed")}/fetch/$key?_token=$token',
            headers: {"X-Requested-With": 'XMLHttpRequest'}))
        .json(_SeezJsonResponse.fromJson);

    return M3u8Parser.generateVideoContainer(data.source,
        subtitles: data.tracks);
  }
}



class _SeezJsonResponse {
  final String source;
  final List<Subtitle>? tracks;

  const _SeezJsonResponse({required this.source, this.tracks});

  factory _SeezJsonResponse.fromJson(dynamic json) {
    final tracks = json['tracks'] as List?;
    return _SeezJsonResponse(
        source: json['source'] as String,
        tracks: (tracks == null || tracks.isEmpty)
            ? null
            : tracks.map((it) {
                final str = it.toString();
                final lang = str.substringBeforeLast('https');
                final url = str.substringAfterLast(']');
                return Subtitle(
                    url: url,
                    format: Subtitle.getFromatFromUrl(url),
                    lang: lang);
              }).toList());
  }
}
