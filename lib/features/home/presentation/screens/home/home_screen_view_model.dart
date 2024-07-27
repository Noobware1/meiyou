import 'dart:async';

import 'package:async/async.dart' hide Result;
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:meiyou/core/utils/log/logger.dart';
import 'package:meiyou/features/home/domain/models/expanded_home_page_list.dart';
import 'package:meiyou/features/home/domain/models/home_screen_state.dart';
import 'package:meiyou/features/home/domain/models/repository_params/home_page_repository_params.dart';
import 'package:meiyou/features/home/domain/usecases/home_repository_usecases/expand_homepage_usecase.dart';
import 'package:meiyou/features/home/presentation/screens/browse/browse_screen.dart';
import 'package:meiyou/shared/data/data_sources/preferences/source_preferences.dart';
import 'package:meiyou/shared/domain/models/async_value.dart';
import 'package:meiyou/shared/domain/models/extension_category.dart';
import 'package:meiyou/shared/domain/models/home_page_data.dart';
import 'package:meiyou/shared/domain/models/media.dart';
import 'package:meiyou/shared/domain/models/repositories_params/media_repository_params.dart';
import 'package:meiyou/shared/domain/models/repositories_params/source_repository_params.dart';
import 'package:meiyou/shared/domain/models/source.dart';
import 'package:meiyou/shared/domain/source_manager/source_manager.dart';
import 'package:meiyou/shared/domain/usecases/media_repository_usecases/get_media_by_url_and_source_id_usecase.dart';
import 'package:meiyou/shared/domain/usecases/media_repository_usecases/network_media_to_local_usecase.dart';
import 'package:meiyou/shared/domain/usecases/source_repository_usecases/get_full_home_page_usecase.dart';
import 'package:meiyou/shared/domain/usecases/source_repository_usecases/get_home_page_usecase.dart';
import 'package:meiyou/shared/domain/extension_manager/extension_manger.dart';
import 'package:meiyou/shared/domain/usecases/source_repository_usecases/get_media_details_usecase.dart';
import 'package:meiyou/shared/presentation/notifers/state_notifer.dart';
import 'package:meiyou/shared/presentation/widgets/sheets/adaptive_sheet.dart';
import 'package:meiyou_extensions_lib/models.dart';
import 'package:nice_dart/nice_dart.dart';

class HomeScreenViewModel {
  final GetFulHomePageUseCase _getFulHomePageUseCase;
  final GetHomePageUseCase _getHomePageUseCase;
  final GetMediaDetailsUseCase _getMediaDetailsUseCase;
  final SourcePreferences _sourcePreferences;
  final SourceManager _sourceManager;
  final StateNotifier<HomeScreenState> stateListenable;
  final ExtensionManager _extensionManager;
  final NetworkMediaToLocalUseCase _networkMediaToLocalUseCase;
  final GetMediaByUrlAndSourceIdUseCase _getMediaByUrlAndSourceIdUseCase;
  final ExpandHomepageUseCase _expandHomepageUsecase;

  HomeScreenViewModel({
    required GetFulHomePageUseCase getFulHomePageUseCase,
    required GetHomePageUseCase getHomePageUseCase,
    required GetMediaDetailsUseCase getMediaDetailsUseCase,
    required SourcePreferences sourcePreferences,
    required SourceManager sourceManager,
    required ExtensionManager extensionManager,
    required NetworkMediaToLocalUseCase networkMediaToLocalUseCase,
    required GetMediaByUrlAndSourceIdUseCase getMediaByUrlAndSourceIdUseCase,
    required ExpandHomepageUseCase expandHomepageUsecase,
  })  : _getFulHomePageUseCase = getFulHomePageUseCase,
        _getHomePageUseCase = getHomePageUseCase,
        _getMediaDetailsUseCase = getMediaDetailsUseCase,
        _sourcePreferences = sourcePreferences,
        _sourceManager = sourceManager,
        _extensionManager = extensionManager,
        _networkMediaToLocalUseCase = networkMediaToLocalUseCase,
        _getMediaByUrlAndSourceIdUseCase = getMediaByUrlAndSourceIdUseCase,
        _expandHomepageUsecase = expandHomepageUsecase,
        stateListenable = StateNotifier(
            _initalState(sourcePreferences, sourceManager, extensionManager)) {
    if (stateListenable.state is HomeScreenStateWithSource) {
      _refresh();
    }
  }

  CancelableOperation<Result<List<HomePageData>>>? _refreshJob;

  final Map<String, StateNotifier<ExpandedHomePageList>> _expanded = {};

  Iterable<StateNotifier<ExpandedHomePageList>> get expanded =>
      _expanded.values;

  StateNotifier<List<Media>>? _bannerStateListenable;

  StateNotifier<List<Media>> get bannerStateListenable =>
      _bannerStateListenable!;

  final List<Media> currentShuffledList = [];

  final Set<String> _alreadyAdded = {};

  Future<void> _refresh() async {
    assert(stateListenable.state is HomeScreenStateWithSource);
    final state = stateListenable.state as HomeScreenStateWithSource;

    await _performCleanup();

    state.copyWith(data: const AsyncValue.loading());

    final source = state.selectedSource;
    final id = source.id;
    final category = source.category;

    _refreshJob = CancelableOperation.fromFuture(_getFulHomePageUseCase(
        GetFullHomePageParams(sourceId: id, category: category)));

    final result = await _refreshJob?.valueOrCancellation();

    if (result == null) {
      logger.info('Refresh job was cancelled');
      return;
    }

    if (result.isSuccess) {
      final fullHomePage = result.getOrThrow();

      for (final data in fullHomePage) {
        final expandedData = _expandHomepageUsecase(ExpandHomePageParams(
            homePage: data.homePage,
            mapper: (media) {
              return _mapMedia(media, id, category);
            }));

        for (final list in expandedData) {
          currentShuffledList.addAll(list.mediaList..shuffle());
          _expanded[list.title] = StateNotifier(list);
        }
        currentShuffledList.shuffle();
      }

      _bannerStateListenable = StateNotifier([]);

      await _updateBannerList(currentShuffledList, _alreadyAdded, 3);

      stateListenable
          .setState(state.copyWith(data: AsyncValue.data(fullHomePage)));
    } else {
      stateListenable.setState(state.copyWith(data: AsyncValue.error(result)));
    }
  }

  Future<void> _updateBannerList(
      List<Media> shuffled, Set<String> alreadyAdded, int size) async {
    try {
      var count = 0;

      final addItems = <Media>[];

      for (var i = 0; i < shuffled.length; i++) {
        final media = shuffled[i];
        if (alreadyAdded.contains(media.url)) {
          continue;
        }
        if (count >= size) {
          break;
        }

        addItems.add(media);
        alreadyAdded.add(media.url);
        if (shuffled[i].initalized) {
          continue;
        }
        count++;
      }

      final results = await Future.wait(addItems.map((media) async {
        if (media.initalized) return media;

        final response = await _getMediaDetailsUseCase(GetMediaDetailsParams(
            media: media, sourceId: media.sourceId, category: media.category));

        if (response.isFailure) {
          logger.warning('Failed to load media details for ${media.title}',
              response.exceptionOrNull());
          return null;
        }

        return media.copyDetails(response.getOrThrow());
      })).then((list) => list.nonNulls);

      _bannerStateListenable?.addAll(results);
    } catch (e) {
      logger.warning('Failed to update banner list', e);
    }
  }

  final Set<String> _lock = {};
  final Set<CancelableOperation<Result<HomePage>>> _jobs = {};

  CancelableOperation<void>? _bannerJob;

  Future<void> onBannerScrollEnd() async {
    if (_bannerJob != null) {
      return;
    }

    _bannerJob = CancelableOperation.fromFuture(
        _updateBannerList(currentShuffledList, _alreadyAdded, 1), onCancel: () {
      _bannerJob = null;
    });

    await _bannerJob!.valueOrCancellation(null);
    _bannerJob = null;
  }

  Future<void> onScrollEnd(String key) async {
    if (_lock.contains(key)) {
      logger.warning('Already loading next page for $key');
      return;
    }

    _lock.add(key);

    await _waitForHomeDelay();

    final current = _expanded[key]!;
    final currentState = current.state;

    if (!currentState.hasNext) {
      return;
    }

    final nextPage = currentState.currentPage + 1;
    final request = stateListenable.state.data
        .getOrThrow()
        .firstWhere((e) => e.homePage.items.any((e) => e.title == key))
        .request;

    _lastHomePageRequest = _unixTimeMs;

    final job = CancelableOperation.fromFuture(
      _getHomePageUseCase(GetHomePageParams(
        sourceId: currentState.mediaList.first.sourceId,
        category: currentState.mediaList.first.category,
        request: request,
        page: nextPage,
      )),
    );

    _jobs.add(job);

    final result = await job.valueOrCancellation();

    if (result == null) return;

    if (result.isFailure) {
      logger.warning(
          'Failed to load next page for $key', result.exceptionOrNull());
      current.setState(currentState.copyWith(hasNext: false));
    } else {
      final homePage = result.getOrThrow();

      final (int sourceId, ExtensionCategory category) = stateListenable
          .state.selectedSource!
          .let((it) => (it.id, it.category));

      for (var item in homePage.items) {
        final key = item.title;

        _expanded[key]?.let((notifer) {
          notifer.setState(notifer.state.copyWith(
            currentPage: nextPage,
            hasNext: homePage.hasNextPage,
            mediaList: notifer.state.mediaList +
                item.list.mapList((e) {
                  return _mapMedia(e, sourceId, category);
                }),
          ));
        });
      }
    }

    _lock.remove(key);
  }

  Future<void> openBrowseWindow(BuildContext context) {
    return showModalAdaptiveSheet(
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

    _refresh();
  }

  void onSelected(Media preview) {
    print('Selected: $preview');
  }

  void onAddToLibrary(Media preview) {
    print('Add to library: $preview');
  }

  Future<void> goToDetailsScreen(BuildContext context, Media preview) async {
    final local = await _networkMediaToLocalUseCase(
        NetworkMediaToLocalParams(media: preview));
  }

  Media _mapMedia(IMedia media, int sourceId, ExtensionCategory category) {
    final networkMedia = Media.formIMedia(media, sourceId, category);
    final local = _getMediaByUrlAndSourceIdUseCase(
        GetMediaByUrlAndSourceIdParams(
            url: networkMedia.url, sourceId: sourceId, category: category));

    return local ?? networkMedia;
  }

  Future<void> _performCleanup() async {
    for (var notifer in _expanded.values) {
      notifer.dispose();
    }
    _alreadyAdded.clear();
    _lock.clear();
    _expanded.clear();
    currentShuffledList.clear();
    _bannerStateListenable?.dispose();
    _bannerStateListenable = null;
    await _refreshJob?.cancel().thenSafe(() => _refreshJob = null);
    await _jobs.cancelAll().thenSafe(() => _jobs.clear());
    await _bannerJob?.cancel().thenSafe(() => _bannerJob = null);
  }

  void dispose() {
    _performCleanup();
    stateListenable.dispose();
  }

  int _lastHomePageRequest = 0;

  Future _waitForHomeDelay() {
    return Future.delayed(
        Duration(seconds: _lastHomePageRequest - _unixTimeMs));
  }

  int get _unixTimeMs => DateTime.now().millisecondsSinceEpoch ~/ 1000;

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
}

extension<T> on Iterable<CancelableOperation<T>> {
  Future<void> cancelAll() async {
    for (var job in this) {
      await job.cancel();
    }
  }
}

extension<T> on Future<T>? {
  Future<void> thenSafe(void Function() then) async {
    try {
      await this;
    } catch (_) {
      logger.warning('Failed to await future', _);
    } finally {
      then();
    }
  }
}

extension on StateNotifier<List<Media>> {
  void addAll(Iterable<Media> media) {
    setState([...state, ...media]);
  }
}
