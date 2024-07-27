import 'package:flutter/foundation.dart' hide Category;
import 'package:isar/isar.dart';
import 'package:meiyou/shared/domain/models/category.dart';
import 'package:meiyou/shared/domain/models/extension_category.dart';
import 'package:meiyou/shared/domain/models/media.dart';

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

  Future<int> _putMedia(Media media) {
    return media.when(
      video: (video) => _isar.videoMedias.put(video),
      manga: (manga) => _isar.mangaMedias.put(manga),
      novel: (novel) => _isar.novelMedias.put(novel),
    );
  }

  Future<bool> deleteMedia(Media media) {
    return media.when(
      video: (video) => _isar.videoMedias.delete(video.id),
      manga: (manga) => _isar.mangaMedias.delete(manga.id),
      novel: (novel) => _isar.novelMedias.delete(novel.id),
    );
  }

  IsarCollection<Category> categories(ExtensionCategory category) {
    switch (category) {
      case ExtensionCategory.video:
        return _isar.videoCategorys;
      case ExtensionCategory.manga:
        return _isar.mangaCategorys;
      case ExtensionCategory.novel:
        return _isar.novelCategorys;
    }
  }

  Future<int> insertCategory(Category category) {
    return _putCategory(category);
  }

  Future<int> updateCategory(Category category) {
    return _putCategory(category);
  }

  Future<int> _putCategory(Category category) {
    return category.when(
      video: (video) => _isar.videoCategorys.put(video),
      manga: (manga) => _isar.mangaCategorys.put(manga),
      novel: (novel) => _isar.novelCategorys.put(novel),
    );
  }

  Future<bool> deleteCategory(Category category) {
    return category.when(
      video: (video) => _isar.videoCategorys.delete(video.id),
      manga: (manga) => _isar.mangaCategorys.delete(manga.id),
      novel: (novel) => _isar.novelCategorys.delete(novel.id),
    );
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
