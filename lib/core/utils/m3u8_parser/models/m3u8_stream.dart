import 'package:meiyou/core/resources/quailty.dart';

class M3u8File {
  final String url;
  final Quality quality;

  const M3u8File({required this.url, required this.quality});

  @override
  String toString() => '${quality.toString()}\n$url';
}
