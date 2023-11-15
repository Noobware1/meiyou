part of 'seasons_selector_bloc.dart';

sealed class SeasonsSelectorEvent extends Equatable {
  final num season;
  final List<EpisodeEntity> epsiodes;
  const SeasonsSelectorEvent(this.season, this.epsiodes);

  @override
  List<Object> get props => [season, epsiodes];
}

final class SelectSeason extends SeasonsSelectorEvent {
  const SelectSeason(super.season, super.epsiodes);
}
