import 'package:meiyou/domain/entities/episode.dart';

class Episode extends EpisodeEntity {
  

  const Episode(
      {required super.data,
      super.name,
      super.season,
      super.episode,
      super.posterImage,
      super.description,
      super.isFiller,
      super.date});

  @override
  String toString() {
    return '''Episode(
       data: $data,
      name: $name,
      season: $season,
      episode: $episode,
      posterImage: $posterImage,
      description: $description,
      isFiller: $isFiller,
      date: $date)
      ''';
  }
}