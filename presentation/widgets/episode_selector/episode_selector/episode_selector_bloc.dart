import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meiyou/domain/entities/episode.dart';

part 'episode_selector_event.dart';
part 'episode_selector_state.dart';

class EpisodeSelectorBloc
    extends Bloc<EpisodeSelectorEvent, EpisodeSelectorState> {
  EpisodeSelectorBloc(MapEntry<String, List<EpisodeEntity>> current)
      : super(EpisodeSelectorSelected(
          current: current.key,
          episodes: current.value,
        )) {
    on<SelectEpisode>(onSelectEpisode);
  }

  FutureOr<void> onSelectEpisode(
      SelectEpisode event, Emitter<EpisodeSelectorState> emit) {
    final entry = event.entry;

    emit(EpisodeSelectorSelected(
      episodes: entry.value,
      current: entry.key,
    ));
  }
}
