import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:meiyou/core/config/routes/routes.dart';
import 'package:meiyou/core/constants/font_size.dart';
import 'package:meiyou/core/constants/size_constants.dart';
import 'package:meiyou/core/utils/extensions/context.dart';
import 'package:meiyou/core/utils/resources/get_it/get_it.dart';
import 'package:meiyou/domain/repositories/source_repository.dart';
// import 'package:meiyou/domain/models/source.dart';
import 'package:meiyou/extension/models/entension_type.dart';
import 'package:meiyou/notifers/async_notifer.dart';
import 'package:meiyou/notifers/state_notifer.dart';
import 'package:meiyou/presentation/core/emoicon_widget.dart';
import 'package:meiyou/presentation/core/floating_action_button.dart';
import 'package:meiyou/presentation/core/poster_holder.dart';
import 'package:meiyou/presentation/core/space.dart';
import 'package:meiyou/presentation/core/state_listenable_builder.dart';
import 'package:meiyou/presentation/home/source_selector/selected_source.dart';
import 'package:meiyou/presentation/search/notifer/search_page_notifer.dart';
import 'package:meiyou_extensions_lib/models.dart';
import 'package:nice_dart/nice_dart.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  late final SearchPageNotifer notifer;
  late final ScrollController scrollController;

  String query = '';
  int page = 1;

  @override
  void initState() {
    super.initState();
    notifer = SearchPageNotifer(
      getIt.get<SelectedSource>().source!,
      getIt.get<SourceRepository>(),
    );
    scrollController = ScrollController()..addListener(scrollListener);
  }

  void scrollListener() {
    if (scrollController.position.pixels ==
        scrollController.position.maxScrollExtent) {
      notifer.loadMore(page++, query, FilterList([]));
    }
  }

  @override
  void dispose() {
    notifer.dispose();
    scrollController.removeListener(scrollListener);
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          // elevation: 0,
          forceMaterialTransparency: true,
          title: const Text(
            'Search',
            style: TextStyle(fontWeight: FontWeight.bold),
          )),

      // extendBodyBehindAppBar: true,
      floatingActionButton: OkFloatActionButton(
        title: 'Filter',
        icon: Icons.filter_alt_rounded,
        heroTag: 'filterBtn',
        onTap: () {},
      ),

      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 20, right: 20),
            child: CustomSearchBar(onSearch: (query) {
              this.query = query;
              notifer.search(page, query, FilterList([]));
            }),
          ),
          const VerticalSpace(20),
          Expanded(
            child: StateListenableBuilder<AsyncValue<SearchPage>>(
                stateListenable: notifer,
                builder: (context, state, _) {
                  return state.when(
                      data: (data) {
                        if (data is SearchPageIntial) {
                          return whenInital();
                        } else {
                          return whenData(data);
                        }
                      },
                      error: (error, stack) {
                        return whenError(error);
                      },
                      loading: whenLoading);
                }),
          )
        ],
      ),
    );
  }

  Widget whenData(SearchPage data) {
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
      controller: scrollController,
      shrinkWrap: true,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: crossAxisCount,
          mainAxisExtent: defaultPosterHeightMobile + 62,
          crossAxisSpacing: 5,
          mainAxisSpacing: 10),
      itemCount: data.items.length,
      itemBuilder: (context, index) {
        return ClickablePosterHolder(
          onTap: () {
            context.goToInfoScreen(data.items[index]);
          },
          onLongPress: () {
            // if(getIt.get<LibraryPreferences>().getLibraryCategories(Extens))
          },
          holder: PosterHolderWithTitle(
            height: defaultPosterHeightMobile,
            width: defaultPosterWidthMobile,
            title: data.items[index].title,
            textStyle: PosterHolder.titleTextStyleMobile,
            // infoTextStyle: PosterHolder.infoTextStyleMobile,
          ),
        );
      },
    );
  }

  Widget whenInital() {
    return const Center(
      child:
          EmoticonsWidget(emoticon: '≧◉◡◉≦', text: 'Try Searching Something..'),
    );
  }

  Widget whenError(Object error) {
    return Center(child: EmoticonsWidget(text: error.toString()));
  }

  Widget whenLoading() {
    return const Center(child: CircularProgressIndicator());
  }

  // Positioned(
  //             top: kToolbarHeight,
  //             right: 20,
  //             left: 20,
  //             child: GestureDetector(
  //               onTap: () {
  //                 context.goToSearchScreen();
  //               },
  //               child: Container(
  //                 height: 50,
  //                 decoration: BoxDecoration(
  //                   color: context.theme.colorScheme.surface.withOpacity(0.5),
  //                   border: Border.all(
  //                       color:
  //                           context.theme.colorScheme.primary.withOpacity(0.5),
  //                       width: 2),
  //                   borderRadius: BorderRadius.circular(25),
  //                 ),
  //                 alignment: Alignment.centerLeft,
  //                 padding: const EdgeInsets.all(10),
  //                 child: const Row(
  //                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //                     children: [
  //                       const Text(
  //                         'Search',
  //                         style: TextStyle(
  //                           fontSize: MobileFontSize.semiMedium,
  //                         ),
  //                       ),
  //                       const Icon(Icons.search),
  //                     ]),
  //               ),
  //             ),
  //           )
}

class OkSearchBarDummy extends StatelessWidget {
  const OkSearchBarDummy({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 55,
      decoration: BoxDecoration(
        color: context.theme.colorScheme.surface.withOpacity(0.4),
        border: Border.all(
            color: context.theme.colorScheme.primary.withOpacity(0.5),
            width: 2.5),
        borderRadius: BorderRadius.circular(25),
      ),
      alignment: Alignment.centerLeft,
      padding: const EdgeInsets.only(top: 16, bottom: 16, left: 20, right: 10),
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Text(
          'Search',
          style: TextStyle(
            color: context.theme.colorScheme.onSurface,
            fontWeight: FontWeight.bold,
            fontSize: MobileFontSize.semiMedium,
          ),
        ),
        Icon(
          Icons.search,
          color: context.theme.colorScheme.onSurface,
          size: 20,
        ),
      ]),
    );
  }
}

class OKSearchBar extends StatelessWidget {
  final bool enabled;
  final double? height;
  final bool autofocus;
  final String? text;
  final TextEditingController? controller;
  final void Function(String query)? onSearch;
  const OKSearchBar(
      {super.key,
      required this.enabled,
      this.height,
      required this.autofocus,
      this.text,
      this.controller,
      this.onSearch});

  @override
  Widget build(BuildContext context) {
    final width = context.width;
    return TextField(
      autofocus: autofocus,
      enabled: enabled,
      controller: controller,
      onSubmitted: onSearch,
      decoration: InputDecoration(
        hintText: 'Search..',
        contentPadding: const EdgeInsets.only(top: 16, bottom: 16, left: 20),
        iconColor: context.theme.colorScheme.primary,
        enabled: true,
        isDense: true,
        filled: true,
        fillColor: Colors.black.withOpacity(0.5),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(25),
        ),
        constraints: BoxConstraints(
          maxHeight: height ?? double.infinity,
          maxWidth: width,
        ),
        suffixIcon: IconButton(
            icon: const Icon(Icons.search),
            onPressed: !enabled
                ? null
                : () {
                    if (controller != null && onSearch != null) {
                      onSearch!(controller!.text);
                    }
                  }),
      ),
    );
  }
}

class CustomSearchBar extends StatefulWidget {
  final void Function(String query) onSearch;
  final double? height;
  final String? hint;
  const CustomSearchBar(
      {super.key, required this.onSearch, this.hint, this.height});

  @override
  State<CustomSearchBar> createState() => _CustomSearchBarState();
}

class _CustomSearchBarState extends State<CustomSearchBar> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(
      text: widget.hint,
    );
  }

  @override
  void setState(VoidCallback fn) {
    if (!mounted) return;
    super.setState(fn);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return OKSearchBar(
      controller: _controller,
      onSearch: widget.onSearch,
      enabled: true,
      autofocus: true,
      height: widget.height,
      text: widget.hint,
    );
  }
}
