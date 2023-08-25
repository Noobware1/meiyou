part of 'seasons_selector_bloc.dart';

sealed class SeasonsSelectorEvent extends Equatable {
  final SeasonEntity season;
  const SeasonsSelectorEvent(this.season);

  @override
  List<Object> get props => [season];
}

final class SelectSeason extends SeasonsSelectorEvent {
  const SelectSeason(super.season);
}
