import 'package:meiyou/core/utils/resources/get_it/get_it.dart';
import 'package:meiyou/notifers/state_notifer.dart';

import 'package:meiyou/presentation/info/services/episode_list_selector.dart';
import 'package:meiyou/presentation/info/services/info_screen_notifer.dart';
import 'package:meiyou_extensions_lib/models.dart';

class SeasonSelectorNotifer extends StateNotifer<int> {
  SeasonSelectorNotifer(int? lastSeen) : super(lastSeen ?? 0);

  void select(int season) {
    if (season == state) return;
    setState(season);
    episodeListSelector.initEpisodes(null, episodes(season));
  }

  SeasonList season(Series series) => series.data[state];

  EpisodeListSelectorNotifer get episodeListSelector =>
      getIt.get<EpisodeListSelectorNotifer>();

  List<Episode> episodes(int season) {
    return getIt.get<InfoScreenNotifer>()
        .state
        .value!
        .content
        .series
        .data[season]
        .episodes;
  }
}

extension on Content? {
  Series get series => this as Series;
}
