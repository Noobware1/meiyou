part of 'episode_selector_bloc.dart';

sealed class EpisodeSelectorState extends Equatable {
  final String current;
  final List<EpisodeEntity> episodes;
  const EpisodeSelectorState({required this.episodes, required this.current});

  @override
  List<Object> get props => [episodes];
}

final class EpisodeSelectorSelected extends EpisodeSelectorState {
  const EpisodeSelectorSelected(
      {List<EpisodeEntity>? episodes, String? current})
      : super(
          current: current ?? '',
          episodes: episodes ?? const [],
        );
}
