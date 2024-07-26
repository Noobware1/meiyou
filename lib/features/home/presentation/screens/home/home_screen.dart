import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:meiyou/core/injection/injection.dart';
import 'package:meiyou/core/utils/constants/material_theme.dart';
import 'package:meiyou/features/home/presentation/widgets/banner_view/banner_view.dart';
import 'package:meiyou/features/home/presentation/widgets/home_row/home_row.dart';
import 'package:meiyou/shared/presentation/widgets/poster_view/poster_view.dart';
import 'package:meiyou/shared/presentation/widgets/poster_view/poster_view_theme_data.dart';
import 'package:meiyou/shared/domain/models/async_value.dart';
import 'package:meiyou/shared/domain/models/source.dart';
import 'package:meiyou/shared/presentation/widgets/empty_screen.dart';
import 'package:meiyou/shared/presentation/widgets/image_holder.dart';
import 'package:meiyou/shared/presentation/widgets/state_listenable_builder.dart';
import 'package:meiyou/features/home/presentation/screens/home/home_screen_view_model.dart';
import 'package:nice_dart/nice_dart.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late final HomeScreenViewModel viewModel;

  @override
  void initState() {
    super.initState();
    viewModel = HomeScreenViewModel(
      getFulHomePageUseCase: getIt(),
      getHomePageUseCase: getIt(),
      sourcePreferences: getIt(),
      sourceManager: getIt(),
      extensionManager: getIt(),
      expandHomepageUsecase: getIt(),
      getMediaByUrlAndSourceIdUseCase: getIt(),
      getMediaDetailsUseCase: getIt(),
      networkMediaToLocalUseCase: getIt(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return StateListenableBuilder(
        stateListenable: viewModel.stateListenable,
        builder: (context, state, _) {
          return Scaffold(
            floatingActionButton: sourceSelectorButton(state.selectedSource),
            body: state.when(
              noSource: () => whenNoSource(),
              withSource: (selectedSource, data) {
                return data.when(
                  noData: () => whenLoading(),
                  loading: () => whenLoading(),
                  error: (error, s) => whenError(error),
                  success: (_) => whenData(),
                );
              },
            ),
          );
        });
  }

  Widget sourceSelectorButton(InstalledSource? source) {
    final name = source?.name ?? 'Select source';
    final icon = source?.icon?.let((icon) => ImageHolder.memory(
              bytes: icon,
              height: MaterialTheme.iconSize,
              width: MaterialTheme.iconSize,
            )) ??
        const Icon(Icons.add);

    return FloatingActionButton.extended(
      onPressed: () {
        viewModel.openBrowseWindow(context);
      },
      label: Text(name),
      icon: icon,
    );
  }

  Widget whenNoSource() {
    return const EmptyScreen(text: 'No source');
  }

  Widget whenLoading() {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }

  Widget whenError(Object error) {
    return Center(
      child: EmptyScreen(text: error.toString()),
    );
  }

  Widget whenData() {
    return MediaQuery.removePadding(
      context: context,
      removeTop: true,
      child: ListView(
        children: [
          BannerView(
            stateListenable: viewModel.bannerStateListenable,
            onScrollEnd: viewModel.onBannerScrollEnd,
            onPressed: viewModel.onSelected,
            onLongPressed: (_) {},
          ),
          for (final rowData in viewModel.expanded)
            HomeRow(
              listenable: rowData,
              onPressed: viewModel.onSelected,
              onLongPressed: (_) {},
              onScrollEnd: (key) => viewModel.onScrollEnd(key),
            ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    viewModel.dispose();
    super.dispose();
  }
}
