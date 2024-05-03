import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injecktor/injecktor.dart';
import 'package:meiyou/presentation/info/services/season_selector.dart';
import 'package:meiyou_extensions_lib/models.dart';
import 'package:nice_dart/nice_dart.dart';

class EpisodeCubit extends Cubit<int> {
  EpisodeCubit(super.initialState);

  Episode episode(Content content) {
    return content.when(
      series: (series) =>
          InjectKtor.get<SeasonSelectorCubit>().season(series).episodes[state],
      anime: (anime) => anime.episodes[state],
      lazy: (_) => _throwException(),
      movie: (_) => _throwException(),
    );
  }

  bool hasNext(Content content) {
    return content.when(
      series: (series) =>
          InjectKtor.get<SeasonSelectorCubit>()
              .season(series)
              .episodes
              .lastIndex >
          state,
      anime: (anime) => anime.episodes.lastIndex > state,
      lazy: (_) => _throwException(),
      movie: (_) => _throwException(),
    );
  }

  bool hasPrevious() {
    return state > 0;
  }

  void select(int index) {
    emit(index);
  }

  void next() {
    emit(state + 1);
  }

  void previous() {
    emit(state - 1);
  }

  Never _throwException() {
    throw Exception('Invalid content type!');
  }
}
