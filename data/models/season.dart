import 'package:meiyou/core/utils/date_time.dart';
import 'package:meiyou/domain/entities/season.dart';

class Season extends SeasonEntity {
  const Season({
    required super.number,
    super.id,
    super.title,
    super.url,
    super.airDate,
    super.totalEpisode,
    super.isOnGoing,
  });

  factory Season.fromEntity(SeasonEntity seasonEntity) {
    return Season(
      number: seasonEntity.number,
      id: seasonEntity.id,
      title: seasonEntity.title,
      url: seasonEntity.url,
      airDate: seasonEntity.airDate,
      totalEpisode: seasonEntity.totalEpisode,
      isOnGoing: seasonEntity.isOnGoing,
    );
  }

  factory Season.fromTMDB(dynamic json) {
    return Season(
        id: json['id'] as int,
        number: json['season_number'] as num,
        title: json["name"],
        airDate: DateTimeFormatter.toDateTimeFromTMDBFormat(
            json['air_date'].toString()),
        totalEpisode: json['episode_count'] as int?);
  }

  Map<String, dynamic> toJson() {
    return {
      'number': number,
      'id': id,
      'title': title,
      'url': url,
      'airDate': airDate,
      'totalEpisode': totalEpisode,
      'isOnGoing': isOnGoing,
    };
  }

  factory Season.fromJson(dynamic json) {
    return Season(
      number: json['number'] as num,
      id: json['id'] as int?,
      title: json['title'] as String?,
      url: json['url'] as String?,
      airDate: json['airDate'],
      totalEpisode: json['totalEpisode'] as int?,
      isOnGoing: json['isOnGoing'] as bool?,
    );
  }

  Season copyWith({
    num? number,
    int? id,
    String? title,
    String? url,
    DateTime? airDate,
    int? totalEpisode,
    bool? isOnGoing,
  }) {
    return Season(
      number: number ?? this.number,
      id: id ?? this.id,
      title: title ?? this.title,
      url: url ?? this.url,
      airDate: airDate ?? this.airDate,
      totalEpisode: totalEpisode ?? this.totalEpisode,
      isOnGoing: isOnGoing ?? this.isOnGoing,
    );
  }

  @override
  String toString() {
    return 'Season(number: $number, id: $id, title: $title, url: $url, airDate: $airDate, totalEpisode: $totalEpisode, isOnGoing: $isOnGoing)';
  }
}
