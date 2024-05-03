import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injecktor/injecktor.dart';
import 'package:meiyou/presentation/info/services/episode_list_selector.dart';
import 'package:meiyou/presentation/info/services/info_screen_cubit.dart';
import 'package:meiyou_extensions_lib/models.dart';

class SeasonSelectorCubit extends Cubit<int> {
  SeasonSelectorCubit() : super(0);

  void select(int season) {
    if (season == state) return;
    emit(season);
    episodeListSelector.initEpisodes(episodes(season));
  }

  SeasonList season(Series series) => series.data[state];

  EpisodeListSelectorCubit get episodeListSelector =>
      InjectKtor.get<EpisodeListSelectorCubit>();

  List<Episode> episodes(int season) {
    return InjectKtor.get<InfoScreenCubit>()
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
