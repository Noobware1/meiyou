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

  VideoServer copyWith({
    String? url,
    String? name,
    String? referer,
    Map<String, dynamic>? extra,
  }) {
    return VideoServer(
        url: url ?? this.url,
        name: name ?? this.name,
        extra: extra ?? this.extra,
        referer: referer ?? this.referer);
  }
}
