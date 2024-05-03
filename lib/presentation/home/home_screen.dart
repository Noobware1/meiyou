import 'package:flutter/material.dart';
import 'package:injecktor/injecktor.dart';
import 'package:meiyou/core/config/routes/routes.dart';

import 'package:meiyou/core/utils/extensions/context.dart';
import 'package:meiyou/core/utils/resources/async_cubit.dart';
import 'package:meiyou/presentation/core/injectktor_widget.dart';
import 'package:meiyou/presentation/core/space.dart';
import 'package:meiyou/presentation/home/banner/banner_view.dart';
import 'package:meiyou/presentation/home/homepage_row/homepage_row.dart';
import 'package:meiyou/presentation/home/services/home_screen_service.dart';
import 'package:meiyou/presentation/home/source_selector/selected_source.dart';
import 'package:meiyou/presentation/home/source_selector/source_selector_button.dart';
import 'package:meiyou_extensions_lib/models.dart';
import 'package:nice_dart/nice_dart.dart';

class HomeScreen extends InjecktorWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    addSingleton(
        context,
        () => HomeScreenCubit(
            InjectKtor.get<SelectedSource>(), InjectKtor.get()));

    return InjecktorBlocBuilder<HomeScreenCubit, AsyncValue<HomeScreenData>>(
        builder: (context, state) {
      return Scaffold(
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
        floatingActionButton: const SourceSelectorButton(),
      );
    });
  }

  void onItemSelected(BuildContext context, ContentItem item) {
  context.goToInfoScreen(item);
  }

  void onAddToLibary(BuildContext context, ContentItem item) {
    print('Add to library: $item');
  }

  Widget whenLoading() {
    return const Center(child: CircularProgressIndicator());
  }

  Widget whenLoaded(
      BuildContext context, Map<HomePageRequest, HomePage> homepages) {
    return SingleChildScrollView(
      child: homepages.length > 1
          ? ifMoreThanOneHomePage(context, homepages)
          : ifOnlyOneHomePage(context, homepages),
    );
  }

  Widget ifOnlyOneHomePage(
      BuildContext context, Map<HomePageRequest, HomePage> homepages) {
    return Column(children: [
      for (final entry in homepages.entries) ...[
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

  Widget ifMoreThanOneHomePage(
      BuildContext context, Map<HomePageRequest, HomePage> homepages) {
    return Column(children: [
      homepages.entries.first.let((it) {
        return BannerView(
          request: it.key,
          homepage: it.value,
          onAddToLibrary: (selected) => onAddToLibary(context, selected),
          onItemSelected: (selected) => onItemSelected(context, selected),
        );
      }),
      const VerticalSpace(20),
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
    return const Center(
      child: Text('No source selected'),
    );
  }

  Widget whenHomePageNotSupported() {
    return const Center(
      child: Text('HomePage is not supported for this source'),
    );
  }
}
