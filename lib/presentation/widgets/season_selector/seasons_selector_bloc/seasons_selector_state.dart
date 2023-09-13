part of 'seasons_selector_bloc.dart';

sealed class SeasonsSelectorState extends Equatable {
  final num season;
  final Map<String, List<EpisodeEntity>> episodes;

  const SeasonsSelectorState(this.season, this.episodes);

  @override
  List<Object> get props => [season, episodes];
}

final class SeasonSelected extends SeasonsSelectorState {
  const SeasonSelected(
      {num? season, Map<String, List<EpisodeEntity>>? episodes})
      : super(season ?? -1, episodes ?? const {'': []});
}
