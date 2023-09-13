import 'package:meiyou/domain/entities/video_server.dart';

class VideoServer extends VideoSeverEntity {
  const VideoServer({
    required super.url,
    required super.name,
    super.extra,
  });

  @override
  String toString() {
    return 'VideoServer(name: "$name", url: "$url", extra: $extra)';
  }
}
