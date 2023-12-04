import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meiyou/domain/entities/season_data.dart';
import 'package:meiyou/domain/entities/season_list.dart';
import 'package:meiyou/presentation/blocs/episodes_bloc.dart';

class SeasonCubit extends Cubit<SeasonDataEntity> {
  final EpisodesCubit _episodesCubit;

  SeasonCubit(SeasonListEntity data, this._episodesCubit) : super(data.season) {
    _episodesCubit.updateEpisodes(data.episodes);
  }

  void updateSeason(SeasonListEntity season) {
    emit(season.season);

    _episodesCubit.updateEpisodes(season.episodes);
  }
}
