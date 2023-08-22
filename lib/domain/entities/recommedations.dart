import 'package:equatable/equatable.dart';
import 'package:meiyou/core/resources/meta_provider.dart';
import 'package:meiyou/domain/entities/meta_response.dart';

class RecommendationsEnitiy extends Equatable {
  final int id;
  final MediaProvider mediaProvider;
  final String? title;
  final String? romanji;
  final String? native;
  final String? poster;
  final List<String> genres;
  final String? originalLanguage;
  // final int? nextAiringEpisode;
  final String description;
  final String? mediaType;
  // final DateTime? airDate;
  final double? averageScore;
  final int? totalEpisodes;

  const RecommendationsEnitiy(
      {required this.id,
      // this.bannerImage,
      this.title,
      required this.mediaProvider,
      // this.airDate,
      this.originalLanguage,
      // this.nextAiringEpisode,
      this.averageScore,
      this.totalEpisodes,
      this.native,
      this.romanji,
      this.poster,
      required this.genres,
      this.description = '',
      this.mediaType});

  @override
  List<Object?> get props => [
        id,
        // bannerImage,
        title,
        // airDate,
        originalLanguage,
        // nextAiringEpisode,
        averageScore,
        totalEpisodes,
        native,
        romanji,
        poster,
        genres,
        description,
        mediaType,
      ];

  MetaResponseEntity toMetaResponse() {
    return MetaResponseEntity(
      id: id,
      mediaProvider: MediaProvider.tmdb,
      genres: genres,
      averageScore: averageScore,
      description: description,
      mediaType: mediaType,
      native: native,
      originalLanguage: originalLanguage,
      poster: poster,
      romanji: romanji,
      title: title,
      totalEpisodes: totalEpisodes,
    );
  }
}
