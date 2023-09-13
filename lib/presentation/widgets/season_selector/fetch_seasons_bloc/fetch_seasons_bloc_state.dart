part of 'fetch_seasons_bloc_bloc.dart';

sealed class FetchSeasonsState extends Equatable {
  final List<SeasonEntity>? seasons;
  final MeiyouException? error;
  const FetchSeasonsState({this.seasons, this.error});

  @override
  List<Object> get props => [seasons!, error!];
}

final class FetchingSeasons extends FetchSeasonsState {
  const FetchingSeasons();
}



final class FetchSeasonsSuccess extends FetchSeasonsState {
  const FetchSeasonsSuccess(List<SeasonEntity> seasons)
      : super(seasons: seasons);
}

final class FetchSeasonsFailed extends FetchSeasonsState {
  const FetchSeasonsFailed(MeiyouException error) : super(error: error);
}




