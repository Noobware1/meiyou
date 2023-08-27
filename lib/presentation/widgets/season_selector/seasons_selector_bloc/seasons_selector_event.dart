part of 'seasons_selector_bloc.dart';

sealed class SeasonsSelectorEvent extends Equatable {
  final SeasonEntity season;
  final BaseProvider provider;
  const SeasonsSelectorEvent(this.season, this.provider);

  @override
  List<Object> get props => [season, provider];
}

final class SelectSeason extends SeasonsSelectorEvent {
  const SelectSeason(super.season, super.provider);
}
