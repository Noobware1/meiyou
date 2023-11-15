import 'package:meiyou/data/models/meta_response.dart';
import 'package:meiyou/domain/entities/recommedations.dart';

class Recommendations extends RecommendationsEntity {
  const Recommendations(
      {required super.id,
      required super.mediaProvider,
      // super.bannerImage,
      super.title,
      // super.airDate,
      super.originalLanguage,
      // super.nextAiringEpisode,
      super.averageScore,
      super.totalEpisodes,
      super.native,
      super.romanji,
      super.poster,
      required super.genres,
      super.description,
      super.mediaType});

  factory Recommendations.fromTMDB(dynamic json) {
    final response = MetaResponse.fromTMDB(json, null);

    return Recommendations(
      id: response.id,
      mediaProvider: response.mediaProvider,
      genres: response.genres,
      averageScore: response.averageScore,
      description: response.description,
      mediaType: response.mediaType,
      native: response.native,
      originalLanguage: response.originalLanguage,
      poster: response.poster,
      romanji: response.romanji,
      title: response.title,
      totalEpisodes: response.totalEpisodes,
    );
  }

  factory Recommendations.fromAnilist(dynamic json) {
    final response =
        MetaResponse.fromAnilist(json['node']['mediaRecommendation']);

    return Recommendations(
      id: response.id,
      mediaProvider: response.mediaProvider,
      genres: response.genres,
      averageScore: response.averageScore,
      description: response.description,
      mediaType: response.mediaType,
      native: response.native,
      originalLanguage: response.originalLanguage,
      poster: response.poster,
      romanji: response.romanji,
      title: response.title,
      totalEpisodes: response.totalEpisodes,
    );
  }

  factory Recommendations.fromEntity(RecommendationsEntity recommendationsEntity) {
    return Recommendations(
      id: recommendationsEntity.id,
      mediaProvider: recommendationsEntity.mediaProvider,
      genres: recommendationsEntity.genres,
      averageScore: recommendationsEntity.averageScore,
      description: recommendationsEntity.description,
      mediaType: recommendationsEntity.mediaType,
      native: recommendationsEntity.native,
      originalLanguage: recommendationsEntity.originalLanguage,
      poster: recommendationsEntity.poster,
      romanji: recommendationsEntity.romanji,
      title: recommendationsEntity.title,
      totalEpisodes: recommendationsEntity.totalEpisodes,
    );
  }
}
