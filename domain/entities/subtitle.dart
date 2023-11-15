import 'package:equatable/equatable.dart';
import 'package:meiyou/core/resources/subtitle_format.dart';

class SubtitleEntity extends Equatable {
  final String url;
  final String lang;
  final Map<String, String>? headers;
  final SubtitleFormat format;

  const SubtitleEntity(
      {required this.lang,
      required this.url,
      this.headers,
      required this.format});

  static const noSubtitle = SubtitleEntity(
      lang: 'No Subtitle', url: '', format: SubtitleFormat.empty);

  @override
  List<Object?> get props => [
        url,
        lang,
        headers,
        format,
      ];
}
