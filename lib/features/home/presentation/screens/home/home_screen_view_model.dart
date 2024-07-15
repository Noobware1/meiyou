import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:meiyou/features/browse/presentation/screens/browse/browse_screen.dart';
import 'package:meiyou/features/home/domain/models/home_paging_source.dart';
import 'package:meiyou/features/home/domain/models/home_screen_state.dart';
import 'package:meiyou/shared/data/data_sources/preferences/source_preferences.dart';
import 'package:meiyou/shared/domain/models/async_value.dart';
import 'package:meiyou/shared/domain/models/source.dart';
import 'package:meiyou/shared/domain/models/source_repository_params.dart';
import 'package:meiyou/shared/domain/source_manager/source_manager.dart';
import 'package:meiyou/shared/domain/usecases/source_repository_usecases/get_full_home_page_usecase.dart';
import 'package:meiyou/shared/domain/usecases/source_repository_usecases/get_home_page_usecase.dart';
import 'package:meiyou/shared/extension_manager/extension_manger.dart';
import 'package:meiyou/shared/presentation/notifers/state_notifer.dart';
import 'package:meiyou/shared/presentation/widgets/sheets/adaptive_sheet.dart';
import 'package:meiyou_extensions_lib/models.dart';
import 'package:nice_dart/nice_dart.dart';

class HomeScreenViewModel {
  final GetFulHomePageUseCase _getFulHomePageUseCase;
  final GetHomePageUseCase _getHomePageUseCase;
  final SourcePreferences _sourcePreferences;
  final SourceManager _sourceManager;
  final StateNotifier<HomeScreenState> stateListenable;
  final ExtensionManager _extensionManager;

  HomeScreenViewModel({
    required GetFulHomePageUseCase getFulHomePageUseCase,
    required GetHomePageUseCase getHomePageUseCase,
    required SourcePreferences sourcePreferences,
    required SourceManager sourceManager,
    required ExtensionManager extensionManager,
  })  : _getFulHomePageUseCase = getFulHomePageUseCase,
        _getHomePageUseCase = getHomePageUseCase,
        _sourcePreferences = sourcePreferences,
        _sourceManager = sourceManager,
        _extensionManager = extensionManager,
        stateListenable = StateNotifier(
            _initalState(sourcePreferences, sourceManager, extensionManager)) {
    if (stateListenable.state is HomeScreenStateWithSource) {
      loadFullHomePage();
    }
  }

  static HomeScreenState _initalState(SourcePreferences preferences,
      SourceManager sourceManager, ExtensionManager extensionManager) {
    final category = preferences.lastUsedExtensionCategory().get();
    final sourceId = preferences.lastUsedSourceByCategory(category).get();

    final lastUsed = sourceManager.getSource(sourceId, category)?.let((it) {
      final id = it.id;
      return InstalledSource(
        category: category,
        id: id,
        name: it.name,
        language: it.lang,
        isUsedLast: true,
        icon: extensionManager.getInstalledExtension(id, category)?.icon,
        version: '',
        pin: Pin.unPinned,
      );
    });

    return lastUsed == null
        ? const HomeScreenStateNoSource()
        : HomeScreenStateWithSource(
            selectedSource: lastUsed,
            data: const AsyncValue.loading(),
          );
  }

  Future<void> loadFullHomePage() async {
    assert(stateListenable.state is HomeScreenStateWithSource);
    final state = stateListenable.state as HomeScreenStateWithSource;

    state.copyWith(data: const AsyncValue.loading());

    final source = state.selectedSource;

    final result = await _getFulHomePageUseCase(source.let(
        (it) => GetFullHomePageParams(sourceId: it.id, category: it.category)));

    final HomeScreenState newState;
    if (result.isFailure) {
      newState = state.copyWith(
        data: AsyncValue.error(result.exceptionOrNull()!),
      );
    } else {
      newState = state.copyWith(
        data: AsyncValue.data(result
            .getOrNull()!
            .entries
            .map((entry) => _HomePagingSource(
                page: 1,
                request: entry.key,
                homePage: entry.value,
                source: source,
                getHomePageUseCase: _getHomePageUseCase))
            .toList()),
      );
    }
    stateListenable.setState(newState);
  }

  Future<void> openBrowseWindow(BuildContext context) {
    return showModalAdaptiveSheet<void>(
        context: context,
        isScrollControlled: true,
        builder: (context) {
          return BrowseScreen(onSourceSelected: (source) {
            _onNewSourceSelected(source);
            Navigator.of(context).pop();
          });
        });
  }

  void _onNewSourceSelected(InstalledSource source) {
    final newState = HomeScreenStateWithSource(
      selectedSource: source,
      data: const AsyncValue.loading(),
    );

    stateListenable.setState(newState);
    loadFullHomePage();
  }

  void onSelected(MediaPreview preview) {
    print('Selected: $preview');
  }

  void onAddToLibrary(MediaPreview preview) {
    print('Add to library: $preview');
  }
}

class _HomePagingSource extends HomePagingSource {
  final InstalledSource _source;
  final GetHomePageUseCase _getHomePageUseCase;

  _HomePagingSource({
    required super.page,
    required super.request,
    required super.homePage,
    required InstalledSource source,
    required GetHomePageUseCase getHomePageUseCase,
  })  : _source = source,
        _getHomePageUseCase = getHomePageUseCase;

  @override
  Future<Result<HomePage>> load(LoadHomePageParams parmas) async {
    assert(params.page > 1);

    final result =
        await _getHomePageUseCase(_source.let((it) => GetHomePageParams(
              sourceId: it.id,
              category: it.category,
              page: params.page,
              request: params.request,
            )));

    return result;
  }
}
