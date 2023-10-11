import 'dart:convert';

import 'package:meiyou/core/resources/client.dart';
import 'package:meiyou/core/resources/extractors/video_extractor.dart';
import 'package:meiyou/core/resources/quailty.dart';
import 'package:meiyou/core/resources/subtitle_format.dart';
import 'package:meiyou/core/resources/video_format.dart';
import 'package:meiyou/core/resources/watch_qualites.dart';
import 'package:meiyou/data/models/subtitle.dart';
import 'package:meiyou/data/models/video.dart';
import 'package:meiyou/data/models/video_container.dart';

class SusflixExtractor extends VideoExtractor {
  SusflixExtractor(super.videoServer);

  @override
  Future<VideoContainer> extract() {
    return client
        .get(hostUrl,
            cookie:
                'session=eyJfZnJlc2giOmZhbHNlLCJwaG9uZV9udW1iZXIiOiJsb2xpc3lvdXJraW5nIn0.ZQ2S9Q.kcOWpRD4AGycgr5Ue8ltzCMBSZI; remember_me="303220303220303216303212303225303262303223303226303224303214303213303247303213"')
        .then((response) {
      final json = jsonDecode(RegExp(r'response\s=\s({.*?});')
          .firstMatch(response.text)!
          .group(1)!
          .replaceAll("'", '"'));
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
            fromat: VideoFormat.mp4,
            url: path,
            quality: Qualites.getFromString(quality));

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
