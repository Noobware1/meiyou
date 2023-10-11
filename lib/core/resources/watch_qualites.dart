import 'package:meiyou/core/resources/quailty.dart';
import 'package:meiyou/core/utils/extenstions/iterable.dart';
import 'package:meiyou/core/utils/extenstions/string.dart';

enum Qualites {
  quality4k(4096, 2160),
  quality1080(1920, 1080),
  quality720(1280, 720),
  quality480(853, 480),
  quality360(640, 360),
  master(0, 0),
  unknown(400, 4);

  const Qualites(this.height, this.width);

  final int height;
  final int width;

  factory Qualites.getFromString(String str) {
    str = str.toLowerCase().trim();
    if (str.endsWith('p')) {
      final int? value = str.substring(0, str.length - 1).toIntOrNull();
      if (value == null) return Qualites.unknown;

      return Qualites.values.tryfirstWhere((e) => e.width == value) ?? unknown;
      // Qualites((value * 16) ~/ 9, value);
    } else if (str.contains('x')) {
      final heightAndWidth =
          str.split('x').mapAsList((it) => it.trim().toIntOrNull());
      if (heightAndWidth.length != 2 && heightAndWidth.contains(null)) {
        return unknown;
      }

      return values.tryfirstWhere((e) =>
              e.height == heightAndWidth[0]! ||
              e.width == heightAndWidth[1]!) ??
          unknown;
    }

    return unknown;
  }
  @override
  String toString([bool widthOnly = false]) {
    return widthOnly ? '${width}p' : '${height}x$width';
  }
}
