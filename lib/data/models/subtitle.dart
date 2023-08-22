import 'package:meiyou/core/resources/subtitle_format.dart';
import 'package:meiyou/core/utils/extenstion.dart';
import 'package:meiyou/domain/entities/subtitle.dart';

class Subtitle extends SubtitleEntity {
  const Subtitle(
      {required super.url, required super.format, required super.lang});

  static SubtitleFormat getFromatFromUrl(String url) {
    switch (url.substringAfterLast('.')) {
      case 'vtt':
        return SubtitleFormat.vtt;
      case 'srt':
        return SubtitleFormat.srt;
      default:
        return SubtitleFormat.srt;
    }
  }
}
