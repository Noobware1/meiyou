import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meiyou/core/resources/providers/base_provider.dart';
import 'package:meiyou/domain/entities/season.dart';
import 'package:meiyou/presentation/widgets/episode_view/bloc/fetch_episodes/fetch_episodes_bloc.dart';

part 'seasons_selector_event.dart';
part 'seasons_selector_state.dart';

class SeasonsSelectorBloc
    extends Bloc<SeasonsSelectorEvent, SeasonsSelectorState> {
  final FetchEpisodesBloc episodesBloc;

  SeasonsSelectorBloc(this.episodesBloc) : super(const SeasonSelected()) {
    on<SelectSeason>(onSeasonSelected);
  }

  FutureOr<void> onSeasonSelected(
      SelectSeason event, Emitter<SeasonsSelectorState> emit) {
    final season = event.season;
    emit(SeasonSelected(season));
    // if (season != SeasonEntity.empty &&
    //     season.url != null &&
    //     season.url!.isNotEmpty) {
    //   episodesBloc.add(FetchEpisodes(provider: event.provider, season: season));
    // } else {
    //   episodesBloc.add(FetchEpisodeFailure(provider: event.provider, season: season));

    // }
  }
}
