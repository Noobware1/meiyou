import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meiyou/core/resources/expections.dart';
import 'package:meiyou/core/resources/provider_type.dart';
import 'package:meiyou/core/resources/providers/base_provider.dart';
import 'package:meiyou/domain/entities/search_response.dart';
import 'package:meiyou/domain/repositories/cache_repository.dart';
import 'package:meiyou/domain/usecases/provider_use_cases/find_best_search_response.dart';
import 'package:meiyou/domain/usecases/provider_use_cases/save_search_response.dart';

part 'selected_search_response_event.dart';
part 'selected_search_response_state.dart';

class SelectedSearchResponseBloc
    extends Bloc<SelectedSearchResponseEvent, SelectedSearchResponseState> {
  final FindBestSearchResponseUseCase findBestSearchResponseUseCase;
  final SaveSearchResponseUseCase saveSearchResponseUseCase;
  final String _mediaTitle;
  final CacheRespository cacheRespository;

  SelectedSearchResponseBloc({
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
  }

  FutureOr<void> onFindBestSearchResponseFromList(
      FindBestSearchResponseFromList event,
      Emitter<SelectedSearchResponseState> emit) {
    emit(SelectedSearchResponseFinding(
      _mediaTitle,
      // event.provider
    ));

    if (event.searchResponses != null && event.searchResponses!.isNotEmpty) {
      final best = findBestSearchResponseUseCase.call(
          FindBestSearchResponseParams(
              responses: event.searchResponses!, type: event.type));

      emit(SelectedSearchResponseFound(
        best.title, best,
        // event.provider
      ));
    } else {
      emit(SelectedSearchResponseNotFound(
        _mediaTitle,
        event.error ?? MeiyouException('Could Not Find $_mediaTitle'),
        // event.provider
      ));
    }
  }

  FutureOr<void> onSelectSearchResponseFromUserSelection(
      SelectSearchResponseFromUserSelection event,
      Emitter<SelectedSearchResponseState> emit) async {
    await saveSearchResponseUseCase.call(SaveSearchResponseUseCaseParams(
        provider: event.provider,
        searchResponse: event.searchResponse,
        cacheRespository: cacheRespository));

    emit(SelectedSearchResponseSelected(
      event.searchResponse.title, event.searchResponse,
      // event.provider
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
}
