import 'package:equatable/equatable.dart';
import 'package:meiyou/core/resources/meta_provider.dart';
import 'package:meiyou/domain/entities/cast.dart';
import 'package:meiyou/domain/entities/recommedations.dart';
import 'package:meiyou/domain/entities/season.dart';

class MediaDetailsEntity extends Equatable {
  final int id;
  final MediaProvider mediaProvider;

  final String? title;
  final String? native;
  final String? romaji;

  final String? poster;
  final String? bannerImage;
  final List<String> genres;
  final String? originalLanguage;
  final String description;
  final double averageScore;
  final int? runtime;
  final DateTime? startDate;
  final DateTime? endDate;
  final String status;
  final String mediaType;
  final int? currentNumberEpisode;
  final int? totalEpisode;
  final int? totalSeason;
  final Map<String, String>? extrenalIds;
  final List<CastEnitity>? cast;
  // final List<Trailer>? videos;
  final List<RecommendationsEntity>? recommendations;
  // final List<Recommendations>? recommendations;
  final List<SeasonEntity>? seasons;

  const MediaDetailsEntity({
    required this.id,
    required this.mediaProvider,
    required this.mediaType,
    required this.status,
    this.native,
    this.romaji,
    this.extrenalIds,
    this.startDate,
    this.endDate,
    this.title,
    this.poster,
    this.cast,
    this.bannerImage,
    required this.genres,
    this.originalLanguage,
    this.description = '',
    this.runtime,
    this.totalSeason,
    this.currentNumberEpisode,
    this.averageScore = 0.0,
    this.totalEpisode,
    this.recommendations,
    this.seasons,
  });

  @override
  List<Object?> get props => [
        id,
        mediaProvider,
        native,
        romaji,
        startDate,
        status,
        endDate,
        title,
        poster,
        bannerImage,
        genres,
        originalLanguage,
        description,
        runtime,
        totalSeason,
        currentNumberEpisode,
        averageScore,
        totalEpisode,
        mediaType,
        extrenalIds,
        cast,
        recommendations,
        seasons,
      ];

  String get mediaTitle => title ?? romaji ?? native ?? 'No Title';
}
