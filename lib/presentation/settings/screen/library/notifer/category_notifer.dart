import 'dart:async';

import 'package:meiyou/domain/category/model/category.dart';
import 'package:meiyou/domain/category/repositories/category_repository.dart';
import 'package:meiyou/extension/models/entension_type.dart';
import 'package:meiyou/notifers/state_notifer.dart';
import 'package:meiyou_extensions_lib/models.dart';

class CategoryState {
  final CategoryAction action;
  final Category? category;
  final List<Category> categories;

  CategoryState(this.action, this.category, this.categories);

  CategoryState.intial(List<Category> categories)
      : this(CategoryAction.Default, null, categories);
}

enum CategoryAction {
  Default,
  Add,
  Delete,
  Move,
  // MoveDown,
  Edit,
  ChangeVisibility,
}

class CategoryNotifer extends StateNotifer<CategoryState> {
  late final CategoryRepository repository;
  late final ExtensionType type;
  CategoryNotifer({
    required this.type,
    required this.repository,
  }) : super(CategoryState.intial(repository.getAllCategoriesForType(type)));

  void addCategory(Category category) {
    repository.addCategory(category).then((value) {
      setState(CategoryState(CategoryAction.Add, category, updatedCategories));
    });
  }

  void deleteCategory(Category category) {
    repository.deleteCategory(category).then((value) {
      setState(
          CategoryState(CategoryAction.Delete, category, updatedCategories));
    });
  }

  void categoryMoveUp(Category category) {
    repository
        .moveCategory(
      category: category,
      moveTo: MoveTo.Up,
    )
        .then((value) {
      setState(CategoryState(CategoryAction.Move, category, updatedCategories));
    });
  }

  void categoryMoveDown(Category category) {
    repository
        .moveCategory(
      category: category,
      moveTo: MoveTo.Down,
    )
        .then((value) {
      setState(CategoryState(CategoryAction.Move, category, updatedCategories));
    });
  }

  void editCategory(Category category) {
    repository.updateCategory(category).then((value) {
      setState(CategoryState(CategoryAction.Edit, category, updatedCategories));
    });
  }

  void changeCategoryVisibility(Category category) {
    repository.toggleCategoryVisibility(category).then((value) {
      setState(CategoryState(
        CategoryAction.ChangeVisibility,
        category,
        updatedCategories,
      ));
    });
  }

  List<Category> get updatedCategories =>
      repository.getAllCategoriesForType(type);

  @override
  FutureOr onDispose() {
    // TODO: implement onDispose
    return super.onDispose();
  }
}
