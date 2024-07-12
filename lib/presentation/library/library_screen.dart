import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:meiyou/core/config/routes/routes.dart';

import 'package:meiyou/core/constants/size_constants.dart';
import 'package:meiyou/core/utils/extensions/context.dart';
import 'package:meiyou/core/utils/resources/get_it/get_it.dart';
import 'package:meiyou/domain/library/models/library_item.dart';
import 'package:meiyou/domain/library/library_preferences.dart';
import 'package:meiyou/domain/library/library_repository.dart';
import 'package:meiyou/extension/models/entension_type.dart';
import 'package:meiyou/presentation/core/dilog_box/alert_dialog_box.dart';
import 'package:meiyou/presentation/core/dilog_box/list_dilog_box.dart';
import 'package:meiyou/presentation/core/floating_action_button.dart';
import 'package:meiyou/presentation/core/poster_holder.dart';
import 'package:meiyou/presentation/home/source_selector/selected_source.dart';
import 'package:meiyou_extensions_lib/models.dart';
import 'package:nice_dart/nice_dart.dart';
import 'package:path/path.dart';

class LibraryScreen extends StatefulWidget {
  const LibraryScreen({super.key});

  @override
  State<LibraryScreen> createState() => _LibraryScreenState();
}

class _LibraryScreenState extends State<LibraryScreen> {
  late ExtensionType selectedType;
  late List<String> categories;
  @override
  void initState() {
    super.initState();

    getIt.get<LibraryPreferences>().let((it) {
      selectedType = it.lastUsedExtensionType().get();
      categories = it.getLibraryCategories(selectedType).get();
    });
  }

  @override
  // ignore: unnecessary_overrides
  BuildContext get context => super.context;

  Widget gridView(List<ContentItem> data, void Function(int) onLongPress) {
    const defaultCornerPadding = EdgeInsets.only(left: 10, right: 10);
    // final padding = context.padding(minimum: defaultCornerPadding);
    final width = context.width;
    final crossAxisCount = run(() {
      final totalWidth =
          (width - defaultCornerPadding.left + defaultCornerPadding.right);
      final count = totalWidth ~/ defaultPosterWidthMobile;
      if (count <= 1) return 1;
      final space = (count - 1) * 5;
      return (totalWidth + space) ~/ defaultPosterWidthMobile;
    });
    return GridView.builder(
      padding: defaultCornerPadding,
      shrinkWrap: true,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: crossAxisCount,
          mainAxisExtent: defaultPosterHeightMobile + 62,
          crossAxisSpacing: 5,
          mainAxisSpacing: 10),
      itemCount: data.length,
      itemBuilder: (context, index) {
        return ClickablePosterHolder(
          onTap: () {
            context.goToInfoScreen(data[index]);
          },
          onLongPress: () {
            onLongPress(index);
          },
          holder: PosterHolderWithTitle(
            height: defaultPosterHeightMobile,
            width: defaultPosterWidthMobile,
            title: data[index].title,
            textStyle: PosterHolder.titleTextStyleMobile,
            // infoTextStyle: PosterHolder.infoTextStyleMobile,
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Library'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              context.goToSearchScreen();
            },
          ),
          IconButton(
            icon: const Icon(Icons.filter_alt_rounded),
            onPressed: () {},
          ),
        ],
        bottom: categories.isEmpty ? null : null,
      ),
      floatingActionButton: OkFloatActionButton(
        heroTag: 'libraryBtn',
        title: selectedType.toDisplayString(),
        onTap: () {
          showAdaptiveDialog(
              context: context,
              builder: (context) {
                return ListDialogBox(
                    title: 'Select Library',
                    selected: selectedType.index,
                    items: ExtensionType.values
                        .map((e) => e.toDisplayString())
                        .toList(),
                    onItemSelected: (_, index) {
                      selectedType = ExtensionType.values[index];
                      setState(() {
                        getIt.get<LibraryPreferences>().let((it) {
                          it.lastUsedExtensionType().let((it) {
                            it.set(selectedType);
                            selectedType = it.get();
                          });

                          categories =
                              it.getLibraryCategories(selectedType).get();
                        });
                        context.pop();
                      });
                    });
              });
        },
      ),
      body: StreamBuilder(
        stream: getIt.get<LibraryRepository>().getLibraryForType(selectedType),
        builder: (context, snapshot) {
          if (snapshot.data.isNotEmptyOrNull) {
            return gridView(
                snapshot.data!.mapList((e) => e.toContentItem()),
                (index) => showAdaptiveDialog(
                      context: context,
                      builder: (context) => CustomAlertDialog(
                        title: 'Are you sure?',
                        content: Text(
                            'you are about to remove "${snapshot.data![index].title}" from your library'),
                        actions: [
                          TextButton(
                              onPressed: () {
                                getIt
                                    .get<LibraryRepository>()
                                    .removeFromLibrary(snapshot.data![index]);
                                context.pop();
                              },
                              child: const Text('Remove'))
                        ],
                      ),
                    ));
          } else {
            return const SizedBox();
          }
        },
      ),
    );
  }
}

extension on ExtensionType {
  String toDisplayString() {
    switch (this) {
      case ExtensionType.Video:
        return 'Video Library';
      case ExtensionType.Manga:
        return 'Manga Library';
      case ExtensionType.Novel:
        return 'Novel Library';
    }
  }
}
