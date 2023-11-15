import 'package:meiyou/core/resources/client.dart';
import 'package:meiyou/core/resources/extractors/video_extractor.dart';
import 'package:meiyou/core/resources/subtitle_format.dart';
import 'package:meiyou/core/resources/video_format.dart';
import 'package:meiyou/core/resources/watch_qualites.dart';
import 'package:meiyou/data/models/subtitle.dart';
import 'package:meiyou/data/models/video.dart';
import 'package:meiyou/data/models/video_container.dart';

class SusflixExtractor extends VideoExtractor {
  SusflixExtractor(super.videoServer);

  @override
  Future<VideoContainer> extract() async {
    return (await client.get(hostUrl)).json((json) {
      final videos = <Video>[];

      for (var e in (json['Qualities'] as List)) {
        videos.add(_Quailties.fromJson(e));
      }

      final sub = <Subtitle>[];

      (json['Srtfiles'] as List?)
          ?.forEach((e) => sub.add(_SrtFiles.fromJson(e)));

      return VideoContainer(
          videos: videos, subtitles: sub.isEmpty ? null : sub);
    });
  }

  @override
  String get name => 'SusflixExtractor';
}

class _Quailties extends Video {
  _Quailties({required String path, required String quality})
      : super(
            fromat: quality.toLowerCase() == 'auto'
                ? VideoFormat.hls
                : VideoFormat.mp4,
            url: path,
            quality: quality.toLowerCase() == 'auto'
                ? Qualites.master
                : Qualites.getFromString(quality));

  factory _Quailties.fromJson(dynamic json) {
    return _Quailties(path: json['path'], quality: json['quality']);
  }
}

class _SrtFiles extends Subtitle {
  const _SrtFiles({required String caption, required String url})
      : super(format: SubtitleFormat.srt, url: url, lang: caption);

  factory _SrtFiles.fromJson(dynamic json) {
    return _SrtFiles(caption: json['caption'], url: json['url']);
  }
}
