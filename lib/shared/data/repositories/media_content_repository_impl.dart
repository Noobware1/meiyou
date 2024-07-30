import 'dart:async';

import 'package:collection/collection.dart';
import 'package:isar/isar.dart';
import 'package:meiyou/core/data_base/data_base.dart';
import 'package:meiyou/core/utils/exceptions/no_content_exception.dart';
import 'package:meiyou/shared/domain/models/media.dart';
import 'package:meiyou/shared/domain/models/media_content.dart';
import 'package:meiyou/shared/domain/models/repositories_params/media_content_repository_params.dart';
import 'package:meiyou/shared/domain/repositories/media_content_repository.dart';
import 'package:meiyou_extensions_lib/models.dart';
import 'package:nice_dart/nice_dart.dart';

class MediaContentRepositoryImpl implements MediaContentRepository {
  final DataBase _dataBase;

  MediaContentRepositoryImpl(this._dataBase);

  @override
  Future<List<MediaContent>> syncContentListWithSource(
    SyncContentListWithSourceParams params,
  ) async {
    final media = params.media;
    final contentList = params.contentList;

    if (contentList.isEmpty) {
      throw const NoContentException();
    }

    final mediaId = media.id;
    final category = media.category;

    final contentListDB = getContentListByMediaId(
        GetContentListByMediaIdParams(mediaId: mediaId, category: category));

    final List<MediaContent> newContentList = [];
    final List<MediaContent> updatedContentList = [];
    final List<MediaContent> removedContentList = contentListDB
        .whereNot((content) => contentList
            .any((sourceContent) => sourceContent.url == content.url))
        .toList();

    for (var i = 0; i < contentList.length; i++) {
      var sourceContent = contentList[i];
      var content = MediaContent(
        mediaId: mediaId,
        category: category,
        number: sourceContent.number ?? i + 1,
        sourceOrder: i,
        name: sourceContent.name,
        url: sourceContent.url,
        image: sourceContent.image,
        description: sourceContent.description,
        season: sourceContent.season ?? -1,
        isFiller: sourceContent.isFiller ?? false,
        totalSeconds: 0,
        lastSecondsSeen: 0,
        seen: false,
      );

      final contentDB = contentListDB
          .firstWhereOrNull((element) => element.url == content.url);

      if (contentDB == null) {
        newContentList.add(content);
      } else {
        updatedContentList.add(contentDB.copyWith(
          number: content.number,
          description: content.description,
          name: content.name,
          image: content.image,
          season: content.season,
          isFiller: content.isFiller,
          sourceOrder: content.sourceOrder,
        ));
      }
    }

    if (newContentList.isEmpty &&
        updatedContentList.isEmpty &&
        removedContentList.isEmpty) {
      return [];
    }

    return _dataBase.writeInTransaction(() async {
      if (removedContentList.isNotEmpty) {
        await _dataBase.deleteAllMediaContent(removedContentList);
      }
      if (updatedContentList.isNotEmpty) {
        await _dataBase.updateAllMediaContent(updatedContentList);
      }
      if (newContentList.isNotEmpty) {
        await _dataBase.insertAllMediaContent(newContentList);
      }
      return newContentList + updatedContentList;
    });
  }

  @override
  List<MediaContent> getContentListByMediaId(
      GetContentListByMediaIdParams params) {
    final mediaId = params.mediaId;
    final category = params.category;

    return _dataBase.mediaContentCollection(category).when(
          video: (collection) =>
              collection.filter().mediaIdEqualTo(mediaId).findAllSync(),
          manga: (collection) =>
              collection.filter().mediaIdEqualTo(mediaId).findAllSync(),
          novel: (collection) =>
              collection.filter().mediaIdEqualTo(mediaId).findAllSync(),
        );
  }

  @override
  Stream<List<MediaContent>> getContentListByMediaIdAsStream(
      GetContentListByMediaIdAsStreamParams params) {
    final mediaId = params.mediaId;
    final category = params.category;

    return _dataBase.mediaContentCollection(category).when(
          video: (collection) =>
              collection.filter().mediaIdEqualTo(mediaId).build().watch(),
          manga: (collection) =>
              collection.filter().mediaIdEqualTo(mediaId).build().watch(),
          novel: (collection) =>
              collection.filter().mediaIdEqualTo(mediaId).build().watch(),
        );
  }

  @override
  MediaContent? getContentById(GetContentByIdParams params) {
    final mediaId = params.id;
    final category = params.category;

    return _dataBase.mediaContentCollection(category).when(
          video: (collection) =>
              collection.filter().mediaIdEqualTo(mediaId).findFirstSync(),
          manga: (collection) =>
              collection.filter().mediaIdEqualTo(mediaId).findFirstSync(),
          novel: (collection) =>
              collection.filter().mediaIdEqualTo(mediaId).findFirstSync(),
        );
  }

  @override
  Future<int> insertContent(InsertContentParams params) {
    final content = params.content;

    return _dataBase
        .writeInTransaction(() => _dataBase.insertMediaContent(content));
  }

  @override
  Future<List<MediaContent>> insertAllContent(InsertAllContentParams params) {
    final content = params.content;

    return _dataBase
        .writeInTransaction(() async => await content.asyncMap((content) async {
              final id = await _dataBase.insertMediaContent(content);
              return content.copyWith(id: id);
            }));
  }

  @override
  Future<int> updateContent(UpdateContentParams params) {
    final content = params.content;
    return _dataBase
        .writeInTransaction(() => _dataBase.updateMediaContent(content));
  }
}

extension<T> on List<T> {
  Future<List<R>> asyncMap<R>(FutureOr<R> Function(T) f) async {
    return [for (var element in this) await f(element)];
  }
}
