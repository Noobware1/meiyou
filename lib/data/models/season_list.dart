import 'package:meiyou/core/utils/extenstions/iterable.dart';
import 'package:meiyou/data/models/episode.dart';
import 'package:meiyou/data/models/season_data.dart';
import 'package:meiyou/domain/entities/season_list.dart';

class SeasonList extends SeasonListEntity {
  @override
  SeasonData get season => super.season as SeasonData;
  @override
  List<Episode> get episodes => super.episodes.mapAsList((e) => e as Episode);

  SeasonList({required super.season, required super.episodes});

  @override
  String toString() {
    return '''SeasonList(season: $season, episodes: $episodes)''';
  }
}
