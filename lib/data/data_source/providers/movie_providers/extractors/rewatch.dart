import 'package:meiyou/core/resources/client.dart';
import 'package:meiyou/core/resources/extractors/video_extractor.dart';
import 'package:meiyou/core/resources/video_format.dart';
import 'package:meiyou/core/resources/watch_qualites.dart';
import 'package:meiyou/core/utils/extenstions/iterable.dart';
import 'package:meiyou/core/utils/extenstions/string.dart';
import 'package:meiyou/data/models/subtitle.dart';
import 'package:meiyou/data/models/video.dart';
import 'package:meiyou/data/models/video_container.dart';

class ReWatch extends VideoExtractor {
  ReWatch(super.videoServer);

  @override
  String get name => 'ReWatch [Main]';

  @override
  Future<VideoContainer> extract() async {
    final data = (await client.get(hostUrl,
            referer: videoServer.extra!['referer'] as String))
        .json(_RewatchJsonResponse.fromJson);

    return VideoContainer(videos: [
      Video(
          url: data.source,
          quality: WatchQualites.master,
          fromat: VideoFormat.hls)
    ], subtitles: data.tracks);
  }
}

class _RewatchJsonResponse {
  final String source;
  final List<Subtitle>? tracks;

  const _RewatchJsonResponse({required this.source, this.tracks});

  factory _RewatchJsonResponse.fromJson(dynamic json) {
    final tracks = json['tracks'] as List?;
    return _RewatchJsonResponse(
        source: json['source'] as String,
        tracks: (tracks == null || tracks.isEmpty)
            ? null
            : tracks.mapAsList((it) {
                final str = it.toString();
                final lang = str.substringBeforeLast('https');
                final url = str.substringAfterLast(']');
                return Subtitle(
                    url: url,
                    format: Subtitle.getFromatFromUrl(url),
                    lang: lang);
              }));
  }
}
