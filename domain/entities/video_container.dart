import 'package:equatable/equatable.dart';
import 'package:meiyou/domain/entities/subtitle.dart';
import 'package:meiyou/domain/entities/video.dart';

class VideoContainerEntity extends Equatable {
  final String? title;
  final List<VideoEntity> videos;
  final Map<String, String>? headers;
  final List<SubtitleEntity>? subtitles;
  final Map<String, dynamic>? extra;

  const VideoContainerEntity(
      {this.title,
      required this.videos,
      this.headers,
      this.extra,
      this.subtitles});

  @override
  List<Object?> get props => [videos, title, headers, extra, subtitles];
}
