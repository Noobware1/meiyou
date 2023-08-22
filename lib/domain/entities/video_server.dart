import 'package:equatable/equatable.dart';

class VideoSeverEntity extends Equatable {
  final String name;
  final String url;

  final Map<String, dynamic>? extra;

  const VideoSeverEntity({
    required this.url,
    required this.name,
    this.extra,
  });

  @override
  List<Object?> get props => [name, url, extra];
}
