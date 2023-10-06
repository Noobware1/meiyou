import 'package:meiyou/core/resources/quailty.dart';
import 'package:meiyou/core/utils/extenstions/iterable.dart';
import 'package:meiyou/core/utils/extenstions/string.dart';

class WatchQualites {
  static const Quality quaility1080 = Quality(pixel: 1920, quaility: 1080);

  static const Quality quaility720 = Quality(pixel: 1280, quaility: 720);
  static const Quality quaility480 = Quality(pixel: 640, quaility: 480);
  static const Quality quaility360 = Quality(pixel: 640, quaility: 360);

  static const Quality master = Quality(pixel: 0, quaility: 0);
}

class Qualites {
  static const quality4k = Qualites(4096, 2160);
  static const quality1080 = Qualites(1920, 1080);
  static const quality720 = Qualites(1280, 720);
  static const quality480 = Qualites(853, 480);
  static const quality360 = Qualites(640, 360);
  static const master = Qualites(0, 0);
  static const unknown = Qualites(-1, -1);

  const Qualites(this.height, this.width);

  final int height;
  final int width;

  factory Qualites.getFromString(String str) {
    str = str.toLowerCase();
    if (str.endsWith('p')) {
      final int? value = str.toIntOrNull();
      if (value == null) {
        return Qualites.unknown;
      }
      return Qualites.values.tryfirstWhere((e) => e.width == value) ??
          Qualites((value * 16) ~/ 9, value);
    } else if (str.contains('x')) {
      final heightAndWidth =
          str.split('x').mapAsList((it) => it.trim().toIntOrNull());
      if (heightAndWidth.length != 2 && heightAndWidth.contains(null)) {
        return unknown;
      }

      return Qualites(heightAndWidth[0]!, heightAndWidth[1]!);
    }

    return unknown;
  }

  static const values = <Qualites>[
    quality4k,
    quality1080,
    quality720,
    quality480,
    quality360,
    master,
    unknown,
  ];
}

void main(List<String> args) {
  
}
