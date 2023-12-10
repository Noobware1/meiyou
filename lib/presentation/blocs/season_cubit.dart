import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meiyou/presentation/blocs/episodes_bloc.dart';
import 'package:meiyou_extenstions/models.dart';

class SeasonCubit extends Cubit<SeasonData> {
  final EpisodesCubit _episodesCubit;

  SeasonCubit(SeasonList data, this._episodesCubit) : super(data.season) {
    _episodesCubit.updateEpisodes(data.episodes);
  }

  void updateSeason(SeasonList season) {
    emit(season.season);

    _episodesCubit.updateEpisodes(season.episodes);
  }
}
