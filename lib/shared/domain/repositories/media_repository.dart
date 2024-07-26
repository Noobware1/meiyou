import 'dart:async';

import 'package:meiyou/core/utils/stream_utils/state_stream.dart';
import 'package:meiyou/shared/domain/models/media.dart';
import 'package:meiyou/shared/domain/models/repositories_params/media_repository_params.dart';
import 'package:nice_dart/nice_dart.dart';

abstract class MediaRepository {
  Future<Result<Media>> networkMediaToLocal(NetworkMediaToLocalParams params);

  Media? getMediaById(GetMediaByIdParams params);

  Media? getMediaByUrlAndSourceId(GetMediaByUrlAndSourceIdParams params);

  Future<int> insertMedia(InsertMediaParams params);

  //   suspend fun getAnimeByUrlAndSourceId(url: String, sourceId: Long): Anime?

  //   fun getAnimeByUrlAndSourceIdAsFlow(url: String, sourceId: Long): Flow<Anime?>

  //   suspend fun getAnimeFavorites(): List<Anime>

  //   suspend fun getLibraryAnime(): List<LibraryAnime>

  //   fun getLibraryAnimeAsFlow(): Flow<List<LibraryAnime>>

  //   fun getAnimeFavoritesBySourceId(sourceId: Long): Flow<List<Anime>>

  //   suspend fun getDuplicateLibraryAnime(id: Long, title: String): List<Anime>

  //   suspend fun getUpcomingAnime(statuses: Set<Long>): Flow<List<Anime>>

  //   suspend fun resetAnimeViewerFlags(): Boolean

  //   suspend fun setAnimeCategories(animeId: Long, categoryIds: List<Long>)

  //   suspend fun insertAnime(anime: Anime): Long?

  //   suspend fun updateAnime(update: AnimeUpdate): Boolean

  //   suspend fun updateAllAnime(animeUpdates: List<AnimeUpdate>): Boolean
}
