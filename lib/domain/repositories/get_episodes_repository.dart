import 'package:meiyou/domain/entities/episode.dart';
import 'package:meiyou/domain/entities/season.dart';

abstract interface class GetEpisodesRepository {
  Future<List<EpisodeEntity>> getEpisodes(
      List<EpisodeEntity> episodes, SeasonEntity season);
}
