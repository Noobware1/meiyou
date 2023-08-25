part of 'fetch_seasons_bloc_bloc.dart';

sealed class FetchSeasonsEvent extends Equatable {
  final BaseProvider provider;
  final SearchResponseEntity searchResponse;
  const FetchSeasonsEvent(this.provider, this.searchResponse);
  @override
  List<Object> get props => [provider, searchResponse];
}

final class FetchSeasons extends FetchSeasonsEvent {
  const FetchSeasons(BaseProvider provider, SearchResponseEntity searchResponse)
      : super(provider, searchResponse);
}
