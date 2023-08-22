import 'package:meiyou/core/utils/extenstion.dart';
import 'package:meiyou/domain/entities/episode.dart';

class Episode extends EpisodeEntity {
  const Episode(
      {required super.number,
      super.url = '',
      super.title,
      super.desc,
      super.isFiller,
      super.rated,
      super.thumbnail});

  factory Episode.fromTMDB(dynamic json) {
    return Episode(
      title: json['name'],
      desc: json['overview'],
      rated: json['vote_average'].toString().substring(0, 3).toDoubleOrNull(),
      thumbnail: (json['still_path'] != null)
          ? 'https://image.tmdb.org/t/p/original${json["still_path"]}'
          : null,
      number: json['episode_number'] as num,
      url: '',
    );
  }

  static List<Map<String, dynamic>> toJson(List<Episode> episodes) {
    return episodes
        .map((episode) => {
              'name': episode.title,
              'overview': episode.desc,
              'still_path': episode.thumbnail,
              'vote_average': episode.rated,
              'episode_number': episode.number
            })
        .toList();
  }

  Episode copyWith({
    num? number,
    String? title,
    bool? isFiller,
    String? url,
    String? thumbnail,
    String? desc,
    double? rated,
  }) {
    return Episode(
        number: number ?? this.number,
        desc: desc ?? this.desc,
        title: title ?? this.title,
        url: url ?? this.url,
        isFiller: isFiller ?? this.isFiller,
        rated: rated ?? this.rated,
        thumbnail: thumbnail ?? this.thumbnail);
  }
}
