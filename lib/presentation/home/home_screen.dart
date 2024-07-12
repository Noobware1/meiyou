import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:meiyou/core/config/routes/routes.dart';
import 'package:meiyou/core/constants/font_size.dart';

import 'package:meiyou/core/utils/extensions/context.dart';
import 'package:meiyou/core/utils/resources/get_it/get_it.dart';
import 'package:meiyou/domain/library/models/library_item.dart';
import 'package:meiyou/domain/repositories/history_repository.dart';
import 'package:meiyou/domain/library/library_repository.dart';
import 'package:meiyou/extension/models/entension_type.dart';
import 'package:meiyou/notifers/async_notifer.dart';
import 'package:meiyou/presentation/core/default_sized_box.dart';
import 'package:meiyou/presentation/core/emoicon_widget.dart';
import 'package:meiyou/presentation/core/getIt_widget.dart';
import 'package:meiyou/presentation/core/space.dart';
import 'package:meiyou/presentation/home/banner/banner_view.dart';
import 'package:meiyou/presentation/home/homepage_row/homepage_row.dart';
import 'package:meiyou/presentation/home/services/home_screen_service.dart';
import 'package:meiyou/presentation/home/source_selector/selected_source.dart';
import 'package:meiyou/presentation/home/source_selector/source_selector_button.dart';
import 'package:meiyou/presentation/search/search_screen.dart';
import 'package:meiyou_extensions_lib/models.dart';
import 'package:nice_dart/nice_dart.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Source? source;
  late ExtensionType type;

  @override
  void initState() {
    super.initState();
    getIt.get<SelectedSource>().let<void>((it) {
      type = it.type;
      source = it.source;
    });
    getIt.registerSingleton(HomeScreenNotifer(source)).load(source);
  }

  @override
  void dispose() {
    getIt.unregister<HomeScreenNotifer>();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GetItListenableBuilder<HomeScreenNotifer,
        AsyncValue<HomeScreenData>>(builder: (context, state) {
      return Scaffold(
        extendBodyBehindAppBar: true,
        body: state.when(
          data: (data) => whenLoaded(context, data),
          loading: whenLoading,
          error: (error, stackTrace) {
            if (error is NoSourceSelected) {
              return whenNoSource();
            } else if (error is HomePageNotSupported) {
              return whenHomePageNotSupported();
            } else {
              return whenError(error);
            }
          },
        ),
        floatingActionButton: SourceSelectorButton(
          source: source,
          onSourceSelected: (type, source) {
            setState(() {
              this.type = type;
              this.source = source;

              getIt.get<HomeScreenNotifer>().load(source);
            });
          },
        ),
      );
    });
  }

  void onItemSelected(BuildContext context, ContentItem item) {
    context.goToInfoScreen(item);
  }

  Future<void> onAddToLibary(BuildContext context, ContentItem item) async {
    final repo = getIt.get<LibraryRepository>();
    final (LibraryItem libraryItem, bool isInLibrary) =
        repo.getFromLibrary(source!, type, item.title).let((it) => (
              it ??
                  LibraryItem(
                    sourceId: source!.id,
                    type: type,
                    title: item.title,
                    poster: item.poster,
                    url: item.url,
                  ),
              it != null
            ));

    if (isInLibrary) {
      await repo.removeFromLibrary(libraryItem);
    } else {
      await repo.addToLibary(libraryItem);
    }
  }

  Widget whenLoading() {
    return const Center(child: CircularProgressIndicator());
  }

  Widget whenLoaded(
      BuildContext context, Map<HomePageRequest, HomePage> homepages) {
    return SingleChildScrollView(
        child: ifMoreThanOneHomePage(context, homepages)
        // : ifOnlyOneHomePage(context, homepages),
        );
  }

  // Widget ifOnlyOneHomePage(
  //     BuildContext context, Map<HomePageRequest, HomePage> homepages) {
  //   return Column(children: [
  //     for (final entry in homepages.entries) ...[
  //       HomePageRow(
  //         request: entry.key,
  //         initialData: entry.value,
  //         onItemSelected: (selected) => onItemSelected(context, selected),
  //         onAddToLibrary: (selected) => onAddToLibary(context, selected),
  //       ),
  //       const VerticalSpace(20),
  //     ]
  //   ]);
  // }

  Widget ifMoreThanOneHomePage(
      BuildContext context, Map<HomePageRequest, HomePage> homepages) {
    return Column(children: [
      homepages.entries.first.let((it) {
        return Stack(
          alignment: Alignment.topCenter,
          children: [
            BannerView(
              request: it.key,
              homepage: it.value,
              onAddToLibrary: (selected) => onAddToLibary(context, selected),
              onItemSelected: (selected) => onItemSelected(context, selected),
              source: source!,
              type: type,
            ),
            Positioned(
              top: kToolbarHeight,
              right: 30,
              left: 30,
              child: GestureDetector(
                  onTap: () {
                    context.goToSearchScreen();
                  },
                  child: const OkSearchBarDummy()),
            )
          ],
        );
      }),
      const VerticalSpace(20),
      StreamBuilder(
          stream: getIt.get<HistoryRepository>().getContinue(source!.id, type),
          builder: (context, snapshot) {
            if (snapshot.hasData &&
                snapshot.data != null &&
                snapshot.data!.isNotEmpty) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 20),
                child: HomePageRow(
                  endlessScroll: false,
                  initialData: snapshot.data!,
                  onItemSelected: (selected) =>
                      onItemSelected(context, selected),
                  onAddToLibrary: (selected) =>
                      onAddToLibary(context, selected),
                ),
              );
            } else {
              return defaultSizedBox;
            }
          }),
      for (final entry in homepages.entries.skip(1)) ...[
        HomePageRow(
          request: entry.key,
          initialData: entry.value,
          onItemSelected: (selected) => onItemSelected(context, selected),
          onAddToLibrary: (selected) => onAddToLibary(context, selected),
        ),
        const VerticalSpace(20),
      ]
    ]);
  }

  Widget whenError(Object? error) {
    return Center(
      child: Text('Error: $error'),
    );
  }

  Widget whenNoSource() {
    return const EmoticonsWidget(text: 'No source selected');
  }

  Widget whenHomePageNotSupported() {
    return const Center(
      child: Text('HomePage is not supported for this source'),
    );
  }
}

extension on HomePage {
  bool get isNotEmpty {
    return data.isNotEmpty && data.every((element) => element.items.isNotEmpty);
  }
}
