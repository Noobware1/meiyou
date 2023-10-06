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

  static VideoFormat getFormatFromUrl(String url) {
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

  factory Video.formEntity(VideoEntity entity) {
    return Video(
        url: entity.url,
        quality: entity.quality,
        fromat: entity.fromat,
        backup: entity.backup,
        extra: entity.extra,
        title: entity.title);
  }

  Map<String, dynamic> toJson() {
    return {
      'url': url,
      'quality': quality.toString(),
      'fromat': fromat.toString(),
      'backup': backup,
      'extra': extra,
      'title': title
    };
  }

  factory Video.fromJson(dynamic json) {
    return Video(
        url: json['url'],
        quality: Quality.getQuailtyFromString(json['quality']),
        fromat: VideoFormat.values.firstWhere(
            (element) => element.toString() == json['fromat'].toString()),
        backup: json['backup'],
        extra: json['extra'],
        title: json['title']);
  }

  @override
  String toString() =>
      'url: $url,\nquality: $quality,\nfromat: $fromat,\ntitle: $title\n\backup: $backup\nextra: $extra';
}

