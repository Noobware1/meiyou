import 'package:meiyou/core/resources/quailty.dart';
import 'package:meiyou/core/resources/watch_qualites.dart';

class M3u8File {
  final String url;
  final Qualites quality;

  const M3u8File({required this.url, required this.quality});

  @override
  String toString() => '${quality.toString()}\n$url';
}
