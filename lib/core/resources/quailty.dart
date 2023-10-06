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

  factory Quality.getQuailtyFromString(String str) {
    str = str.toLowerCase();
    const defaultQuality = 720;

    try {
      if (str.endsWith('p')) {
        final quaility =
            (str.substring(0, str.length - 1)).toIntOrNull() ?? defaultQuality;
        print(quaility);
        return Quality(pixel: (quaility.toInt() * 16) ~/ 9, quaility: quaility);
      } else if (str.contains('x')) {
        final list = str.split('x');
        final pixel = list.first.toIntOrNull() ?? 1280;
        final quality = list.last.toIntOrNull() ?? defaultQuality;
        return Quality(pixel: pixel, quaility: quality);
      } else {
        return WatchQualites.quaility720;
      }
    } catch (_) {
      print(_);
      return WatchQualites.quaility720;
    }
  }
}

void main(List<String> args) {
  Quality getFromStr(String str) {
    str = str.toLowerCase();
    const defaultQuality = 720;

    try {
      if (str.endsWith('p')) {
        final quaility =
            (str.substring(0, str.length - 1)).toIntOrNull() ?? defaultQuality;
        print(quaility);
        return Quality(pixel: (quaility.toInt() * 16) ~/ 9, quaility: quaility);
      } else if (str.contains('x')) {
        final list = str.split('x');
        final pixel = list.first.toIntOrNull() ?? 1280;
        final quality = list.last.toIntOrNull() ?? defaultQuality;
        return Quality(pixel: pixel, quaility: quality);
      } else {
        return WatchQualites.quaility720;
      }
    } catch (_) {
      print(_);
      return WatchQualites.quaility720;
    }
  }

  final a = getFromStr('');
  print(a);
}
