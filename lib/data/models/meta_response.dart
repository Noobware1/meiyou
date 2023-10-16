import 'package:meiyou/core/resources/genres.dart';
import 'package:meiyou/core/resources/meta_provider.dart';
import 'package:meiyou/core/utils/date_time.dart';
import 'package:meiyou/core/utils/extenstions/string.dart';
import 'package:meiyou/core/utils/extenstions/iterable.dart';

import 'package:meiyou/core/utils/fix_anilist_description.dart';
import 'package:meiyou/core/utils/fix_tmdb_image.dart';
import 'package:meiyou/domain/entities/meta_response.dart';

class MetaResponse extends MetaResponseEntity {
  const MetaResponse({
    required super.id,
    required super.genres,
    super.bannerImage,
    required super.mediaProvider,
    super.title,
    super.airDate,
    super.originalLanguage,
    super.nextAiringEpisode,
    super.averageScore,
    super.totalEpisodes,
    super.native,
    super.isAdult,
    super.romanji,
    super.poster,
    super.type,
    super.description,
    super.countryOfOrigin,
    super.mediaType,
  });

  bool isAnime() {
    if (this.genres.contains('Animation') == true &&
        (originalLanguage == 'zh' || originalLanguage == 'ja')) {
      return true;
    } else {
      return false;
    }
  }

  factory MetaResponse.fromEntity(MetaResponseEntity metaResponseEntity) {
    return MetaResponse(
      id: metaResponseEntity.id,
      genres: metaResponseEntity.genres,
      bannerImage: metaResponseEntity.bannerImage,
      mediaProvider: metaResponseEntity.mediaProvider,
      title: metaResponseEntity.title,
      airDate: metaResponseEntity.airDate,
      originalLanguage: metaResponseEntity.originalLanguage,
      nextAiringEpisode: metaResponseEntity.nextAiringEpisode,
      averageScore: metaResponseEntity.averageScore,
      totalEpisodes: metaResponseEntity.totalEpisodes,
      native: metaResponseEntity.native,
      isAdult: metaResponseEntity.isAdult,
      romanji: metaResponseEntity.romanji,
      poster: metaResponseEntity.poster,
      type: metaResponseEntity.type,
      description: metaResponseEntity.description,
      countryOfOrigin: metaResponseEntity.countryOfOrigin,
      mediaType: metaResponseEntity.mediaType,
    );
  }

  factory MetaResponse.fromTMDB(dynamic json, String? type) {
    final genres = getGeneres(
        (json['genre_ids'] as List?)?.mapAsList((e) => e.toString()));

    return MetaResponse(
        id: json['id'],
        bannerImage: getOriImageUrl(json["backdrop_path"]),
        title: (json['name'] ?? json['title']) as String,
        native: (json['original_name'] ?? json['original_title']) as String,
        genres: genres,
        poster: getImageUrl(json["poster_path"]),
        averageScore: (json['vote_average']?.toString() ?? '0').toDouble(),
        originalLanguage: json['original_language'] ?? '',
        description: json['overview'] ?? '',
        airDate: DateTimeFormatter.toDateTimeFromTMDBFormat(
            json['first_air_date'] as String?),
        mediaProvider: MediaProvider.tmdb,
        mediaType: json['media_type'] as String? ?? type);
  }

  factory MetaResponse.fromAnilist(dynamic json,
      [String? countryOfOrigin, bool? isAdult]) {
    final title = json['title'];

    final startDate = json['startDate'];
    // final endDate = json['endDate'];

    final genres =
        (json['genres'] as List?)?.map((e) => e as String).toList() ?? [''];

    final images = json['coverImage'];

    return MetaResponse(
        id: json['id'].toString().toInt(),
        romanji: title?['romaji'] as String?,
        native: json['native'] as String?,
        title: (title?['english'] ?? title?['userPreferred']) as String?,
        mediaType: json['format'],
        nextAiringEpisode: json['nextAiringEpisode']?['episode'],
        totalEpisodes: json['episodes'] as int?,
        // : json['status'].toString(),
        bannerImage: json['bannerImage'],
        poster:
            (images?['extraLarge'] ?? images?['large'] ?? images?['medium']),
        airDate: DateTimeFormatter.toDateTimeFromAnilistFormat(startDate),
        // : json?['idMal'].toString(),
        isAdult: json['isAdult'],
        mediaProvider: MediaProvider.anilist,
        type: json['type'],
        // : MainApiResponse.toDateTime(startDate),
        // endDate: MainApiResponse.toDateTime(endDate),
        description:
            fixAnilistDescription(json['description']?.toString() ?? ''),
        genres: genres,
        countryOfOrigin: json['countryOfOrigin'],
        averageScore: ((json['meanScore'] as int?) ?? 0) / 10.0);
  }

  MetaResponse copyWith({
    int? id,
    String? bannerImage,
    String? title,
    String? romanji,
    String? native,
    MediaProvider? mediaProvider,
    String? poster,
    List<String>? genres,
    String? originalLanguage,
    int? nextAiringEpisode,
    String? description,
    String? mediaType,
    bool? isAdult,
    DateTime? airDate,
    double? averageScore,
    int? totalEpisodes,
    String? countryOfOrigin,
  }) {
    return MetaResponse(
      id: id ?? this.id,
      genres: genres ?? this.genres,
      mediaProvider: mediaProvider ?? this.mediaProvider,
      airDate: airDate ?? this.airDate,
      averageScore: averageScore ?? this.averageScore,
      bannerImage: bannerImage ?? this.bannerImage,
      countryOfOrigin: countryOfOrigin ?? this.countryOfOrigin,
      description: description ?? this.description,
      isAdult: isAdult ?? this.isAdult,
      mediaType: mediaType ?? this.mediaType,
      native: native ?? this.native,
      nextAiringEpisode: nextAiringEpisode ?? this.nextAiringEpisode,
      originalLanguage: originalLanguage ?? this.originalLanguage,
      poster: poster ?? this.poster,
      romanji: romanji ?? this.romanji,
      title: title ?? this.title,
      totalEpisodes: totalEpisodes ?? this.totalEpisodes,
    );
  }
}
