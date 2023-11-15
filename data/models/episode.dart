import 'package:meiyou/core/utils/extenstions/string.dart';
import 'package:meiyou/core/utils/fix_tmdb_image.dart';
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

  factory Episode.fromEntity(EpisodeEntity episodeEntity) {
    return Episode(
        number: episodeEntity.number,
        desc: episodeEntity.desc,
        isFiller: episodeEntity.isFiller,
        rated: episodeEntity.rated,
        thumbnail: episodeEntity.thumbnail,
        title: episodeEntity.title,
        url: episodeEntity.url);
  }

  factory Episode.fromTMDB(dynamic json) {
    return Episode(
      title: json['name'],
      desc: json['overview'],
      rated: json['vote_average'].toString().substring(0, 3).toDoubleOrNull(),
      thumbnail: (json['still_path'] != null)
          ? getImageUrl(json["still_path"])!
          : null,
      number: json['episode_number'] as num,
      url: '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'number': number,
      'url': url,
      'title': title,
      'desc': desc,
      'isFiller': isFiller,
      'rated': rated,
      'thumbnail': thumbnail,
    };
  }

  factory Episode.fromJson(dynamic json) {
    return Episode(
      number: json['number'] as num,
      url: json['url'] as String,
      title: json['title'] as String?,
      desc: json['desc'] as String?,
      isFiller: json['isFiller'] as bool?,
      rated: json['rated'] as double?,
      thumbnail: json['thumbnail'] as String?,
    );
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

  @override
  String toString() =>
      'number: $number,\ndesc: $desc,\nisFiller: $isFiller,\nrated: $rated,\nthumbnail: $thumbnail,\ntitle: $title,\nurl: $url\n';
}
