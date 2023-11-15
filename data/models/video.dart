import 'package:meiyou/core/resources/quailty.dart';
import 'package:meiyou/core/resources/video_format.dart';
import 'package:meiyou/core/resources/watch_qualites.dart';
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
        quality: Qualites.getFromString(quailty),
        fromat: getFormatFromUrl(url));
  }

  factory Video.hlsMaster(String url,
      {bool? backup, Map<String, dynamic>? extra}) {
    return Video(
        url: url,
        quality: Qualites.master,
        fromat: VideoFormat.hls,
        backup: backup ?? false);
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
      'quality': quality.index,
      'fromat': fromat.index,
      'backup': backup,
      'extra': extra,
      'title': title
    };
  }

  factory Video.fromJson(dynamic json) {
    return Video(
        url: json['url'],
        quality: Qualites.values[json['quality']],
        fromat: VideoFormat.values[json['fromat']],
        backup: json['backup'],
        extra: json['extra'],
        title: json['title']);
  }

  @override
  String toString() =>
      'url: $url,\nquality: $quality,\nfromat: $fromat,\ntitle: $title\n\backup: $backup\nextra: $extra';
}
