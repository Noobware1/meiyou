import 'package:meiyou/core/utils/data_converter/data_convert.dart';
import 'package:meiyou/data/models/season.dart';

class SeasonListWriter extends CacheWriter<List<Season>> {
  @override
  List<Season> readFromJson(json) {
    final seasons = <Season>[];
    for (final season in (json as List)) {
      seasons.add(Season.fromJson(season));
    }
    return seasons;
  }

  @override
  String writeToJson(List<Season> data) {
    final seasons = <Map<String, dynamic>>[];
    for (final season in data) {
      seasons.add(season.toJson());
    }
    return jsonEncoder.encode(seasons);
  }
}
