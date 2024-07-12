// import 'dart:async';
// import 'dart:math';

// import 'package:flutter/material.dart';
// import 'package:go_router/go_router.dart';
// import 'package:meiyou/core/utils/extensions/context.dart';
// import 'package:meiyou/core/utils/resources/flow.dart';
// import 'package:meiyou/core/utils/resources/get_it/get_it.dart';
// import 'package:meiyou/domain/category/model/category.dart';
// import 'package:meiyou/domain/category/repositories/category_repository.dart';
// import 'package:meiyou/domain/library/library_preferences.dart';
// import 'package:meiyou/extension/models/entension_type.dart';
// import 'package:meiyou/notifers/state_notifer.dart';
// import 'package:meiyou/presentation/core/dilog_box/alert_dialog_box.dart';
// import 'package:meiyou/presentation/core/dilog_box/text_field_dialog.dart';
// import 'package:meiyou/presentation/core/emoicon_widget.dart';
// import 'package:meiyou/presentation/core/floating_action_button.dart';
// import 'package:meiyou/presentation/core/space.dart';
// import 'package:meiyou/presentation/core/state_listenable_builder.dart';
// import 'package:meiyou/presentation/more/settings/library/notifer/category_notifer.dart';
// import 'package:meiyou_extensions_lib/preference.dart';
// import 'package:nice_dart/nice_dart.dart';

// class EditCategories extends StatefulWidget {
//   final int index;
//   const EditCategories({super.key, required this.index});

//   @override
//   State<EditCategories> createState() => _EditCategoriesState();
// }

// class _EditCategoriesState extends State<EditCategories>
//     with SingleTickerProviderStateMixin {
//   late final TabController tabController;
//   late final CategoryRepository categoryRepository;
//   late final List<GlobalKey<AnimatedListState>> keys;
//   late final List<CategoryService> services;

//   @override
//   void initState() {
//     super.initState();
//     tabController =
//         TabController(length: 3, vsync: this, initialIndex: widget.index);
//     categoryRepository = getIt.get();

//     keys = [
//       GlobalKey<AnimatedListState>(),
//       GlobalKey<AnimatedListState>(),
//       GlobalKey<AnimatedListState>(),
//     ];

//     services = ExtensionType.values
//         .map((e) => CategoryService(
//               categories: categoryRepository.getAllCategoriesForType(e),
//               categoryRepository: categoryRepository,
//               listKey: keys[e.index],
//             ))
//         .toList();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       resizeToAvoidBottomInset: false,
//       appBar: AppBar(
//         title: const Text('Categories'),
//         bottom: TabBar(
//           controller: tabController,
//           tabs: const [
//             Tab(text: 'Video'),
//             Tab(text: 'Manga'),
//             Tab(text: 'Novel'),
//           ],
//         ),
//       ),
//       body: TabBarView(
//         controller: tabController,
//         children: [0, 1, 2].mapList((e) => CategoryAnimatedList(
//               type: e,
//               service: services[e],
//             )),
//       ),
//     );
//   }
// }
