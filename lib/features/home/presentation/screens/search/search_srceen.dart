import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:meiyou/core/injection/injection.dart';
import 'package:meiyou/core/router/route_params.dart';
import 'package:meiyou/core/utils/constants/size_constants.dart';
import 'package:meiyou/core/utils/extensions/context.dart';
import 'package:meiyou/features/home/presentation/screens/search/search_screen_view_model.dart';
import 'package:meiyou/shared/domain/models/async_value.dart';
import 'package:meiyou/shared/domain/models/extension_category.dart';
import 'package:meiyou/shared/presentation/widgets/empty_screen.dart';
import 'package:meiyou/shared/presentation/widgets/poster_view/poster_view.dart';
import 'package:meiyou/shared/presentation/widgets/responsive_widget.dart';
import 'package:meiyou/shared/presentation/widgets/spacing.dart';
import 'package:meiyou/shared/presentation/widgets/state_listenable_builder.dart';
import 'package:meiyou_extensions_lib/models.dart';
import 'package:nice_dart/nice_dart.dart';

class SearchScreen extends StatefulWidget {
  final int sourceId;
  final ExtensionCategory category;
  const SearchScreen({
    super.key,
    required this.sourceId,
    required this.category,
  });

  SearchScreen.fromRouteParams(
      {super.key, required SearchScreenRouteParams params})
      : sourceId = params.sourceId,
        category = params.category;

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  late final SearchScreenViewModel viewModel;

  @override
  void initState() {
    super.initState();
    viewModel = SearchScreenViewModel(
      sourceId: widget.sourceId,
      category: widget.category,
      getSearchPageUseCase: getIt(),
      networkMediaToLocalUseCase: getIt(),
      getMediaByUrlAndSourceIdUseCase: getIt(),
    );
  }

  @override
  void dispose() {
    viewModel.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          forceMaterialTransparency: true,
          title: const Text(
            'Search',
            // style: TextStyle(fontWeight: FontWeight.bold),
          )),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {},
        label: Text('Filter'),
        icon: const Icon(Icons.filter_alt_outlined),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 20, right: 20),
            child: CustomSearchBar(
              onSearch: (query) {
                viewModel.search(query);
              },
            ),
          ),
          const VerticalSpace(20),
          Expanded(
            child: StateListenableBuilder(
                stateListenable: viewModel.stateListenable,
                builder: (context, state, _) {
                  return state.when(
                    success: whenData,
                    error: (error, stack) {
                      return whenError(error);
                    },
                    loading: whenLoading,
                    noData: whenInitial,
                  );
                }),
          )
        ],
      ),
    );
  }

  Widget whenData(SearchScreenState state) {
    if (state.mediaList.isEmpty) {
      return const Center(child: EmptyScreen(text: 'No results found'));
    }

    return ResponsiveBuilder(builder: (context, constraints, screenSize) {
      return PosterView(
        label: 'Search results',
        mediaList: state.mediaList,
        type: PosterViewType.grid,
        scrollController: viewModel.scrollController,
        onSelected: (media) => viewModel.onSelected(context, media),
      );
    });
  }

  Widget whenInitial() {
    return const Center(
      child: EmptyScreen(text: 'Try Searching Something..'),
    );
  }

  Widget whenError(Object error) {
    return Center(child: EmptyScreen(text: error.toString()));
  }

  Widget whenLoading() {
    return const Center(child: CircularProgressIndicator());
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
        fillColor: context.theme.colorScheme.let((it) =>
            ElevationOverlay.applySurfaceTint(it.surface, it.surfaceTint, 3.0)),
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
