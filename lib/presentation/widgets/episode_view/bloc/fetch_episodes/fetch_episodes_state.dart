part of 'fetch_episodes_bloc.dart';

sealed class FetchEpisodesState extends Equatable {
  final List<EpisodeEntity>? episodes;
  final MeiyouException? error;
  const FetchEpisodesState({this.episodes, this.error});

  @override
  List<Object> get props => [episodes!, error!];
}

final class FetchEpisodesLoading extends FetchEpisodesState {
  const FetchEpisodesLoading();
}

final class FetchEpisodesSuccess extends FetchEpisodesState {
  const FetchEpisodesSuccess(List<EpisodeEntity> episodes)
      : super(episodes: episodes);
}

final class FetchEpisodesFailed extends FetchEpisodesState {
  const FetchEpisodesFailed(MeiyouException error) : super(error: error);
}
