import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meiyou/core/utils/find_best_search_response.dart';
import 'package:meiyou/domain/entities/search_response.dart';

part 'search_response_event.dart';
part 'search_response_state.dart';

class SearchResponseBloc
    extends Bloc<SearchResponseEvent, SearchResponseState> {
  SearchResponseBloc()
      : super(const SearchResponseStateLoading('Searching...')) {
    on<SearchResponseSearching>(onSearchReponseSearching);
    on<SearchResponseSearchSuccess>(onSearchReponseSearchSuccess);
    on<SearchResponseFailed>(onSearchReponseFailed);
  }

  FutureOr<void> onSearchReponseSearching(
      SearchResponseSearching event, Emitter<SearchResponseState> emit) {
    emit(SearchResponseStateLoading(event.title));
  }

  FutureOr<void> onSearchReponseSearchSuccess(
      SearchResponseSearchSuccess event, Emitter<SearchResponseState> emit) {
    final searchResponses = event.searchResponses!;
    if (searchResponses.isNotEmpty) {
      final best = findBestSearchResponse(searchResponses, event.title);
      emit(SearchResponseStateWithData(
          title: best.title,
          searchResponse: best,
          searchResponses: searchResponses));
    } else {
      emit(SearchResponseStateWithNoData(event.title));
    }
  }

  FutureOr<void> onSearchReponseFailed(
      SearchResponseFailed event, Emitter<SearchResponseState> emit) {
    emit(SearchResponseStateWithNoData(event.title));
  }
}
