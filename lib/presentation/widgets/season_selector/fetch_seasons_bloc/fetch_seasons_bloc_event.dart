part of 'fetch_seasons_bloc_bloc.dart';

sealed class FetchSeasonsEvent extends Equatable {
  final BaseProvider provider;
  final SearchResponseEntity searchResponse;
  // final CacheRespository cacheRespository;
  const FetchSeasonsEvent(
    this.provider,
    this.searchResponse,
    // this.cacheRespository
  );
  @override
  List<Object> get props => [provider, searchResponse];
}

final class FetchSeasons extends FetchSeasonsEvent {
  const FetchSeasons(
    super.provider,
    super.searchResponse,
    // super.cacheRespository
  );
}
