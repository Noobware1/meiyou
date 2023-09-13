part of 'fetch_seasons_episodes_bloc.dart';

sealed class FetchSeasonsEpisodesState extends Equatable {
  final Map<num, List<EpisodeEntity>>? data;
  final MeiyouException? error;
  const FetchSeasonsEpisodesState({this.data, this.error});

  @override
  List<Object> get props => [data!, error!];
}

final class FetchSeasonsEpisodesLoading extends FetchSeasonsEpisodesState {
  const FetchSeasonsEpisodesLoading();
}

final class FetchSeasonsEpisodesFailed extends FetchSeasonsEpisodesState {
  const FetchSeasonsEpisodesFailed(MeiyouException error) : super(error: error);
}

final class FetchSeasonsEpisodesSucess extends FetchSeasonsEpisodesState {
  const FetchSeasonsEpisodesSucess(Map<num, List<EpisodeEntity>> data)
      : super(data: data);
}
