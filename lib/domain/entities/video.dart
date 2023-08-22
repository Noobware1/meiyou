import 'package:equatable/equatable.dart';
import 'package:meiyou/core/resources/quailty.dart';
import 'package:meiyou/core/resources/video_format.dart';

class VideoEntity extends Equatable {
  final String? title;
  final String url;
  final Quality quality;
  final VideoFormat fromat;
  final Map<String, dynamic>? extra;

  const VideoEntity({
    required this.url,
    required this.quality,
    required this.fromat,
     this.extra,
    this.title,
  });

  @override
  List<Object?> get props => [url, quality, fromat, extra, title];
}
