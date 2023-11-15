import 'package:meiyou/data/models/media/video/subtitle_format.dart';

class Subtitle {
  final String url;
  final SubtitleFormat? format;
  final String? langauge;
  final Map<String, String>? headers;

  const Subtitle({
    required this.url,
    this.format,
    this.langauge,
    this.headers,
  });

  @override
  String toString() {
    return '''Subtitle(
      url: $url,
      format: $format,
      langauge: $langauge,
      headers: $headers,
    )''';
  }
}

