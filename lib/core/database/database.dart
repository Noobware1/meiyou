import 'package:flutter/foundation.dart' hide Category;

import 'package:isar/isar.dart';
import 'package:meiyou/domain/category/model/category.dart';
import 'package:meiyou/domain/models/history.dart';
import 'package:meiyou/domain/library/models/library_item.dart';
import 'package:meiyou/domain/models/p.dart';
import 'package:meiyou/extension/models/entension_type.dart';
import 'package:meiyou_extensions_lib/models.dart';
import 'package:nice_dart/nice_dart.dart';

class DataBase {
  late final Isar isar;

  DataBase(String directory) {
    isar = Isar.openSync(
      [
        LibraryItemSchema,
        HistorySchema,
        CategorySchema,
        MovieProgressSchema,
        SeriesProgressSchema,
        AnimeProgressSchema,
      ],
      directory: directory,
      name: 'meiyou-db',
      inspector: kDebugMode,
    );
  }

  IsarCollection<LibraryItem> get library => isar.libraryItems;

  IsarCollection<History> get history => isar.historys;

  IsarCollection<Category> get category => isar.categorys;

  IsarCollection<MovieProgress> get movieProgress => isar.movieProgress;

  IsarCollection<SeriesProgress> get seriesProgress => isar.seriesProgress;

  IsarCollection<AnimeProgress> get animeProgress => isar.animeProgress;

  // Stream<List<LibraryItem>> get videoLibrary =>
  //     isar.libraryItems.filter().typeEqualTo(ExtensionType.Video).watch();

  // Stream<List<LibraryItem>> get mangaLibrary =>
  //     isar.libraryItems.filter().typeEqualTo(ExtensionType.Manga).watch();

  // Stream<List<LibraryItem>> get novelLibrary =>
  //     isar.libraryItems.filter().typeEqualTo(ExtensionType.Novel).watch();

  Future<void> addToLibary(LibraryItem item) {
    return isar.writeTxn(() async {
      await isar.libraryItems.put(item);
    });
  }

  Future<void> updateLibaryItem(LibraryItem item) {
    return addToLibary(item);
  }

  Future<void> removeFromLibrary(LibraryItem item) {
    return isar.writeTxn(() async {
      await isar.libraryItems.delete(item.id);
    });
  }

  Future<void> deleteHistory(History history) {
    return isar.writeTxn(() async {
      await isar.historys.delete(history.id);
    });
  }

  Future<void> deleteAll(ExtensionType type) {
    return isar.writeTxn(() async {
      await isar.historys.filter().typeEqualTo(type).deleteAll();
    });
  }

  void updateHistory(History history) {
    isar.writeTxn(() async {
      await isar.historys.put(history);
    });
  }

  LibraryItem? getFromLibrary(InfoPage infoPage, Source source) {
    return isar.libraryItems
        .filter()
        .titleEqualTo(infoPage.name)
        .sourceIdEqualTo(source.id)
        .findFirstSync();
  }

  Future<Category> writeCategory(
    Category category,
  ) {
    return isar.writeTxn(() async {
      final id = await this.category.put(category);
      return category.copyWith(id: id);
    });
  }

  Future<List<Category>> writeCategories(
    List<Category> categories,
  ) {
    return isar.writeTxn(() async {
      final ids = await category.putAll(categories);
      return categories
          .mapIndexed((index, it) => it.copyWith(id: ids[index]))
          .toList();
    });
  }

  Future<Category> deleteCategory(Category category) {
    return isar.writeTxn(() async {
      if (await this.category.delete(category.id)) {
        return category;
      }
      throw Exception('Failed to delete category');
    });
  }

  Future<List<Category>> deleteAllCategories(int type) async {
    return isar.writeTxn(() async {
      final query = category.filter().typeEqualTo(type);
      final categories = await query.findAll();
      final len = await query.deleteAll();
      if (categories.length == len) {
        return categories;
      }
      throw Exception('Failed to delete all categories');
    });
  }

  Future<void> writeProgress(ContentProgress progress) {
    return isar.writeTxn(() async {
      if (progress is MovieProgress) {
        await movieProgress.put(progress);
      } else if (progress is SeriesProgress) {
        await seriesProgress.put(progress);
      } else if (progress is AnimeProgress) {
        await animeProgress.put(progress);
      }
    });
  }

  // void close() {
  //   isar.close();
  // }
}
