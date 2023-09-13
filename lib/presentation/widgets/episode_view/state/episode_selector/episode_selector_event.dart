part of 'episode_selector_bloc.dart';

sealed class EpisodeSelectorEvent extends Equatable {

  final MapEntry<String, List<EpisodeEntity>> entry;

  const EpisodeSelectorEvent(this.entry);

  @override
  List<Object> get props => [entry];
}

final class SelectEpisode extends EpisodeSelectorEvent {
  const SelectEpisode(super.entry);
}
