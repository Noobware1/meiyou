import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meiyou/core/resources/expections.dart';
import 'package:meiyou/core/resources/providers/base_provider.dart';
import 'package:meiyou/core/resources/response_state.dart';
import 'package:meiyou/core/usecases/no_params.dart';
import 'package:meiyou/domain/repositories/watch_provider_repository.dart';
import 'package:meiyou/domain/usecases/provider_use_cases/provider_search_with_media_use_case.dart';
import 'package:meiyou/presentation/pages/info_watch/state/search_response_bloc/bloc/search_response_bloc.dart';
part 'source_drop_down_event.dart';
part 'source_drop_down_state.dart';

class SourceDropDownBloc
    extends Bloc<SourceDropDownEvent, SourceDropDownState> {
  final WatchProviderRepository repository;
  final String title;
  final SearchResponseBloc searchResponseBloc;

  SourceDropDownBloc(
      {required this.repository,
      required this.title,
      required this.searchResponseBloc,
      required BaseProvider provider})
      : super(SourceDropDownSearchLoading(provider: provider)) {
    on<SourceDropDownOnSelected>(onSelected);
  }

  FutureOr<void> onSelected(
      SourceDropDownOnSelected event, Emitter<SourceDropDownState> emit) async {
    final provider = event.provider;
    emit(SourceDropDownSearchLoading(provider: provider));

    searchResponseBloc.add(SearchResponseSearching(title));

    final response = await ProviderSearchWithMediaUseCase(
            provider: provider, repository: repository)
        .call(noParams);

    if (response is ResponseSuccess) {
      final data = response.data!;

      emit(SourceDropDownSearchSuccess(provider: provider));

      searchResponseBloc.add(SearchResponseSearchSuccess(data, title));
    } else {
      emit(SourceDropDownSearchError(
          provider: provider, error: response.error!));
      searchResponseBloc.add(SearchResponseFailed(title));
    }
  }
}
