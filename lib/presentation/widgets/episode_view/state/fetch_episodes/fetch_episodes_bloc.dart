import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meiyou/core/resources/expections.dart';
import 'package:meiyou/core/resources/response_state.dart';
import 'package:meiyou/domain/entities/episode.dart';
import 'package:meiyou/core/resources/providers/base_provider.dart';
import 'package:meiyou/domain/entities/media_details.dart';
import 'package:meiyou/core/usecases_container/cache_repository_usecase_container.dart';
import 'package:meiyou/domain/repositories/cache_repository.dart';
import 'package:meiyou/domain/usecases/get_mapped_episodes_usecase.dart';
import 'package:meiyou/domain/usecases/provider_use_cases/load_episode_usecase.dart';
import 'package:meiyou/domain/usecases/provider_use_cases/get_episode_chunks_usecase.dart';

import 'package:meiyou/presentation/widgets/episode_view/state/episode_selector/episode_selector_bloc.dart';

part 'fetch_episodes_event.dart';
part 'fetch_episodes_state.dart';

class FetchEpisodesBloc extends Bloc<FetchEpisodesEvent, FetchEpisodesState> {
  final LoadEpisodeUseCase loadEpisodeUseCase;
  final GetEpisodeChunksUseCase getEpisodeChunksUseCase;
  final CacheRespository cacheRespository;
  final MediaDetailsEntity mediaDetails;
  final EpisodeSelectorBloc episodeSelectorBloc;
  final GetMappedEpisodesUseCase getMappedEpisodesUseCase;

  FetchEpisodesBloc(
      {required this.loadEpisodeUseCase,
      required this.cacheRespository,
      required this.mediaDetails,
      required this.getEpisodeChunksUseCase,
      required this.episodeSelectorBloc,
      required this.getMappedEpisodesUseCase})
      : super(const FetchEpisodesLoading()) {
    on<FetchEpisodes>(onFetchEpisode);
    on<FetchEpisodeFailure>(onFetchEpisodeFailure);
  }

  FutureOr<void> onFetchEpisode(
      FetchEpisodes event, Emitter<FetchEpisodesState> emit) async {
    emit(const FetchEpisodesLoading());

    final response = await loadEpisodeUseCase.call(event.params);

    if (response is ResponseSuccess && response.data!.isNotEmpty) {
      final episodes = getEpisodeChunksUseCase.call(
          await getMappedEpisodesUseCase.call(GetMappedEpisodesParams(
              cacheRepository: cacheRespository,
              episodes: response.data!,
              season: event.params.season,
              mediaDetails: mediaDetails)));

      emit(FetchEpisodesSuccess(episodes));

      final defaultEpisode = episodes.entries.first;

      episodeSelectorBloc.add(SelectEpisode(defaultEpisode));
    } else {
      print(response.error!);
      emit(FetchEpisodesFailed(response.error!));
    }
  }

  FutureOr<void> onFetchEpisodeFailure(
      FetchEpisodeFailure event, Emitter<FetchEpisodesState> emit) {
    emit(const FetchEpisodesFailed(MeiyouException('No url sepcified')));
  }
}
