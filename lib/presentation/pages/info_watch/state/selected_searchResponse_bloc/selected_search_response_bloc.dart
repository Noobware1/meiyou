import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meiyou/core/resources/expections.dart';
import 'package:meiyou/core/resources/provider_type.dart';
import 'package:meiyou/core/resources/providers/base_provider.dart';
import 'package:meiyou/domain/entities/search_response.dart';
import 'package:meiyou/domain/repositories/cache_repository.dart';
import 'package:meiyou/domain/usecases/provider_use_cases/find_best_search_response.dart';
import 'package:meiyou/domain/usecases/provider_use_cases/load_saved_search_response.dart';
import 'package:meiyou/domain/usecases/provider_use_cases/save_search_response.dart';

part 'selected_search_response_event.dart';
part 'selected_search_response_state.dart';

class SelectedSearchResponseBloc
    extends Bloc<SelectedSearchResponseEvent, SelectedSearchResponseState> {
  final FindBestSearchResponseUseCase findBestSearchResponseUseCase;
  final SaveSearchResponseUseCase saveSearchResponseUseCase;

  final LoadSavedSearchResponseUseCase loadSavedSearchResponseUseCase;
  final String _mediaTitle;
  final CacheRespository cacheRespository;
  final String savePath;

  SelectedSearchResponseBloc({
    required this.loadSavedSearchResponseUseCase,
    required this.savePath,
    required this.cacheRespository,
    required this.saveSearchResponseUseCase,
    required this.findBestSearchResponseUseCase,
    required String mediaTitle,
  })  : _mediaTitle = mediaTitle,
        super(SelectedSearchResponseFinding(
          mediaTitle,
          // /event.provider
        )) {
    on<FindBestSearchResponseFromList>(onFindBestSearchResponseFromList);

    on<SelectSearchResponseFromUserSelection>(
        onSelectSearchResponseFromUserSelection);

    on<SearchResponseWaiting>(onSearchResponseWaiting);

    on<LoadSavedSearchResponseFromCache>(onLoadSavedSearchResponseFromCache);
  }

  FutureOr<void> onFindBestSearchResponseFromList(
      FindBestSearchResponseFromList event,
      Emitter<SelectedSearchResponseState> emit) async {
    await _findBestSearchResponse(
        searchResponses: event.searchResponses,
        provider: event.provider,
        emit: emit,
        error: event.error);
  }

  Future<void> _findBestSearchResponse(
      {required List<SearchResponseEntity>? searchResponses,
      required BaseProvider provider,
      MeiyouException? error,
      required Emitter<SelectedSearchResponseState> emit}) async {
    emit(SelectedSearchResponseFinding(
      _mediaTitle,
      // event.provider
    ));

    if (searchResponses != null && searchResponses!.isNotEmpty) {
      final best = findBestSearchResponseUseCase.call(
          FindBestSearchResponseParams(
              responses: searchResponses!, type: provider.providerType));
      await _saveResponse(provider, best);
      emit(SelectedSearchResponseFound(
        best.title, best,
        // event.provider
      ));
    } else {
      emit(SelectedSearchResponseNotFound(
        _mediaTitle,
        error ?? MeiyouException('Could Not Find $_mediaTitle'),
        // event.provider
      ));
    }
  }

  FutureOr<void> onSelectSearchResponseFromUserSelection(
      SelectSearchResponseFromUserSelection event,
      Emitter<SelectedSearchResponseState> emit) async {
    emit(SelectedSearchResponseSelected(
      event.searchResponse.title, event.searchResponse,
      // event.provider
    ));
  }

  Future<void> _saveResponse(
      BaseProvider provider, SearchResponseEntity searchResponse) {
    return saveSearchResponseUseCase.call(SaveSearchResponseUseCaseParams(
      savePath: savePath,
      provider: provider,
      searchResponse: searchResponse,
    ));
  }

  // void _invokeFetchEpisodeForAnime(
  //     BaseProvider provider, SearchResponseEntity response) {
  //   if (response.type == MediaType.anime) {
  //     fetchEpisodesBloc.add(FetchEpisodes(
  //         LoadEpisodeParams(provider: provider, url: response.url)));
  //   }
  // }

  FutureOr<void> onSearchResponseWaiting(
      SearchResponseWaiting event, Emitter<SelectedSearchResponseState> emit) {
    emit(SelectedSearchResponseFinding(
      event.title,
      // event.provider
    ));
  }

  Future<SearchResponseEntity?> _loadSavedResponse(BaseProvider provider) {
    return loadSavedSearchResponseUseCase.call(
        LoadSavedSearchResponseUseCaseParams(
            savePath: savePath, provider: provider));
  }

  FutureOr<void> onLoadSavedSearchResponseFromCache(
      LoadSavedSearchResponseFromCache event,
      Emitter<SelectedSearchResponseState> emit) async {
    final cache = await _loadSavedResponse(event.provider);
    if (cache == null) {
      await _findBestSearchResponse(
          searchResponses: event.searchResponses,
          provider: event.provider,
          emit: emit,
          error: event.error);
    } else {
      emit(SelectedSearchResponseSelected(cache.title, cache));
    }
  }
}
