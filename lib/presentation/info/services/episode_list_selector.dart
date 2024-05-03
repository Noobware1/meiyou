import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meiyou/presentation/info/services/episode_cubit.dart';
import 'package:meiyou_extensions_lib/models.dart';
import 'package:nice_dart/nice_dart.dart';

typedef MappedEpisodeChunks = Map<String, Pair<int, int>>;

class EpisodeListSelectorCubit extends Cubit<Pair<int, int>> {
  EpisodeListSelectorCubit({
    required EpisodeCubit episodeCubit,
    required List<Episode> episodes,
  })  : _episodeCubit = episodeCubit,
        super(_initalState(episodes)) {
    episodesKeyAndIndexes = _generate(episodes);
  }

  late final EpisodeCubit _episodeCubit;

  late MappedEpisodeChunks episodesKeyAndIndexes;

  bool get hasChunks => episodesKeyAndIndexes.isNotEmpty;

  void select(Pair<int, int> selected) {
    emit(selected);
    _episodeCubit.select(selected.first);
  }

  void initEpisodes(List<Episode> episodes) {
    emit(_initalState(episodes));
    episodesKeyAndIndexes = _generate(episodes);
  }

  bool inRange(int index) => state.first <= index && index <= state.second;

  static Pair<int, int> _initalState(List<Episode> episodes) {
    return Pair(0, episodes.length > 26 ? 25 : episodes.lastIndex);
  }

  static MappedEpisodeChunks _generate(List<Episode> episodes) {
    if (episodes.length > 26) return {};
    const int chunkSize = 26;
    final int numChunks = (episodes.length / chunkSize).ceil();

    final Map<String, Pair<int, int>> map = {};
    for (var i = 0; i < numChunks; i++) {
      final start = i * chunkSize;
      final end = (i * chunkSize + chunkSize > episodes.length
              ? episodes.length
              : i * chunkSize + chunkSize) -
          1;
      map['${episodes[start].number ?? (start + 1)}-${episodes[end].number ?? (end + 1)}'] =
          Pair(start, end);
    }

    return map;
  }
}
