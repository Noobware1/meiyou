import 'package:equatable/equatable.dart';
import 'package:meiyou/core/resources/video_format.dart';
import 'package:meiyou/core/resources/watch_qualites.dart';

class VideoEntity extends Equatable {
  final String? title;
  final String url;
  final Qualites quality;
  final VideoFormat fromat;
  final bool backup;
  final Map<String, dynamic>? extra;

  const VideoEntity({
    required this.url,
    this.backup = false,
    required this.quality,
    required this.fromat,
    this.extra,
    this.title,
  });

  @override
  List<Object?> get props => [url, quality, fromat, extra, title];
}