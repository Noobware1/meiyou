
import 'package:meiyou/core/utils/unwrap.dart';
import 'package:meiyou/data/models/media/video/subtitle.dart';
import 'package:meiyou/data/models/media/video/video_source.dart';
import 'package:meiyou/domain/entities/media.dart';
import 'package:meiyou/domain/entities/media_type.dart';

class Video extends MediaEntity {
  List<VideoSource> videoSources;
  List<Subtitle>? subtitles;

  Video(
      {this.videoSources = const [],
      this.subtitles,
      super.extra,
      super.headers})
      : super(mediaType: MediaType.Video);

  @override
  String toString() {
    return '''Video(
      mediaType: $mediaType,
      videoSources: ${videoSources.isNotEmpty ? unwrapList<VideoSource>(videoSources) : []},
      subtitles: ${subtitles != null ? unwrapList<Subtitle>(subtitles!) : null},
      extra: $extra,
      headers: $headers,
    )''';
  }
}


