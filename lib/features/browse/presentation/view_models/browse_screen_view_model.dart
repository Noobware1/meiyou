import 'package:flutter/material.dart';
import 'package:meiyou/features/browse/presentation/screens/extensions_screen.dart';
import 'package:meiyou/features/browse/presentation/screens/sources_screen.dart';
import 'package:meiyou/features/browse/presentation/view_models/extensions_screen_view_model.dart';
import 'package:meiyou/features/browse/presentation/view_models/sources_screen_view_model.dart';
import 'package:meiyou/shared/domain/models/extension_category.dart';
import 'package:meiyou/shared/domain/usecases/source_repository_usecases/get_enabled_intalled_sources.dart';
import 'package:meiyou/shared/extension_manager/extension_manger.dart';
import 'package:meiyou/shared/presentation/notifers/state_notifer.dart';
import 'package:meiyou/shared/presentation/widgets/navigation_bar/navigation_bar.dart';

class BrowseScreenViewModel {
  BrowseScreenViewModel(
    TickerProvider tickerProvider, {
    required getEnabledSourcesUseCase getEnabledSourcesUseCase,
    required ExtensionManager extensionManger,
  }) {
    for (var i = 0; i < _tabCount; i++) {
      _tabControllers[i] =
          TabController(length: _tabCount, vsync: tickerProvider);
      _sourcesScreenViewModels[i] = SourcesScreenViewModel(
        getEnabledSourcesUseCase: getEnabledSourcesUseCase,
        category: ExtensionCategory.values[i],
      );
      _extensionsScreenViewModels[i] = ExtensionsScreenViewModel(
        extensionManger: extensionManger,
        category: ExtensionCategory.values[i],
      );
    }
  }

  static const _tabCount = 3;

  final List<TabController?> _tabControllers = List.filled(_tabCount, null);
  final List<SourcesScreenViewModel?> _sourcesScreenViewModels =
      List.filled(_tabCount, null);
  final List<ExtensionsScreenViewModel?> _extensionsScreenViewModels =
      List.filled(_tabCount, null);

  late final List<List<Tab>> _tabs = [
    const [
      Tab(text: 'Video Sources'),
      Tab(text: 'Manga Sources'),
      Tab(text: 'Novel Sources'),
    ],
    const [
      Tab(text: 'Video Extensions'),
      Tab(text: 'Manga Extensions'),
      Tab(text: 'Novel Extensions'),
    ],
    const [
      Tab(text: 'Migrate Video'),
      Tab(text: 'Migrate Manga'),
      Tab(text: 'Migrate Novel'),
    ],
  ];


  final StateNotifier<int> navigatiorStateListenable = StateNotifier(0);
 
  final List<Destination> destinations = [
    const Destination(
      icon: Icon(Icons.explore_outlined),
      selectedIcon: Icon(Icons.explore),
      label: 'Sources',
    ),
    const Destination(
      icon: Icon(Icons.extension_outlined),
      selectedIcon: Icon(Icons.extension),
      label: 'Extensions',
    ),
    const Destination(
      icon: Icon(Icons.compare_arrows_outlined),
      selectedIcon: Icon(Icons.compare_arrows),
      label: 'Migrate',
    ),
  ];

  List<Tab> tabs(int index) {
    return _tabs[index];
  }

  TabController tabController(int index) {
    return _tabControllers[index]!;
  }

  List<Widget> tabViews(int index) {
    switch (index) {
      case 0:
        return _sourcesScreenViewModels
            .map((e) => SourcesScreen(viewModel: e!))
            .toList();
      case 1:
        return _extensionsScreenViewModels
            .map((e) => ExtensionsScreen(viewModel: e!))
            .toList();

      case 2:
        return [
          Container(),
          Container(),
          Container(),
          // MigrateScreen(),
          // MigrateScreen(),
          // MigrateScreen(),
        ];
      default:
        throw Exception('Invalid index');
    }
  }

  void dispose() {
    for (var i = 0; i < _tabCount; i++) {
      _tabControllers[i]?.dispose();
      _sourcesScreenViewModels[i]?.dispose();
      _extensionsScreenViewModels[i]?.dispose();
    }
  }

  void navigateTo(int index) {
    if (index == navigatiorStateListenable.state) return;
    navigatiorStateListenable.setState(index);
  }
}
