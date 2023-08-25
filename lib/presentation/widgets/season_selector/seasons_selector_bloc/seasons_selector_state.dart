part of 'seasons_selector_bloc.dart';

sealed class SeasonsSelectorState extends Equatable {
  final SeasonEntity season;

  const SeasonsSelectorState(this.season);

  @override
  List<Object> get props => [season];
}

final class SeasonSelected extends SeasonsSelectorState {
  const SeasonSelected([SeasonEntity? season])
      : super(season ?? SeasonEntity.empty);
}
