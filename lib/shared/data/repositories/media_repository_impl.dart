import 'dart:async';

import 'package:isar/isar.dart';
import 'package:meiyou/core/data_base/data_base.dart';
import 'package:meiyou/core/utils/extensions/result.dart';
import 'package:meiyou/core/utils/stream_utils/state_stream.dart';
import 'package:meiyou/shared/domain/models/media.dart';
import 'package:meiyou/shared/domain/models/media_content.dart';
import 'package:meiyou/shared/domain/models/repositories_params/media_repository_params.dart';
import 'package:meiyou/shared/domain/repositories/media_repository.dart';
import 'package:meiyou_extensions_lib/models.dart';
import 'package:nice_dart/nice_dart.dart';

class MediaRepositoryImpl implements MediaRepository {
  MediaRepositoryImpl(this._dataBase);

  final DataBase _dataBase;

  @override
  Future<Result<Media>> networkMediaToLocal(NetworkMediaToLocalParams params) {
    return runAsyncCatching(() async {
      final networkMedia = params.media;

      final local = await getMediaByUrlAndSourceId(
        GetMediaByUrlAndSourceIdParams(
          category: networkMedia.category,
          sourceId: networkMedia.sourceId,
          url: networkMedia.url,
        ),
      );

      if (local == null) {
        final id = await insertMedia(InsertMediaParams(media: networkMedia));
        return networkMedia..id = id;
      }

      return local;
    });
  }

  @override
  Future<Media?> getMediaById(GetMediaByIdParams params) {
    final category = params.category;
    final id = params.id;

    return _dataBase.mediaCollection(category).when(
          video: (collection) => collection.get(id),
          manga: (collection) => collection.get(id),
          novel: (collection) => collection.get(id),
        );
  }

  @override
  Stream<Media?> getMediaByIdAsStream(GetMediaByIdAsStreamParams params) {
    final category = params.category;
    final id = params.id;

    return _dataBase.mediaCollection(category).watchObject(id);
  }

  @override
  Future<Media?> getMediaByUrlAndSourceId(
      GetMediaByUrlAndSourceIdParams params) {
    final category = params.category;
    final url = params.url;
    final sourceId = params.sourceId;

    return _dataBase
        .mediaCollection(category)
        .when(
            video: (collection) =>
                collection.filter().urlEqualTo(url).sourceIdEqualTo(sourceId),
            manga: (collection) =>
                collection.filter().urlEqualTo(url).sourceIdEqualTo(sourceId),
            novel: (collection) =>
                collection.filter().urlEqualTo(url).sourceIdEqualTo(sourceId))
        .findFirst();
  }

  @override
  Future<int> insertMedia(InsertMediaParams params) {
    return _dataBase
        .writeInTransaction(() => _dataBase.insertMedia(params.media));
  }

  @override
  Future<int> updateMedia(UpdateMediaParams params) async {
    final media = params.media;
    return _dataBase.writeInTransaction(() => _dataBase.updateMedia(media));
  }

  @override
  Future<int> updateMediaFromSource(UpdateMediaFromSourceParams params) {
    final networkMedia = params.networkMedia;
    final localMedia = params.localMedia;

    final poster = networkMedia.poster?.takeIf((it) => it.isNotEmptyOrNull) ??
        localMedia.poster;

    final url =
        networkMedia.url.takeIf((it) => it.isNotEmpty) ?? localMedia.url;

    final title =
        networkMedia.title.takeIf((it) => it.isNotEmpty) ?? localMedia.title;

    final status = networkMedia.status?.takeIf((it) => it != Status.unknown) ??
        localMedia.status;

    localMedia
      ..title = title
      ..poster = poster
      ..banner = networkMedia.banner
      ..description = networkMedia.description
      ..genres = networkMedia.genres
      ..otherTitles = networkMedia.otherTitles
      ..score = networkMedia.score
      ..status = status
      ..format = networkMedia.format
      ..url = url
      ..initalized = true;

    return updateMedia(UpdateMediaParams(media: localMedia));
  }
}
