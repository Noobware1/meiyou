import 'package:meiyou/domain/entities/episode.dart';
import 'package:meiyou/domain/entities/season_data.dart';

class SeasonListEntity {
  final SeasonDataEntity season;
  final List<EpisodeEntity> episodes;

  SeasonListEntity({required this.season, required this.episodes});
}
