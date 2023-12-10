import 'package:meiyou_extenstions/meiyou_extenstions.dart';

class DateTimeFormatter {
  static DateTime? toDateTimeFromTMDBFormat(String? date) {
    if (date != null && date.length == 10) {
      final year = date.substring(0, 4);
      final month = date.substring(5, 7);
      final day = date.substring(8, 10);

      return DateTime(year.toInt(), month.toInt(), day.toInt());
    }
    return null;
  }

  static DateTime? toDateTimeFromAnilistFormat(dynamic json) {
    final year = json["year"];
    final month = json["month"];
    final day = json["day"];
    if (year != null && month != null && day != null) {
      return DateTime(year as int, month as int, day as int);
    }
    return null;
  }
}
