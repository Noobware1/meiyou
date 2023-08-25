import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meiyou/core/resources/expections.dart';
import 'package:meiyou/core/resources/response_state.dart';
import 'package:meiyou/domain/entities/episode.dart';
import 'package:meiyou/core/resources/providers/base_provider.dart';
import 'package:meiyou/domain/repositories/watch_provider_repository.dart';
import 'package:meiyou/domain/usecases/provider_use_cases/load_episode_usecase.dart';

part 'fetch_episodes_event.dart';
part 'fetch_episodes_state.dart';

class FetchEpisodesBloc extends Bloc<FetchEpisodesEvent, FetchEpisodesState> {
  final WatchProviderRepository _repository;

  FetchEpisodesBloc(WatchProviderRepository repository)
      : _repository = repository,
        super(const FetchEpisodesLoading()) {
    on<FetchEpisodes>(onFetchEpisode);
  }

  FutureOr<void> onFetchEpisode(
      FetchEpisodes event, Emitter<FetchEpisodesState> emit) async {
    final response = await LoadEpisodeUseCase(
      _repository,
    ).call(LoadEpisodeParams(
        provider: event.provider,
        url: event.url,
        seasonNumber: event.seasonNumber));

        
    if (response is ResponseSuccess) {
      emit(FetchEpisodesSuccess(response.data!));
    } else {
      emit(FetchEpisodesFailed(response.error!));
    }
  }
}
