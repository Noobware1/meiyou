import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meiyou/core/resources/expections.dart';
import 'package:meiyou/core/resources/provider_type.dart';
import 'package:meiyou/domain/entities/search_response.dart';
import 'package:meiyou/domain/repositories/watch_provider_repository.dart';
import 'package:meiyou/domain/usecases/provider_use_cases/find_best_search_response.dart';

part 'selected_search_response_event.dart';
part 'selected_search_response_state.dart';

class SelectedSearchResponseBloc
    extends Bloc<SelectedSearchResponseEvent, SelectedSearchResponseState> {
  final FindBestSearchResponseUseCase findBestSearchResponseUseCase;
  final String _mediaTitle;

  SelectedSearchResponseBloc(
      {required this.findBestSearchResponseUseCase, required String mediaTitle})
      : _mediaTitle = mediaTitle,
        super(SelectedSearchResponseFinding(mediaTitle)) {
    on<FindBestSearchResponseFromList>(onFindBestSearchResponseFromList);

    on<SelectSearchResponseFromUserSelection>(
        onSelectSearchResponseFromUserSelection);

    on<SearchResponseWaiting>(onSearchResponseWaiting);
  }

  FutureOr<void> onFindBestSearchResponseFromList(
      FindBestSearchResponseFromList event,
      Emitter<SelectedSearchResponseState> emit) {
    emit(SelectedSearchResponseFinding(_mediaTitle));
    if (event.searchResponses != null && event.searchResponses!.isNotEmpty) {
      final best = findBestSearchResponseUseCase.call(
          FindBestSearchResponseParams(
              responses: event.searchResponses!, type: event.type));

      emit(SelectedSearchResponseFound(best.title, best));
    } else {
      emit(SelectedSearchResponseNotFound(
          _mediaTitle, event.error ?? MeiyouException('Could Not Find $_mediaTitle')));
    }
  }

  FutureOr<void> onSelectSearchResponseFromUserSelection(
      SelectSearchResponseFromUserSelection event,
      Emitter<SelectedSearchResponseState> emit) {
    final response = event.searchResponse;
    emit(SelectedSearchResponseFound(response.title, response));
  }

  FutureOr<void> onSearchResponseWaiting(
      SearchResponseWaiting event, Emitter<SelectedSearchResponseState> emit) {
    emit(SelectedSearchResponseFinding(event.title));
  }
}
