import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meiyou/core/resources/expections.dart';
import 'package:meiyou/core/resources/providers/base_provider.dart';
import 'package:meiyou/core/resources/response_state.dart';
import 'package:meiyou/domain/entities/search_response.dart';
import 'package:meiyou/domain/repositories/watch_provider_repository.dart';
import 'package:meiyou/domain/usecases/provider_use_cases/provider_search_use_case.dart';
import 'package:meiyou/presentation/pages/info_watch/state/selected_searchResponse_bloc/selected_search_response_bloc.dart';
part 'search_response_event.dart';
part 'search_response_state.dart';

class SearchResponseBloc
    extends Bloc<SearchResponseEvent, SearchResponseState> {
  final WatchProviderRepository repository;
  final SelectedSearchResponseBloc bloc;

  SearchResponseBloc(this.repository, this.bloc)
      : super(const SearchResponseSearching()) {
    on<SearchResponseSearch>(onSearchResponseSearch);
  }

  FutureOr<void> onSearchResponseSearch(
      SearchResponseSearch event, Emitter<SearchResponseState> emit) async {
    emit(const SearchResponseSearching());
    bloc.add(SearchResponseWaiting(repository.getMediaTitle()));
    final response = await ProviderSearchUseCase(repository).call(
        ProviderSearchParams(provider: event.provider, query: event.query));
    bloc.add(FindBestSearchResponseFromList(
        response.data, event.provider.providerType, response.error));
    if (response is ResponseSuccess) {
      emit(SearchResponseSuccess(response.data!));
    } else {
      emit(SearchResponseFailed(response.error));
    }
  }
}
