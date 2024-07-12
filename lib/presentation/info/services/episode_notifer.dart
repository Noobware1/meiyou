import 'package:meiyou/core/utils/resources/get_it/get_it.dart';
import 'package:meiyou/notifers/state_notifer.dart';

import 'package:meiyou/presentation/info/services/season_selector.dart';
import 'package:meiyou_extensions_lib/models.dart';
import 'package:nice_dart/nice_dart.dart';

class EpisodeNotifer extends StateNotifer<int> {
  EpisodeNotifer(super.initialState);

  Episode episode(Content content) {
    return content.when(
      series: (series) =>
          getIt.get<SeasonSelectorNotifer>().season(series).episodes[state],
      anime: (anime) => anime.episodes[state],
      lazy: (_) => _throwException(),
      movie: (_) => _throwException(),
    );
  }

  bool hasNext(Content content) {
    return content.when(
      series: (series) =>
          getIt.get<SeasonSelectorNotifer>().season(series).episodes.lastIndex >
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
    setState(index);
  }

  void next() {
    setState(state + 1);
  }

  void previous() {
    setState(state - 1);
  }

  Never _throwException() {
    throw Exception('Invalid content type!');
  }
}
