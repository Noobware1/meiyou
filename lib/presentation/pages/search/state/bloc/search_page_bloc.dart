import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meiyou/core/resources/expections.dart';
import 'package:meiyou/core/resources/response_state.dart';
import 'package:meiyou/core/utils/search_params.dart';
import 'package:meiyou/domain/entities/results.dart';
import 'package:meiyou/domain/usecases/get_meta_results_usecase.dart';

part 'search_page_event.dart';
part 'search_page_state.dart';

class SearchPageBloc extends Bloc<SearchPageEvent, SearchPageState> {
  SearchPageBloc(this.getSearchUseCase) : super(const SearchPageEmpty()) {
    on<Search>(onSearch);
  }

  final GetSearchUseCase getSearchUseCase;

  FutureOr<void> onSearch(Search event, Emitter<SearchPageState> emit) async {
    emit(const SearchPageLoading());
    final response =
        await getSearchUseCase.call(SearchParams(query: event.query));
    if (response is ResponseSuccess) {
      emit(SearchPageSucess(response.data!));
    } else if (response is ResponseFailed) {
      emit(SearchPageFailed(response.error!));
    } else {
      emit(const SearchPageEmpty());
    }
  }
}
