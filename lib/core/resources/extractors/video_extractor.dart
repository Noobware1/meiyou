import 'package:meiyou/data/models/video_container.dart';
import 'package:meiyou/data/models/video_server.dart';

abstract class VideoExtractor {
  final VideoServer videoServer;

  const VideoExtractor(this.videoServer);

  String get name;

  String get hostUrl => videoServer.url;

  Future<VideoContainer> extract();
}
