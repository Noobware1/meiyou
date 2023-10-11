import 'package:meiyou/domain/entities/video_server.dart';

class VideoServer extends VideoSeverEntity {
  final String? referer;
  const VideoServer({
    required super.url,
    required super.name,
    this.referer,
    super.extra,
  });

  @override
  String toString() {
    return 'VideoServer(name: "$name", url: "$url", extra: $extra)';
  }
}
