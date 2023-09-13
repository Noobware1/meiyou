part of 'fetch_episodes_bloc.dart';

sealed class FetchEpisodesEvent extends Equatable {
  final LoadEpisodeParams params;
  // final CacheRespository cacheRespository;
  const FetchEpisodesEvent(
    this.params,
  );

  @override
  List<Object> get props => [params];
}

final class FetchEpisodes extends FetchEpisodesEvent {
  const FetchEpisodes(
    super.params,
  );
}

final class FetchEpisodeFailure extends FetchEpisodesEvent {
  FetchEpisodeFailure(BaseProvider provider)
      : super(
          LoadEpisodeParams(
            provider: provider,
            url: '',
          ),
        );
}
