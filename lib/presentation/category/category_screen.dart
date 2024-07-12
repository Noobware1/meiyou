import 'package:flutter/material.dart';
import 'package:meiyou/core/utils/resources/get_it/get_it.dart';
import 'package:meiyou/domain/category/repositories/category_repository.dart';
import 'package:meiyou/extension/models/entension_type.dart';
import 'package:meiyou/presentation/category/category_tab.dart';
import 'package:nice_dart/nice_dart.dart';

class CategoryScreen extends StatefulWidget {
  final int initialIndex;
  const CategoryScreen({super.key, required this.initialIndex});

  @override
  State<CategoryScreen> createState() => _EditCategoriesState();
}

class _EditCategoriesState extends State<CategoryScreen>
    with SingleTickerProviderStateMixin {
  late final TabController tabController;
  late final CategoryRepository categoryRepository;
  late final List<CategoryService> services;
  late final List<GlobalKey<AnimatedListState>> keys;

  @override
  void initState() {
    super.initState();
    tabController = TabController(
        length: 3, vsync: this, initialIndex: widget.initialIndex);
    
    categoryRepository = getIt.get();

    services = ExtensionType.values
        .map((e) => CategoryService(
              categories: categoryRepository.getAllCategoriesForType(e),
              categoryRepository: categoryRepository,
              listKey: keys[e.index],
            ))
        .toList();

    keys = [
      GlobalKey<AnimatedListState>(),
      GlobalKey<AnimatedListState>(),
      GlobalKey<AnimatedListState>(),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text('Categories'),
        bottom: TabBar(
          controller: tabController,
          tabs: const [
            Tab(text: 'Video'),
            Tab(text: 'Manga'),
            Tab(text: 'Novel'),
          ],
        ),
      ),
      body: TabBarView(
        controller: tabController,
        children: [0, 1, 2].mapList((e) => CategoryAnimatedList(
              type: e,
              service: services[e],
            )),
      ),
    );
  }
}
