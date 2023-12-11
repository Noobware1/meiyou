
import 'package:meiyou_extenstions/meiyou_extenstions.dart';

class M3u8File {
  final String url;
  final VideoQuality quality;

  const M3u8File({required this.url, required this.quality});

  @override
  String toString() => '${quality.toString()}\n$url';
}
