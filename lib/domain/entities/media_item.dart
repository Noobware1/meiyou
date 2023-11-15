enum MediaItemType {
  Movie,
  TvSeries,
  Anime,
  Manga,
  Novel,
}

class MediaItemEntity {
  final MediaItemType type;

  const MediaItemEntity({required this.type});
}
