import 'package:flutter/material.dart';
import 'package:meiyou/core/injection/injection.dart';
import 'package:meiyou/core/utils/constants/material_theme.dart';
import 'package:meiyou/features/browse/presentation/screens/browse/browse_screen_view_model.dart';
import 'package:meiyou/shared/domain/models/extension_category.dart';
import 'package:meiyou/shared/domain/models/source.dart';
import 'package:meiyou/shared/presentation/widgets/navigation_bar/navigation_bar.dart';
import 'package:meiyou/shared/presentation/widgets/state_listenable_builder.dart';

class BrowseScreen extends StatefulWidget {
  final Function(InstalledSource source) onSourceSelected;
  const BrowseScreen({super.key, required this.onSourceSelected});

  @override
  State<BrowseScreen> createState() => _BrowseScreenState();
}

class _BrowseScreenState extends State<BrowseScreen>
    with TickerProviderStateMixin {
  late final BrowseScreenViewModel viewModel;

  @override
  void initState() {
    super.initState();
    viewModel = BrowseScreenViewModel(
      this,
      getEnabledSourcesUseCase: getIt(),
      extensionManger: getIt(),
      preferences: getIt(),
      onSourceSelected: widget.onSourceSelected,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Browse'),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: const Icon(Icons.close),
          )
        ],
        bottom: _tabBar(),
      ),
      bottomNavigationBar: _bottomNavigationBar(),
      body: _tabBarView(),
    );
  }

  Widget _tabBarView() {
    return StateListenableBuilder(
      stateListenable: viewModel.navigatiorStateListenable,
      builder: (context, state, _) {
        return TabBarView(
          controller: viewModel.tabController(state),
          children: viewModel.tabViews(state),
        );
      },
    );
  }

  PreferredSizeWidget _tabBar() {
    return PreferredSize(
      preferredSize: const Size.fromHeight(MaterialTheme.tabBarHeight),
      child: StateListenableBuilder(
        stateListenable: viewModel.navigatiorStateListenable,
        builder: (context, state, _) {
          return TabBar(
            tabAlignment: TabAlignment.start,
            indicatorSize: TabBarIndicatorSize.tab,
            isScrollable: true,
            controller: viewModel.tabController(state),
            tabs: viewModel.tabs(state),
          );
        },
      ),
    );
  }

  Widget _bottomNavigationBar() {
    return StateListenableBuilder(
        stateListenable: viewModel.navigatiorStateListenable,
        builder: (_, state, __) {
          return CustomNavigationBar(
            type: NavigationBarType.bottom,
            destinations: viewModel.destinations,
            selectedIndex: state,
            onDestinationSelected: viewModel.navigateTo,
          );
        });
  }

  @override
  void dispose() {
    viewModel.dispose();
    super.dispose();
  }
}
