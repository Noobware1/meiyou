import 'package:meiyou/core/resources/subtitle_format.dart';
import 'package:meiyou/core/resources/video_format.dart';
import 'package:meiyou/core/resources/watch_qualites.dart';
import 'package:meiyou/core/utils/extenstions/iterable.dart';
import 'package:meiyou/data/models/subtitle.dart';
import 'package:meiyou/data/models/video.dart';
import 'package:meiyou/domain/entities/video_container.dart';

class VideoContainer extends VideoContainerEntity {
  @override
  List<Video> get videos => super.videos as List<Video>;

  @override
  List<Subtitle>? get subtitles => super.subtitles as List<Subtitle>?;

  const VideoContainer(
      {super.title,
      required List<Video> videos,
      List<Subtitle>? subtitles,
      super.headers,
      super.extra})
      : super(videos: videos, subtitles: subtitles);

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'videos': videos.mapAsList((it) => it.toJson()),
      'subtitles': subtitles?.mapAsList((it) => it.toJson()),
      'headers': headers,
      'extra': extra,
    };
  }

  factory VideoContainer.fromJson(dynamic json) {
    return VideoContainer(
      title: json['title'],
      videos: (json['videos'] as List).mapAsList((it) => Video.fromJson(it)),
      subtitles: (json['subtitles'] as List?)
          ?.mapAsList((it) => Subtitle.fromJson(it)),
      extra: json['extra'],
      headers: (json['headers'] as Map?)
          ?.map((key, value) => MapEntry(key.toString(), value.toString())),
    );
  }

  @override
  String toString() =>
      'title: $title,\nvidoes: ${videos.toString()}\nsubtitles: ${subtitles.toString()},\nheaders: $headers\nextra: $extra';
}
