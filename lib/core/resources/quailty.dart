import 'package:meiyou/core/resources/watch_qualites.dart';
import 'package:meiyou/core/utils/extenstions/string.dart';
import 'package:equatable/equatable.dart';

class Quality extends Equatable {
  final int pixel;
  final int quaility;
  const Quality({required this.pixel, required this.quaility});

  @override
  String toString() {
    return '${pixel}x$quaility';
  }

  @override
  List<Object?> get props => [pixel, quaility];

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Quality && pixel == other.pixel && quaility == other.quaility;

  @override
  int get hashCode => Object.hash(pixel, quaility);

  static Quality getQuailtyFromString(String str) {
    const defaultQuality = 720;
    if (str.contains('p')) {
      final quaility =
          (str.substring(0, str.length - 1)).toIntOrNull() ?? defaultQuality;
      if (quaility == 1080) {
        return WatchQualites.quaility1080;
      } else if (quaility == 480) {
        return WatchQualites.quaility480;
      } else if (quaility == 360) {
        return WatchQualites.quaility360;
      } else {
        return WatchQualites.quaility720;
      }
    } else if (str.toIntOrNull() != null) {
      final quailty = str.toInt();
      return Quality(pixel: (quailty * (16 / 9)).ceil(), quaility: quailty);
    } else if (str.contains('x')) {
      final list = str.split('x');
      final pixel = list.first.toIntOrNull() ?? 1280;
      final quality = list.last.toIntOrNull() ?? defaultQuality;
      return Quality(pixel: pixel, quaility: quality);
    } else {
      return WatchQualites.quaility720;
    }
  }
}
