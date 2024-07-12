import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:meiyou/domain/category/model/category.dart';
import 'package:meiyou/domain/category/repositories/category_repository.dart';
import 'package:meiyou/presentation/category/category_list_item.dart';
import 'package:meiyou/presentation/core/dilog_box/alert_dialog_box.dart';
import 'package:meiyou/presentation/core/dilog_box/text_field_dialog.dart';
import 'package:meiyou/presentation/core/emoicon_widget.dart';
import 'package:meiyou/presentation/core/floating_action_button.dart';
import 'package:nice_dart/nice_dart.dart';

class CategoryAnimatedList extends StatefulWidget {
  final int type;
  final CategoryService service;
  const CategoryAnimatedList({
    super.key,
    required this.type,
    required this.service,
  });

  @override
  State<CategoryAnimatedList> createState() => _CategoryAnimatedListState();
}

class CategoryService extends ChangeNotifier {
  List<Category> categories;
  final CategoryRepository categoryRepository;
  final GlobalKey<AnimatedListState> listKey;

  CategoryService({
    required this.categories,
    required this.categoryRepository,
    required this.listKey,
  });

  Future<void> addCategory(Category category) async {
    final newCategory = await categoryRepository.addCategory(category);
    final index = categories.length;

    categories.insert(index, newCategory);

    if (index == 0) {
      notifyListeners();
      return;
    }

    listKey.currentState!.insertItem(
      index,
      duration: const Duration(milliseconds: 300),
    );
  }

  Future<void> deleteCategory(Category category,
      {required Widget Function(BuildContext, Category, Animation<double>)
          deleteBuilder}) async {
    final index = categories
        .indexWhere((e) => e.id == category.id || e.name == category.name);
    categories.removeAt(index);
    listKey.currentState!.removeItem(
      index,
      (context, animation) {
        return deleteBuilder(context, category, animation);
      },
      duration: const Duration(milliseconds: 300),
    );
  }

  Future<void> editCategory(Category category) async {
    final newCategory = await categoryRepository.updateCategory(category);
    final index = findIndexById(category.id);
    categories[index] = newCategory;
    notifyListeners();
  }

  Future<void> changeCategoryVisibility(Category category) async {
    final newCategory =
        await categoryRepository.toggleCategoryVisibility(category);
    final index = findIndexById(category.id);
    categories[index] = newCategory;
    notifyListeners();
  }

  Future<void> moveCategory(Category category, MoveTo moveTo) async {
    final newSortedList = await categoryRepository.moveCategory(
      category: category,
      moveTo: moveTo,
    );
    categories = newSortedList;
    notifyListeners();
  }

  int findIndexById(int id) {
    return categories.indexWhere((e) => e.id == id);
  }
}

class _CategoryAnimatedListState extends State<CategoryAnimatedList> {
  CategoryService get service => widget.service;

  late List<Category> categories;

  @override
  void initState() {
    super.initState();
    categories = service.categories;
    service.addListener(() {
      setState(() {
        categories = service.categories;
      });
    });
  }

  @override
  void dispose() {
    service.dispose();
    super.dispose();
  }

  Widget deleteItemBuilder(
      BuildContext context, Category category, Animation<double> animation) {
    return SizeTransition(
      sizeFactor: animation,
      child: CategoryListItem(
        category: category,
        moveDownEnabled: false,
        moveUpEnabled: false,
        onMoveup: (category) {},
        onMoveDown: (category) {},
        onToggleVisibility: (category) {},
        onEdit: (category) {},
        onDelete: (category) {},
      ),
    );
  }

  Widget itemBuilder(
      List<Category> categories, int index, Animation<double> animation) {
    final onMoveUpEnabled = index != 0;
    final onMoveDownEnabled = index != categories.lastIndex;

    final child = SizeTransition(
      key: ValueKey(categories[index].order),
      sizeFactor: animation,
      child: CategoryListItem(
        category: categories[index],
        moveDownEnabled: onMoveDownEnabled,
        moveUpEnabled: onMoveUpEnabled,
        onMoveup: (category) {
          onMoveUp(category);
        },
        onMoveDown: (category) {
          onMoveDown(category);
        },
        onToggleVisibility: (category) {
          onVisibility(category);
        },
        onEdit: (category) {
          onEdit(category);
        },
        onDelete: (category) {
          onDelete(category);
        },
      ),
    );

    return child;
  }

  String? nameValidator(String text) {
    if (categories.any((e) => e.name == text)) {
      return 'A category with this name already exists!';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final body = (categories.isEmpty)
        ? const Center(
            child: EmoticonsWidget(
                text:
                    'you have no categories yet. Tap the add button to create one for organizing your library.'),
          )
        : AnimatedList(
            key: service.listKey,
            initialItemCount: categories.length,
            padding: const EdgeInsets.fromLTRB(18, 40, 18, 40),
            itemBuilder: (context, index, animation) {
              return itemBuilder(categories, index, animation);
            },
          );
    return Scaffold(
      primary: false,
      floatingActionButton: OkFloatActionButton(
        title: 'Add',
        icon: Icons.add,
        heroTag: 'add_category',
        onTap: () {
          onAddCategory();
        },
      ),
      body: body,
    );
  }

  void onAddCategory() {
    return showAddCategoryDialog();
  }

  void onMoveUp(Category category) {
    service.moveCategory(category, MoveTo.Up);
  }

  void onMoveDown(Category category) {
    service.moveCategory(category, MoveTo.Down);
  }

  void onDelete(Category category) {
    showDeleteCategoryDialog(category);
  }

  void onEdit(Category category) {
    showEditCategoryDialog(category);
  }

  void onVisibility(Category category) {
    service.changeCategoryVisibility(category);
  }

  void showDeleteCategoryDialog(Category category) {
    showAdaptiveDialog(
      context: context,
      builder: (_) {
        return CustomAlertDialog(
          title: 'Delete Category',
          content:
              Text('Do you wish to delete the category "${category.name}"?'),
          actions: [
            TextButton(
              onPressed: () {
                service.deleteCategory(category,
                    deleteBuilder: deleteItemBuilder);
                context.pop();
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  void showAddCategoryDialog() {
    enterCategoryNamedDialog(
      onSubmitted: (value) {
        service.addCategory(
          Category(
            name: value,
            order: categories.length,
            type: widget.type,
            hidden: false,
          ),
        );
      },
    );
  }

  void showEditCategoryDialog(Category category) {
    enterCategoryNamedDialog(
      text: category.name,
      onSubmitted: (value) {
        service.editCategory(category.copyWith(name: value));
      },
    );
  }

  void enterCategoryNamedDialog({
    required void Function(String) onSubmitted,
    String? text,
  }) {
    showAdaptiveDialog(
      context: context,
      builder: (_) {
        return TextFieldDialog(
          autoFocus: true,
          title: 'Add Category',
          text: text,
          submitButtonText: 'Add',
          validator: nameValidator,
          onSubmitted: (value) {
            onSubmitted(value);
            Navigator.of(context).pop();
          },
        );
      },
    );
  }
}
