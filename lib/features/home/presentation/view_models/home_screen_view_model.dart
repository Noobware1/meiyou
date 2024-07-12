import 'package:meiyou/features/home/domain/models/home_screen_state.dart';
import 'package:meiyou/shared/data/data_sources/preferences/source_preferences.dart';
import 'package:meiyou/shared/domain/models/async_value.dart';
import 'package:meiyou/shared/domain/models/source.dart';
import 'package:meiyou/shared/domain/models/source_repository_params.dart';
import 'package:meiyou/shared/domain/source_manager/source_manager.dart';
import 'package:meiyou/shared/domain/usecases/source_repository_usecases/get_full_home_page_usecase.dart';
import 'package:meiyou/shared/domain/usecases/source_repository_usecases/get_home_page_usecase.dart';
import 'package:meiyou/shared/presentation/notifers/state_notifer.dart';
import 'package:meiyou_extensions_lib/models.dart';
import 'package:nice_dart/nice_dart.dart';

class HomeScreenViewModel {
  final GetFulHomePageUseCase _getFulHomePageUseCase;
  final GetHomePageUseCase _getHomePageUseCase;
  final SourcePreferences _sourcePreferences;
  final SourceManager _sourceManager;

  final StateNotifier<HomeScreenState> stateListenable;

  HomeScreenViewModel({
    required GetFulHomePageUseCase getFulHomePageUseCase,
    required GetHomePageUseCase getHomePageUseCase,
    required SourcePreferences sourcePreferences,
    required SourceManager sourceManager,
  })  : _getFulHomePageUseCase = getFulHomePageUseCase,
        _getHomePageUseCase = getHomePageUseCase,
        _sourcePreferences = sourcePreferences,
        _sourceManager = sourceManager,
        stateListenable =
            StateNotifier(_initalState(sourcePreferences, sourceManager));
  // super(_initalState(sourcePreferences, sourceManager));

  static HomeScreenState _initalState(
      SourcePreferences preferences, SourceManager manager) {
    final category = preferences.lastUsedExtensionCategory().get();
    final sourceId = preferences.lastUsedSourceByCategory(category).get();
    final lastUsed =
        manager.getSource(sourceId, category)?.let((source) => InstalledSource(
              category: category,
              id: source.id,
              name: source.name,
              language: source.lang,
              version: '',
              icon: null,
              isUsedLast: true,
            ));

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

    final result = await _getFulHomePageUseCase(state.selectedSource.let(
        (it) => GetFullHomePageParams(sourceId: it.id, category: it.category)));

    final HomeScreenState newState;
    if (result.isFailure) {
      newState = state.copyWith(
        data: AsyncValue.error(result.exceptionOrNull()!),
      );
    } else {
      newState = state.copyWith(
        data: AsyncValue.data(result.getOrNull()!),
      );
    }

    stateListenable.setState(newState);
  }

  Future<void> loadNextPage(int page, HomePageRequest request) async {
    assert(page > 1);
    assert(stateListenable is HomeScreenStateWithSource);
    assert(stateListenable.state.data.hasData);

    final state = stateListenable as HomeScreenStateWithSource;

    final result = await _getHomePageUseCase(
        state.selectedSource.let((it) => GetHomePageParams(
              sourceId: it.id,
              category: it.category,
              page: page,
              request: request,
            )));

    try {
      final data = state.data.getOrThrow();

      final homepage = data[request]!;

      if (result.isSuccess) {
        final newHomePage = homepage + result.getOrThrow();

        data[request] = newHomePage;

        final newState = state.copyWith(
          data: AsyncValue.data(data),
        );

        stateListenable.setState(newState);
      }
    } catch (_) {}
  }
}
