import 'package:meiyou/core/utils/extenstions/iterable.dart';
import 'package:meiyou/core/utils/extenstions/string.dart';
import 'package:meiyou/core/utils/try_catch.dart';

class VideoQuality {
  final int width;
  final int height;

  const VideoQuality(this.width, this.height);

  static const VideoQuality unknown = VideoQuality(-1, -1);

  static const VideoQuality hls = VideoQuality(0, 0);

  static VideoQuality getFromString(String str) {
    str = str.toLowerCase().trim();
    if (str.endsWith('p')) {
      final int? value = str.substring(0, str.length - 1).toIntOrNull();
      if (value == null) return unknown;

      VideoQuality((value * 16) ~/ 9, value);
    } else if (str.contains('x')) {
      final heightAndWidth =
          str.split('x').mapAsList((it) => it.trim().toIntOrNull());
      if (heightAndWidth.length != 2 && heightAndWidth.contains(null)) {
        return unknown;
      }

      return trySync(() => VideoQuality(
              heightAndWidth[0]!.toInt(), heightAndWidth[1]!.toInt())) ??
          unknown;
    }

    return unknown;
  }
}