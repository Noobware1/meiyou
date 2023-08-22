import 'package:meiyou/core/resources/meta_provider.dart';
import 'package:meiyou/core/utils/date_time.dart';
import 'package:meiyou/core/utils/extenstion.dart';
import 'package:meiyou/core/utils/fix_anilist_description.dart';
import 'package:meiyou/core/utils/fix_tmdb_image.dart';
import 'package:meiyou/data/models/cast.dart';
import 'package:meiyou/data/models/recommendations.dart';
import 'package:meiyou/data/models/season.dart';
import 'package:meiyou/domain/entities/media_details.dart';

class MediaDetails extends MediaDetailsEntity {
  const MediaDetails({
    required super.id,
    required super.mediaProvider,
    required super.status,
    required super.mediaType,
    super.native,
    super.romaji,
    super.startDate,
    super.endDate,
    super.title,
    super.poster,
    super.bannerImage,
    required super.genres,
    super.originalLanguage,
    super.cast,
    super.description,
    super.recommendations,
    super.runtime,
    super.totalSeason,
    super.currentNumberEpisode,
    super.averageScore,
    super.extrenalIds,
    super.seasons,
    super.totalEpisode,
  });

  factory MediaDetails.fromTMDB(Map<String, dynamic> media, String type,
      [Map<String, dynamic>? episodes]) {
    final genres =
        (media['genres'] as List?)?.map((e) => e['name'].toString()).toList();

    final lastEpisodeToAir = media['last_episode_to_air'];

    int? totalEpisode = lastEpisodeToAir?['episode_number'] as int?;

    int? totalSeason = lastEpisodeToAir?['season_number'] as int?;

    return MediaDetails(
      id: media['id'],
      mediaProvider: MediaProvider.tmdb,
      cast: (media['credits']?['cast'] as List?)
          ?.map((it) => Cast.fromTMDB(it))
          .toList(),
      genres: genres ?? [''],
      runtime: media['runtime'],
      averageScore: (media['vote_average']?.toString() ?? '0').toDouble(),
      mediaType: type,
      originalLanguage: media['original_language'],
      bannerImage: getOriImageUrl(media["backdrop_path"]),
      description: media['overview'] ?? '',
      native: (media['original_name'] ?? media['original_title']) as String,
      startDate: DateTimeFormatter.toDateTimeFromTMDBFormat(
          media['release_date']?.toString() ??
              media["first_air_date"]?.toString()),
      poster: getImageUrl(media['poster_path']),
      // videos: List<dynamic>.from(media['videos']['results'])
      //     .map((e) => Trailer.fromJson(e))
      //     .toList(),
      status: getStatus(media['status'] as String),
      extrenalIds: getExternalIds(media['external_ids']),
      title: (media['name'] ?? media['title']) as String,
      recommendations: (media['recommendations']['results'] as List?)
          ?.map((it) => Recommendations.fromTMDB(it))
          .toList(),

      totalEpisode: totalEpisode,
      totalSeason: totalSeason,
      seasons:
          (media['seasons'] as List?)?.map((it) => Season.fromTMDB(it)).toList()
            ?..removeWhere((it) => it.number == 0),
      currentNumberEpisode:
          (media['next_episode_to_air']?['episode_number']?.toString() ?? '')
              .toIntOrNull(),
    );
  }

  factory MediaDetails.fromAnilist(dynamic json) {
    final media = json['data']['Media'];
    final title = media['title'];

    final startDate = media['startDate'];
    final endDate = media['endDate'];

    final characters = media['characters']?['edges'] as List?;
    final recommends = media['recommendations']?['edges'];

    final recommendations = (recommends as List?)
        ?.map((it) => Recommendations.fromAnilist(it))
        .toList();

    final nextAriringEpisode = media['nextAiringEpisode']?['episode'] as int?;
    final lastEp = (nextAriringEpisode != null)
        ? nextAriringEpisode - 1
        : media['episodes'] as int?;
    final images = media['coverImage'];
    final malId = media['idMal'];

    return MediaDetails(
      id: media['id'] as int,
      mediaProvider: MediaProvider.anilist,
      romaji: title?['romaji'] as String?,
      native: media?['native'] as String?,
      title: (title?['english'] ?? title?['userPreferred']) as String,
      mediaType: media['format']?.toString() ?? '',
      totalEpisode: lastEp,
      status: media['status'] as String,
      bannerImage: media['bannerImage'] as String?,
      poster: (images?['extraLarge'] ?? images?['large'] ?? images?['medium'])
          as String?,
      extrenalIds: malId != null ? {'mal': malId!.toString()} : null,
      originalLanguage: 'JP',
      startDate: DateTimeFormatter.toDateTimeFromAnilistFormat(startDate),
      endDate: DateTimeFormatter.toDateTimeFromAnilistFormat(endDate),
      genres: (media['genres'] as List).map((e) => e.toString()).toList(),
      // runtime: 1,
      averageScore: (media['meanScore']?.toString() ?? '0').toInt() / 10.0,
      cast: characters?.map((it) => Cast.fromAnilist(it)).toList(),
      description:
          fixAnilistDescription(media['description']?.toString() ?? ''),
      // lastSeason: null,
      currentNumberEpisode:
          nextAriringEpisode != null ? nextAriringEpisode - 1 : null,
      recommendations: recommendations,
    );
  }

  static String getStatus(String status) {
    const statusList = <String>['FINISHED', 'RELEASING', 'NOT YET RELEASED'];
    late final String fixedStatus;

    switch (status) {
      case 'Ended':
        fixedStatus = statusList[0];
        break;
      case 'Released':
        fixedStatus = statusList[0];
        break;
      case 'Returning Series':
        fixedStatus = statusList[1];
        break;
      case 'In Production':
        fixedStatus = statusList[2];
        break;
      case 'Canceled':
        fixedStatus = statusList[0];
        break;
      default:
        fixedStatus = status;
        break;
    }
    return fixedStatus.toUpperCase();
  }

  static Map<String, String>? getExternalIds(dynamic externalIds) {
    if (externalIds == null) return null;
    return Map<dynamic, dynamic>.from(externalIds)
        .map((key, value) => MapEntry(key.toString(), value.toString()));
  }

  factory MediaDetails.fromMediaDetailsEntity(
      MediaDetailsEntity mediaDetailsEntity) {
    return MediaDetails(
      id: mediaDetailsEntity.id,
      mediaProvider: mediaDetailsEntity.mediaProvider,
      status: mediaDetailsEntity.status,
      mediaType: mediaDetailsEntity.mediaType,
      native: mediaDetailsEntity.native,
      romaji: mediaDetailsEntity.romaji,
      startDate: mediaDetailsEntity.startDate,
      endDate: mediaDetailsEntity.endDate,
      title: mediaDetailsEntity.title,
      poster: mediaDetailsEntity.poster,
      bannerImage: mediaDetailsEntity.bannerImage,
      genres: mediaDetailsEntity.genres,
      originalLanguage: mediaDetailsEntity.originalLanguage,
      cast: mediaDetailsEntity.cast,
      description: mediaDetailsEntity.description,
      recommendations: mediaDetailsEntity.recommendations,
      runtime: mediaDetailsEntity.runtime,
      totalSeason: mediaDetailsEntity.totalSeason,
      currentNumberEpisode: mediaDetailsEntity.currentNumberEpisode,
      averageScore: mediaDetailsEntity.averageScore,
      extrenalIds: mediaDetailsEntity.extrenalIds,
      seasons: mediaDetailsEntity.seasons,
      totalEpisode: mediaDetailsEntity.totalEpisode,
    );
  }

  MediaDetails copyWith({
    int? id,
    MediaProvider? mediaProvider,
    String? title,
    String? native,
    String? romaji,
    String? poster,
    String? bannerImage,
    List<String>? genres,
    String? originalLanguage,
    String? description,
    double? averageScore,
    int? runtime,
    DateTime? startDate,
    DateTime? endDate,
    String? status,
    String? mediaType,
    int? currentNumberEpisode,
    int? totalEpisode,
    int? totalSeason,
    Map<String, String>? extrenalIds,
    List<Cast>? cast,
    //  List<Trailer>? videos,
    List<Recommendations>? recommendations,
    //  List<Recommendations>? recommendations,
    List<Season>? seasons,
  }) {
    return MediaDetails(
      id: id ?? this.id,
      mediaProvider: mediaProvider ?? this.mediaProvider,
      mediaType: mediaType ?? this.mediaType,
      status: status ?? this.status,
      genres: genres ?? this.genres,
      averageScore: averageScore ?? this.averageScore,
      bannerImage: bannerImage ?? this.bannerImage,
      native: native ?? this.native,
      romaji: romaji ?? this.romaji,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      title: title ?? this.title,
      poster: poster ?? this.poster,
      originalLanguage: originalLanguage ?? this.originalLanguage,
      description: description ?? this.description,
      runtime: runtime ?? this.runtime,
      totalSeason: totalSeason ?? this.totalSeason,
      currentNumberEpisode: currentNumberEpisode ?? this.currentNumberEpisode,
      totalEpisode: totalEpisode ?? this.totalEpisode,
      cast: cast ?? this.cast,
      extrenalIds: extrenalIds ?? this.extrenalIds,
      recommendations: recommendations ?? this.recommendations,
      seasons: seasons ?? this.seasons,
    );
  }
}

// void main(List<String> args) async {
//   final a = await client.get(
//       'https://api.themoviedb.org/3/movie/872585?api_key=a4fee432e967056d85559dfcb85ababa&append_to_response=credits,external_ids,videos,recommendations');

//   final b = a.media((media) => MediaDetails.fromTMDB(json, 'tv'));
//   print(b.cast?.map((e) => {e.name, e.characterName, e.image}));
//   print(b.title);
// }
