import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meiyou/domain/entities/episode.dart';
import 'package:meiyou/domain/usecases/provider_use_cases/get_episode_chunks_usecase.dart';
import 'package:meiyou/presentation/widgets/episode_selector/episode_selector/episode_selector_bloc.dart';

part 'seasons_selector_event.dart';
part 'seasons_selector_state.dart';

class SeasonsSelectorBloc
    extends Bloc<SeasonsSelectorEvent, SeasonsSelectorState> {
  // final FetchEpisodesBloc episodesBloc;
  // final CacheRespository cacheRespository;
  final EpisodeSelectorBloc episodeSelectorBloc;
  final GetEpisodeChunksUseCase getEpisodeChunksUseCase;

  SeasonsSelectorBloc(this.getEpisodeChunksUseCase, this.episodeSelectorBloc)
      : super(const SeasonSelected()) {
    on<SelectSeason>(onSeasonSelected);
  }

  FutureOr<void> onSeasonSelected(
      SelectSeason event, Emitter<SeasonsSelectorState> emit) {
    final episodes = getEpisodeChunksUseCase.call(event.epsiodes);
    episodeSelectorBloc.add(SelectEpisode(episodes.entries.first));

    emit(SeasonSelected(season: event.season, episodes: episodes));
  }
}
