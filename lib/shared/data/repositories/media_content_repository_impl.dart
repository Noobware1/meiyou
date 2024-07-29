import 'dart:async';

import 'package:collection/collection.dart';
import 'package:isar/isar.dart';
import 'package:meiyou/core/data_base/data_base.dart';
import 'package:meiyou/shared/domain/models/media.dart';
import 'package:meiyou/shared/domain/models/media_content.dart';
import 'package:meiyou/shared/domain/models/repositories_params/media_content_repository_params.dart';
import 'package:meiyou/shared/domain/repositories/media_content_repository.dart';
import 'package:meiyou_extensions_lib/models.dart';
import 'package:nice_dart/nice_dart.dart';

class MediaContentRepositoryImpl implements MediaContentRepository {
  final DataBase _dataBase;

  MediaContentRepositoryImpl(this._dataBase);

  List<MediaContent> mapContentList(MapContentListParams params) {
    final contentList = params.contentList;
    final category = params.category;
    final mediaId = params.mediaId;

    return contentList.mapListIndexed(
      (index, content) => MediaContent(
        category: category,
        mediaId: mediaId,
        sourceOrder: index,
        name: content.name,
        number: content.number ?? index + 1,
        description: content.description,
        season: content.season ?? -1,
        isFiller: content.isFiller ?? false,
        image: content.image,
        url: content.url,
        seen: false,
        lastSecondsSeen: 0,
        totalSeconds: 0,
      ),
    );
  }

  Future<List<MediaContent>> syncContentListWithSource(
    Media media,
    List<IMediaContent> contentList,
  ) async {
    final mediaId = media.id;
    final category = media.category;
    // final mappedContentList =
    //     contentList.mapListIndexed((index, content) => );
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
      // await insertAllContent(InsertAllContentParams(content: newContentList));

      return [];
    }

    return _dataBase.writeInTransaction(() async {
      await _dataBase.deleteAllMediaContent(removedContentList);
      await _dataBase.insertAllMediaContent(newContentList);
      await _dataBase.updateAllMediaContent(updatedContentList);
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
              collection.filter().mediaIdEqualTo(mediaId).watch(),
          manga: (collection) =>
              collection.filter().mediaIdEqualTo(mediaId).watch(),
          novel: (collection) =>
              collection.filter().mediaIdEqualTo(mediaId).watch(),
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

    return _dataBase.insertMediaContent(content);
  }

  Future<List<MediaContent>> insertAllContent(InsertAllContentParams params) {
    final content = params.content;

    return content.asyncMap((content) async {
      final id = await _dataBase.insertMediaContent(content);
      return content.copyWith(id: id);
    });
  }

  @override
  Future<int> updateContent(UpdateContentParams params) {
    final content = params.content;
    return _dataBase.updateMediaContent(content);
  }
}

extension<T> on List<T> {
  Future<List<R>> asyncMap<R>(FutureOr<R> Function(T) f) async {
    return [for (var element in this) await f(element)];
  }
}
