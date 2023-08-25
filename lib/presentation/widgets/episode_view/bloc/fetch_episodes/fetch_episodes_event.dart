part of 'fetch_episodes_bloc.dart';

sealed class FetchEpisodesEvent extends Equatable {
  final BaseProvider provider;
  final String url;
  final int seasonNumber;
  final List<EpisodeEntity> episodes;
  const FetchEpisodesEvent(
      {required this.provider,
      required this.url,
      required this.seasonNumber,
      required this.episodes});

  @override
  List<Object> get props => [provider, url, seasonNumber, episodes];
}

final class FetchEpisodes extends FetchEpisodesEvent {
  const FetchEpisodes(
      {required super.provider,
      required super.url,
      super.seasonNumber = 1,
      super.episodes = const []});
}
