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

  @override
  String toString() =>
      'title: $title,\nvidoes: ${videos.toString()}\nsubtitles: ${subtitles.toString()},\nheaders: $headers\nextra: $extra';
}
