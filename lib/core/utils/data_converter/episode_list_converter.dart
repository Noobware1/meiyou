import 'package:meiyou/data/models/episode.dart';
import 'data_convert.dart';

class EpisodeListWriter extends CacheWriter<List<Episode>> {
  @override
  List<Episode> readFromJson(dynamic json) {
    final episodes = <Episode>[];
    for (var episode in (json as List)) {
      episodes.add(Episode.fromJson(episode));
    }
    return episodes;
  }

  @override
  String writeToJson(List<Episode> data) {
    final episodes = <Map<String, dynamic>>[];
    for (var episode in data) {
      episodes.add(episode.toJson());
    }
    return jsonEncoder.encode(episodes);
  }
}
