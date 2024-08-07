import 'package:flutter/material.dart';
import 'package:meiyou/core/injection/injection.dart';
import 'package:meiyou/core/utils/constants/material_theme.dart';
import 'package:meiyou/features/home/presentation/screens/browse/browse_screen_view_model.dart';
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
  late int currentIndex;
  late final List<ValueKey<int>> keys;

  @override
  void initState() {
    super.initState();
    viewModel = BrowseScreenViewModel(
      this,
      GetEnabledSourcesUseCase: getIt(),
      extensionManger: getIt(),
      preferences: getIt(),
      onSourceSelected: widget.onSourceSelected,
    );

    currentIndex = viewModel.navigatiorStateListenable.state;
    keys = List.generate(viewModel.tabCount, (index) => ValueKey(index));

    viewModel.navigatiorStateListenable.addListener(listener);
  }

  void listener() {
    setState(() {
      currentIndex = viewModel.navigatiorStateListenable.state;
    });
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
      body: AnimatedSwitcher(
        transitionBuilder: (child, animation) {
          return SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(1, 0),
              end: Offset.zero,
            ).animate(animation),
            child: child,
          );
        },
        duration: Durations.short4,
        child: _tabBarView(),
      ),
    );
  }

  Widget _tabBarView() {
    return TabBarView(
      key: keys[currentIndex],
      controller: viewModel.tabController(currentIndex),
      children: viewModel.tabViews(currentIndex),
    );
  }

  PreferredSizeWidget _tabBar() {
    return PreferredSize(
      preferredSize: const Size.fromHeight(MaterialTheme.tabBarHeight),
      child: TabBar(
        tabAlignment: TabAlignment.start,
        indicatorSize: TabBarIndicatorSize.tab,
        isScrollable: true,
        controller: viewModel.tabController(currentIndex),
        tabs: viewModel.tabs(currentIndex),
      ),
    );
  }

  Widget _bottomNavigationBar() {
    return CustomNavigationBar(
      type: NavigationBarType.bottom,
      destinations: viewModel.destinations,
      selectedIndex: currentIndex,
      onDestinationSelected: viewModel.navigateTo,
    );
  }

  @override
  void dispose() {
    viewModel.dispose();
    super.dispose();
  }
}
