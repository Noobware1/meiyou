
import 'package:meiyou/core/utils/data_converter/data_convert.dart';
import 'package:meiyou/core/utils/extenstions/iterable.dart';
import 'package:meiyou/core/utils/extenstions/string.dart';
import 'package:meiyou/data/models/episode.dart';

class SeasonEpisodeMapWriter extends CacheWriter<Map<num, List<Episode>>> {
  @override
  Map<num, List<Episode>> readFromJson(json) {
    final Map<num, List<Episode>> data = {};
    for (final entry in (json as Map).entries) {
      data[(entry.key as String).toNum()] =
          (entry.value as List).mapAsList(Episode.fromJson);
    }
    return data;
  }

  @override
  String writeToJson(Map<num, List<Episode>> data) {
    final Map<String, List<Map<String, dynamic>>> map = {};

    for (final enrtry in data.entries) {
      map[enrtry.key.toString()] = enrtry.value.mapAsList((it) => it.toJson());
    }
    return jsonEncoder.encode(map);
  }
}
