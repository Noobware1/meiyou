import 'package:meiyou/core/resources/watch_qualites.dart';

class Quality {
  final int pixel;
  final int quaility;
  const Quality({required this.pixel, required this.quaility});

  @override
  String toString() {
    return '${pixel}x$quaility';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Quality && pixel == other.pixel && quaility == other.quaility;

  @override
  int get hashCode => Object.hash(pixel, quaility);

  static Quality getQuailtyFromString(String str) {
    const defaultQuality = 720;
    if (str.contains('p') && !str.contains('x')) {
      final quaility =
          int.tryParse(str.substring(0, str.length - 1)) ?? defaultQuality;
      if (quaility == 1080) {
        return WatchQualites.quaility1080;
      } else if (quaility == 480) {
        return WatchQualites.quaility480;
      } else if (quaility == 360) {
        return WatchQualites.quaility360;
      } else {
        return WatchQualites.quaility720;
      }
    } else {
      final list = str.split('x');
      final pixel = int.tryParse(list.first) ?? 1280;
      final quality = int.tryParse(list.last) ?? defaultQuality;
      return Quality(pixel: pixel, quaility: quality);
    }
  }
}
