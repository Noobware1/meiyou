import 'package:meiyou/core/resources/subtitle_format.dart';
import 'package:meiyou/core/utils/extenstions/string.dart';
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

  factory Subtitle.withSubtitleFromatFromUrl(String url, String lang) {
    return Subtitle(
        url: url, format: Subtitle.getFromatFromUrl(url), lang: lang);
  }

  Map<String, dynamic> toJson() {
    return {
      'url': url,
      'format': format.toString(),
      'lang': lang,
    };
  }

  factory Subtitle.fromJson(dynamic json) {
    return Subtitle(
        url: json['url'],
        format: SubtitleFormat.values.firstWhere(
            (element) => element.toString() == json['format'].toString()),
        lang: json['lang']);
  }

  @override
  String toString() => 'url: $url,\nlang: $lang,\nformat: $format';
}
