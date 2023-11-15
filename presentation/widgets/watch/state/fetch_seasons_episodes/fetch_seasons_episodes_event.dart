part of 'fetch_seasons_episodes_bloc.dart';

sealed class FetchSeasonsEpisodesEvent extends Equatable {
  const FetchSeasonsEpisodesEvent();

  @override
  List<Object> get props => [];
}

class FetchSeasonsEpisodes extends FetchSeasonsEpisodesEvent {
  final BaseProvider provider;
  final SearchResponseEntity searchResponse;

  const FetchSeasonsEpisodes(this.provider, this.searchResponse);
}

class ClearFetchSeasonsEpisodesState extends FetchSeasonsEpisodesEvent {
  const ClearFetchSeasonsEpisodesState();
}
