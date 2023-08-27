import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meiyou/core/resources/providers/base_provider.dart';
import 'package:meiyou/domain/repositories/watch_provider_repository.dart';
import 'package:meiyou/presentation/pages/info_watch/state/search_response_bloc/bloc/search_response_bloc.dart';

part 'source_drop_down_event.dart';
part 'source_drop_down_state.dart';

class SourceDropDownBloc
    extends Bloc<SourceDropDownEvent, SourceDropDownState> {
  // final WatchProviderRepository repository;
  // final MediaDetailsEntity media;
  final SearchResponseBloc searchResponseBloc;

  SourceDropDownBloc(
      {
        // required this.repository,
      required this.searchResponseBloc,
      required BaseProvider provider})
      : super(SourceDropDownSelected(provider)) {
    on<SourceDropDownOnSelected>(onSelected);
  }

  FutureOr<void> onSelected(
      SourceDropDownOnSelected event, Emitter<SourceDropDownState> emit) {
    final provider = event.provider;
    searchResponseBloc.add(SearchResponseSearch(
      provider: provider,
    ));

    emit(SourceDropDownSelected(provider));
  }
}
