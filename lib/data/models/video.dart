import 'package:meiyou/core/resources/quailty.dart';
import 'package:meiyou/core/resources/video_format.dart';
import 'package:meiyou/domain/entities/video.dart';

class Video extends VideoEntity {
  const Video(
      {required super.url,
      required super.quality,
      required super.fromat,
      super.backup,
      super.extra,
      super.title});

  static getFormatFromUrl(String url) {
    if (url.endsWith('.m3u8')) {
      return VideoFormat.hls;
    } else if (url.endsWith('.mp4')) {
      return VideoFormat.mp4;
    } else {
      return VideoFormat.other;
    }
  }

  factory Video.withFromatAndQuailty(String url, String quailty,
      [Map<String, dynamic>? extra]) {
    return Video(
        url: url,
        quality: Quality.getQuailtyFromString(quailty),
        fromat: getFormatFromUrl(url));
  }

  @override
  String toString() =>
      'url: $url,\nquality: $quality,\nfromat: $fromat,\ntitle: $title\n\backup: $backup\nextra: $extra';
}
