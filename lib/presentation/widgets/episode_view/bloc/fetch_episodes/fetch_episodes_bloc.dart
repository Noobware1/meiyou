import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meiyou/core/resources/expections.dart';
import 'package:meiyou/core/resources/response_state.dart';
import 'package:meiyou/domain/entities/episode.dart';
import 'package:meiyou/core/resources/providers/base_provider.dart';
import 'package:meiyou/domain/entities/media_details.dart';
import 'package:meiyou/domain/entities/season.dart';
import 'package:meiyou/domain/repositories/cache_repository.dart';
import 'package:meiyou/domain/usecases/get_mapped_episodes_usecase.dart';
import 'package:meiyou/domain/usecases/provider_use_cases/load_episode_usecase.dart';

part 'fetch_episodes_event.dart';
part 'fetch_episodes_state.dart';

class FetchEpisodesBloc extends Bloc<FetchEpisodesEvent, FetchEpisodesState> {
  final LoadEpisodeUseCase loadEpisodeUseCase;
  final CacheRespository cacheRespository;
  final MediaDetailsEntity mediaDetails;

  final GetMappedEpisodesUseCase getMappedEpisodesUseCase;

  FetchEpisodesBloc(
      {required this.loadEpisodeUseCase,
      required this.cacheRespository,
      required this.mediaDetails,
      required this.getMappedEpisodesUseCase})
      : super(const FetchEpisodesLoading()) {
    on<FetchEpisodes>(onFetchEpisode);
    on<FetchEpisodeFailure>(onFetchEpisodeFailure);
  }

  FutureOr<void> onFetchEpisode(
      FetchEpisodes event, Emitter<FetchEpisodesState> emit) async {
    final response = await loadEpisodeUseCase.call(LoadEpisodeParams(
        provider: event.provider,
        url: event.season.url!,
        seasonNumber: event.season.number));

    if (response is ResponseSuccess && response.data!.isNotEmpty) {
      final episodes = await getMappedEpisodesUseCase.call(
          GetMappedEpisodesParams(
              cacheRespository: cacheRespository,
              episodes: response.data!,
              season: event.season,
              mediaDetails: mediaDetails));
      emit(FetchEpisodesSuccess(episodes));
    } else {
      emit(FetchEpisodesFailed(response.error!));
    }
  }

  FutureOr<void> onFetchEpisodeFailure(
      FetchEpisodeFailure event, Emitter<FetchEpisodesState> emit) {
    emit(const FetchEpisodesFailed(MeiyouException('No url sepcified')));
  }
}
