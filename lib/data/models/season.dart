import 'package:meiyou/core/utils/date_time.dart';
import 'package:meiyou/domain/entities/season.dart';

class Season extends SeasonEntity {
  const Season(
      {required super.number,
      super.id,
      super.title,
      super.url,
      super.airDate,
      super.totalEpisode,
      super.isOnGoing});

  factory Season.fromTMDB(dynamic json) {
    return Season(
        id: json['id'] as int,
        number: json['season_number'] as num,
        title: json["name"],
        airDate: DateTimeFormatter.toDateTimeFromTMDBFormat(
            json['air_date'].toString()),
        totalEpisode: json['episode_count'] as int?);
  }
}
