import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:meiyou/core/injection/injection.dart';
import 'package:meiyou/core/utils/constants/material_theme.dart';
import 'package:meiyou/features/home/domain/models/home_paging_source.dart';
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
                  success: (pagingSource) => whenData(pagingSource),
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

  Widget whenData(List<HomePagingSource> pagingSource) {
    return MediaQuery.removePadding(
      context: context,
      removeTop: true,
      child: ListView(
        children: [
          BannerView(
            onAddToLibrary: viewModel.onAddToLibrary,
            onSelected: viewModel.onSelected,
            pagingSource: pagingSource.first,
          ),
          for (final source in pagingSource.skip(1))
            HomeRow(
              homePagingSource: source,
              onAddToLibrary: viewModel.onAddToLibrary,
              onSelected: viewModel.onSelected,
            ),
        ],
      ),
    );
  }
}
