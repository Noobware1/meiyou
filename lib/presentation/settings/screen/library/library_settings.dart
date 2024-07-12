import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:meiyou/core/config/routes/routes.dart';
import 'package:meiyou/core/utils/resources/get_it/get_it.dart';
import 'package:meiyou/domain/library/library_preferences.dart';
import 'package:meiyou/domain/ui/ui_preferences.dart';
import 'package:meiyou/presentation/core/dilog_box/list_dilog_box.dart';
import 'package:meiyou/presentation/core/section.dart';

import 'package:meiyou/presentation/core/switch_list_tile.dart';
import 'package:meiyou_extensions_lib/preference.dart';

extension<T> on Preference<T> {
  Widget toStreamBuilder(
    Widget Function(BuildContext, T?) builder,
  ) {
    return StreamBuilder(
        initialData: get(),
        stream: changes(),
        builder: (context, snapshot) => builder(context, snapshot.data));
  }
}

class LibrarySettings extends StatelessWidget {
  const LibrarySettings({super.key});

  @override
  Widget build(BuildContext context) {
    final LibraryPreferences libraryPreferences = getIt.get();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Library'),
      ),
      body: ListView(
        children: [
          Section(title: 'Categories', children: [
            categorySetting(
                context,
                'video',
                libraryPreferences.videoLibraryCategories(),
                libraryPreferences.defaultVideoLibraryCategory()),
            categorySetting(
                context,
                'manga',
                libraryPreferences.mangaLibraryCategories(),
                libraryPreferences.defaultMangaLibraryCategory()),
            categorySetting(
                context,
                'novel',
                libraryPreferences.novelLibraryCategories(),
                libraryPreferences.defaultNovelLibraryCategory()),
          ])
        ],
      ),
    );
  }

  static const names = ['video', 'manga', 'novel'];

  Widget categorySetting(
    BuildContext context,
    String name,
    Preference<List<String>> categoriesPref,
    Preference<int> defaultCategoryPref,
  ) {
    return categoriesPref.toStreamBuilder((_, categories) {
      final len = categories!.length;
      return Column(children: [
        tile(
          title: 'Edit $name categories',
          subtitle: '$len ${len == 1 ? 'category' : 'categories'}',
          onTap: () {
            context.goToEditCategories(names.indexOf(name));
          },
        ),
        defaultCategoryPref.toStreamBuilder((context, index) {
          final String deaultCategory =
              (index == -1) ? 'Always ask' : categories[index!];
          final title = 'Default $name category';
          return tile(
            title: title,
            subtitle: deaultCategory,
            onTap: () {
              showAdaptiveDialog(
                  context: context,
                  builder: (_) {
                    return ListDialogBox(
                        title: title,
                        showCancelButton: true,
                        items: ['Always ask', ...categories],
                        onItemSelected: (context, index) {
                          defaultCategoryPref.set(index - 1);
                          context.pop();
                        });
                  });
            },
          );
        })
      ]);
    });
  }

  Widget tile(
      {required String title,
      required String subtitle,
      required VoidCallback onTap}) {
    return ListTile(
      title: Text(title),
      subtitle: Text(subtitle),
      onTap: onTap,
    );
  }

  Widget switchTile(
      {required String title,
      required String subtitle,
      required bool value,
      required void Function(bool) onChanged}) {
    return CustomSwitchListTile(
      onChanged: onChanged,
      value: value,
      title: title,
      subtitleText: subtitle,
    );
  }
}
