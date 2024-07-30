import 'package:flutter/foundation.dart' hide Category;
import 'package:isar/isar.dart';
import 'package:meiyou/shared/domain/models/category.dart';
import 'package:meiyou/shared/domain/models/extension_category.dart';
import 'package:meiyou/shared/domain/models/media.dart';
import 'package:meiyou/shared/domain/models/media_content.dart';
import 'package:nice_dart/nice_dart.dart';

class DataBase {
  final Isar _isar;

  DataBase._(this._isar);

  static DataBase open(String directory) {
    final isar = Isar.openSync(
      [
        VideoCategorySchema,
        MangaCategorySchema,
        NovelCategorySchema,
        VideoMediaSchema,
        MangaMediaSchema,
        NovelMediaSchema,
        VideoContentSchema,
        MangaContentSchema,
        NovelContentSchema,
      ],
      directory: directory,
      inspector: kDebugMode,
    );

    return DataBase._(isar);
  }

  IsarCollection<Media> mediaCollection(ExtensionCategory category) {
    switch (category) {
      case ExtensionCategory.video:
        return _isar.videoMedias;
      case ExtensionCategory.manga:
        return _isar.mangaMedias;
      case ExtensionCategory.novel:
        return _isar.novelMedias;
    }
  }

  Future<int> insertMedia(Media media) {
    return _putMedia(media);
  }

  Future<int> updateMedia(Media media) {
    return _putMedia(media);
  }

  Future<int> _putMedia(Media media) => media.when(
        video: (video) => _isar.videoMedias.put(video),
        manga: (manga) => _isar.mangaMedias.put(manga),
        novel: (novel) => _isar.novelMedias.put(novel),
      );

  Future<bool> deleteMedia(Media media) => media.when(
        video: (video) => _isar.videoMedias.delete(video.id),
        manga: (manga) => _isar.mangaMedias.delete(manga.id),
        novel: (novel) => _isar.novelMedias.delete(novel.id),
      );

  IsarCollection<MediaContent> mediaContentCollection(
      ExtensionCategory category) {
    return category.when(
      video: () => _isar.videoContents,
      manga: () => _isar.mangaContents,
      novel: () => _isar.novelContents,
    );
  }

  Future<int> insertMediaContent(MediaContent mediaContent) {
    return _putMediaContent(mediaContent);
  }

  Future<List<int>> insertAllMediaContent(List<MediaContent> mediaContent) {
    return _putAllMediaContent(mediaContent);
  }

  Future<int> updateMediaContent(MediaContent mediaContent) {
    return _putMediaContent(mediaContent);
  }

  Future<List<int>> updateAllMediaContent(List<MediaContent> mediaContent) {
    return _putAllMediaContent(mediaContent);
  }

  Future<int> _putMediaContent(MediaContent mediaContent) => mediaContent.when(
        video: (video) => _isar.videoContents.put(video),
        manga: (manga) => _isar.mangaContents.put(manga),
        novel: (novel) => _isar.novelContents.put(novel),
      );

  Future<List<int>> _putAllMediaContent(List<MediaContent> mediaContent) =>
      mediaContent.when(
        video: (video) => _isar.videoContents.putAll(video),
        manga: (manga) => _isar.mangaContents.putAll(manga),
        novel: (novel) => _isar.novelContents.putAll(novel),
      );

  Future<bool> deleteMediaContent(MediaContent mediaContent) =>
      mediaContent.when(
        video: (video) => _isar.videoContents.delete(video.id),
        manga: (manga) => _isar.mangaContents.delete(manga.id),
        novel: (novel) => _isar.novelContents.delete(novel.id),
      );

  Future<int> deleteAllMediaContent(List<MediaContent> mediaContent) =>
      mediaContent.when(
        video: (videoContentList) => _isar.videoContents
            .deleteAll(videoContentList.mapList((e) => e.id)),
        manga: (mangaContentList) => _isar.mangaContents
            .deleteAll(mangaContentList.mapList((e) => e.id)),
        novel: (novelContentList) => _isar.novelContents
            .deleteAll(novelContentList.mapList((e) => e.id)),
      );

  IsarCollection<Category> categoryCollection(ExtensionCategory category) {
    return category.when(
      video: () => _isar.videoCategorys,
      manga: () => _isar.mangaCategorys,
      novel: () => _isar.novelCategorys,
    );
  }

  Future<int> insertCategory(Category category) {
    return _putCategory(category);
  }

  Future<int> updateCategory(Category category) {
    return _putCategory(category);
  }

  Future<int> _putCategory(Category category) => category.when(
        video: (video) => _isar.videoCategorys.put(video),
        manga: (manga) => _isar.mangaCategorys.put(manga),
        novel: (novel) => _isar.novelCategorys.put(novel),
      );

  Future<bool> deleteCategory(Category category) => category.when(
        video: (video) => _isar.videoCategorys.delete(video.id),
        manga: (manga) => _isar.mangaCategorys.delete(manga.id),
        novel: (novel) => _isar.novelCategorys.delete(novel.id),
      );

  Future<T> writeInTransaction<T>(Future<T> Function() callback) {
    return _isar.writeTxn(() async {
      return await callback();
    });
  }
}

extension WhenIsarCollectionMedia on IsarCollection<Media> {
  T when<T>({
    required T Function(IsarCollection<VideoMedia>) video,
    required T Function(IsarCollection<MangaMedia>) manga,
    required T Function(IsarCollection<NovelMedia>) novel,
  }) {
    if (this is IsarCollection<VideoMedia>) {
      return video(this as IsarCollection<VideoMedia>);
    } else if (this is IsarCollection<MangaMedia>) {
      return manga(this as IsarCollection<MangaMedia>);
    } else if (this is IsarCollection<NovelMedia>) {
      return novel(this as IsarCollection<NovelMedia>);
    } else {
      throw Exception('Invalid type');
    }
  }
}

extension WhenIsarCollectionMediaContent on IsarCollection<MediaContent> {
  T when<T>({
    required T Function(IsarCollection<VideoContent>) video,
    required T Function(IsarCollection<MangaContent>) manga,
    required T Function(IsarCollection<NovelContent>) novel,
  }) {
    if (this is IsarCollection<VideoContent>) {
      return video(this as IsarCollection<VideoContent>);
    } else if (this is IsarCollection<MangaContent>) {
      return manga(this as IsarCollection<MangaContent>);
    } else if (this is IsarCollection<NovelContent>) {
      return novel(this as IsarCollection<NovelContent>);
    } else {
      throw Exception('Invalid type');
    }
  }
}

extension WhenIsarCollectionCategory on IsarCollection<Category> {
  T when<T>({
    required T Function(IsarCollection<VideoCategory>) video,
    required T Function(IsarCollection<MangaCategory>) manga,
    required T Function(IsarCollection<NovelCategory>) novel,
  }) {
    if (this is IsarCollection<VideoCategory>) {
      return video(this as IsarCollection<VideoCategory>);
    } else if (this is IsarCollection<MangaCategory>) {
      return manga(this as IsarCollection<MangaCategory>);
    } else if (this is IsarCollection<NovelCategory>) {
      return novel(this as IsarCollection<NovelCategory>);
    } else {
      throw Exception('Invalid type');
    }
  }
}

extension on List<MediaContent> {
  when<T>({
    required T Function(List<VideoContent>) video,
    required T Function(List<MangaContent>) manga,
    required T Function(List<NovelContent>) novel,
  }) {
    if (every((element) => element is VideoContent)) {
      return video(cast());
    } else if (every((element) => element is MangaContent)) {
      return manga(cast());
    } else if (every((element) => element is NovelContent)) {
      return novel(cast());
    } else {
      throw Exception('Invalid type');
    }
  }
}
