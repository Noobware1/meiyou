part of 'fetch_episodes_bloc.dart';

sealed class FetchEpisodesEvent extends Equatable {
  final BaseProvider provider;

  final SeasonEntity season;
  const FetchEpisodesEvent({
    required this.provider,
    required this.season,
  });

  @override
  List<Object> get props => [provider, season];
}

final class FetchEpisodes extends FetchEpisodesEvent {
  const FetchEpisodes({
    required super.provider,
    required super.season,
  });
}

final class FetchEpisodeFailure extends FetchEpisodesEvent {
  const FetchEpisodeFailure({
    required super.provider,
    required super.season,
  });
}
