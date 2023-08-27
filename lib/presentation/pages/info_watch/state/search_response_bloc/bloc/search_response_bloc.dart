import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meiyou/core/resources/expections.dart';
import 'package:meiyou/core/resources/providers/base_provider.dart';
import 'package:meiyou/core/resources/response_state.dart';
import 'package:meiyou/domain/entities/search_response.dart';
import 'package:meiyou/domain/usecases/provider_use_cases/search_use_case.dart';
import 'package:meiyou/presentation/pages/info_watch/state/selected_searchResponse_bloc/selected_search_response_bloc.dart';

part 'search_response_event.dart';
part 'search_response_state.dart';

class SearchResponseBloc
    extends Bloc<SearchResponseEvent, SearchResponseState> {
  final LoadSearchUseCase providerSearchUseCase;
  final String mediaTitle;
  final SelectedSearchResponseBloc bloc;

  SearchResponseBloc(
      {required this.providerSearchUseCase,
      required this.bloc,
      required this.mediaTitle})
      : super(const SearchResponseSearching()) {
    on<SearchResponseSearch>(onSearchResponseSearch);
  }

  FutureOr<void> onSearchResponseSearch(
      SearchResponseSearch event, Emitter<SearchResponseState> emit) async {
    emit(const SearchResponseSearching());
    bloc.add(SearchResponseWaiting(mediaTitle));
    final response = await providerSearchUseCase.call(
        LoadSearchParams(provider: event.provider, query: event.query));
    bloc.add(FindBestSearchResponseFromList(
        response.data, event.provider.providerType, response.error));
    if (response is ResponseSuccess) {
      emit(SearchResponseSuccess(response.data!));
    } else {
      emit(SearchResponseFailed(response.error));
    }
  }
}
