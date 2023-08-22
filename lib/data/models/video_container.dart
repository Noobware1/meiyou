import 'package:meiyou/data/models/subtitle.dart';
import 'package:meiyou/data/models/video.dart';
import 'package:meiyou/domain/entities/video_container.dart';

class VideoContainer extends VideoContainerEntity {
  const VideoContainer(
      {super.title,
      required List<Video> videos,
      List<Subtitle>? subtitles,
      super.headers,
      super.extra})
      : super(videos: videos, subtitles: subtitles);
}
