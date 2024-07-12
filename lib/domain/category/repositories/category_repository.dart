import 'package:collection/collection.dart';
import 'package:isar/isar.dart';
import 'package:meiyou/core/database/database.dart';
import 'package:meiyou/core/utils/resources/flow.dart';
import 'package:meiyou/core/utils/resources/logger.dart';
import 'package:meiyou/domain/category/model/category.dart';
import 'package:meiyou/domain/library/library_preferences.dart';
import 'package:meiyou/extension/models/entension_type.dart';
import 'package:meiyou_extensions_lib/preference.dart';
import 'package:nice_dart/nice_dart.dart';
import 'package:synchronized/synchronized.dart';

class CategoryRepository {
  CategoryRepository(DataBase dataBase, LibraryPreferences libraryPreferences)
      : _dataBase = dataBase,
        _libraryPreferences = libraryPreferences;

  final DataBase _dataBase;
  final LibraryPreferences _libraryPreferences;

  List<Category> getAllCategoriesForType(ExtensionType type) {
    return _getAllCategoriesForTypeSorted(type).findAllSync();
  }

  Stream<List<Category>> watchAllCategoriesForType(ExtensionType type) {
    return _getAllCategoriesForTypeSorted(type).watch();
  }

  QueryBuilder<Category, Category, QAfterSortBy> _getAllCategoriesForTypeSorted(
      ExtensionType type) {
    return _dataBase.category.filter().typeEqualTo(type.index).sortByOrder();
  }

  Future<Category> addCategory(Category category) async {
    final pref = _libraryPreferences.getCategoriesPref(category.type);
    final names = pref.get()..add(category.name);
    final newCategory = await _dataBase.writeCategory(category);
    pref.set(names);
    return newCategory;
  }

  Future<Category> updateCategory(Category category) {
    return _dataBase.writeCategory(category);
  }

  Future<void> deleteCategory(Category category) async {
    final pref = _libraryPreferences.getCategoriesPref(category.type);
    final names = pref.get();
    final index = names.indexWhere((element) => element == category.name);
    await _dataBase.deleteCategory(category);
    pref.set(names..removeAt(index));
  }

  Future<void> deleteAllCategories(ExtensionType type) async {
    final pref = _libraryPreferences.getCategoriesPref(type.index);
    await _dataBase.deleteAllCategories(type.index);
    pref.set([]);
    // return getAllCategoriesForType(type);
  }

  Future<Category> toggleCategoryVisibility(Category category) {
    return _dataBase.writeCategory(category.copyWith(hidden: !category.hidden));
  }

  final _lock = Lock();

  Future<List<Category>> moveCategory({
    required Category category,
    required MoveTo moveTo,
  }) async {
    return await _lock.synchronized(() async {
      var categories =
          _getAllCategoriesForTypeSorted(ExtensionType.values[category.type])
              .findAllSync();

      final index = categories.indexWhere((e) => e.id == category.id);
      final newIndex = moveTo == MoveTo.Up ? index - 1 : index + 1;

      try {
        categories.swap(index, newIndex);
        categories = categories
            .mapListIndexed((index, element) => element.copyWith(order: index));
        print(categories.map((e) => e.name));

        return await _dataBase.writeCategories(categories);
      } catch (e, s) {
        logRat.logError('Error while trying to swap elements', e, s);
        rethrow;
      }
    });
  }
}

extension on LibraryPreferences {
  Preference<List<String>> getCategoriesPref(int type) {
    switch (type) {
      case 1:
        return mangaLibraryCategories();
      case 2:
        return novelLibraryCategories();
      default:
        return videoLibraryCategories();
    }
  }
}

// extension on List<Category> {
//   void swap(int currentIndex, int newIndex) {
//     final temp = this[currentIndex];
//     this[currentIndex] = this[newIndex];
//     this[newIndex] = temp;
//   }
// }

enum MoveTo {
  Up,
  Down,
}
