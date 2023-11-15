import 'package:equatable/equatable.dart';
import 'package:meiyou/core/resources/meta_provider.dart';

class MetaResponseEntity extends Equatable {
  final int id;
  final String? bannerImage;
  final String? title;
  final String? romanji;
  final String? native;
  final MediaProvider mediaProvider;
  final String? poster;
  final String? type;
  final List<String> genres;
  final String? originalLanguage;
  final int? nextAiringEpisode;
  final String description;
  final String? mediaType;
  final bool? isAdult;
  final DateTime? airDate;
  final double? averageScore;
  final int? totalEpisodes;
  final String? countryOfOrigin;

  const MetaResponseEntity(
      {required this.id,
      required this.mediaProvider,
      this.bannerImage,
      this.title,
      this.airDate,
      this.type,
      this.isAdult,
      this.countryOfOrigin,
      this.originalLanguage,
      this.nextAiringEpisode,
      this.averageScore = 0.0,
      this.totalEpisodes,
      this.native,
      this.romanji,
      this.poster,
      required this.genres,
      this.description = '',
      this.mediaType});

  String get nonNullTitle => title ?? romanji ?? native ?? 'No Title';

  @override
  List<Object?> get props => [
        id,
        bannerImage,
        title,
        airDate,
        originalLanguage,
        nextAiringEpisode,
        averageScore,
        totalEpisodes,
        native,
        romanji,
        poster,
        genres,
        description,
        mediaType,
      ];

  @override
  String toString() {
    return '''$id,
     $bannerImage,
     $title,
     $romanji,
     $native,
    $mediaProvider,
     $poster,
     $genres,
     $originalLanguage,
     $nextAiringEpisode,
     $description,
     $mediaType,
     $isAdult,
    $airDate,
    $averageScore,
     $totalEpisodes,
     $countryOfOrigin,
 ''';
  }
}
