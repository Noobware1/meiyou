import 'package:meiyou/notifers/state_notifer.dart';
import 'package:meiyou/presentation/info/services/episode_notifer.dart';
import 'package:meiyou_extensions_lib/models.dart';
import 'package:nice_dart/nice_dart.dart';

typedef MappedEpisodeChunks = Map<String, Pair<int, int>>;

class EpisodeListSelectorNotifer extends StateNotifer<Pair<int, int>> {
  EpisodeListSelectorNotifer({
    required int index,
    required EpisodeNotifer episodeNotifer,
    required List<Episode> episodes,
  })  : _episodeNotifer = episodeNotifer,
        super(_initalState(index, _generate(episodes)));

  late final EpisodeNotifer _episodeNotifer;

  static MappedEpisodeChunks _episodesKeyAndIndexes = {};

  MappedEpisodeChunks get episodesKeyAndIndexes => _episodesKeyAndIndexes;

  bool get hasChunks =>
      _episodesKeyAndIndexes.isNotEmpty && _episodesKeyAndIndexes.length > 1;

  void select(Pair<int, int> selected) {
    setState(selected);
    _episodeNotifer.select(selected.first);
  }

  int get index => _episodesKeyAndIndexes.values
      .toList()
      .indexWhere(
        (element) =>
            element.first == state.first && element.second == state.second,
      )
      .let((it) => it == -1 ? 0 : it);

  void initEpisodes(int? index, List<Episode> episodes) {
    setState(_initalState(index, _generate(episodes)));
  }

  bool inRange(int index) => state.first <= index && index <= state.second;

  static Pair<int, int> _initalState(int? index, MappedEpisodeChunks episodes) {
    if (index != null) {
      episodes.values.toList()[index];
    }

    return episodes.values.first;
  }

  static MappedEpisodeChunks _generate(List<Episode> episodes) {
    // assert(episodes.length > 26);
    if (episodes.length < 26) {
      return {
        '1-${episodes.length}': Pair(0, episodes.lastIndex),
      };
    }
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

    _episodesKeyAndIndexes = map;
    return _episodesKeyAndIndexes;
  }
}
