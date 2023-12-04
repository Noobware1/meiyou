import 'package:meiyou/core/utils/extenstions/iterable.dart';
import 'package:meiyou/data/models/episode.dart';
import 'package:meiyou/domain/entities/episode.dart';

class GenerateEpisodesChunks {
  static Map<String, List<EpisodeEntity>> buildEpisodesResponse(
      List<EpisodeEntity> episodes) {
    final values = splitList(episodes);
    final keys = getChunksLength(values);

    return Map.fromIterables(keys, values);
  }

  static List<List<EpisodeEntity>> splitList(List<EpisodeEntity> episodes) {
    if (episodes.length <= 24 || episodes.length <= 26) {
      return [episodes];
    } else {
      const int chunkSize = 24;
      final int numChunks = (episodes.length / chunkSize).ceil();
      final List<List<EpisodeEntity>> chunks = List<List<EpisodeEntity>>.generate(
          numChunks,
          (i) => episodes.sublist(
              i * chunkSize,
              i * chunkSize + chunkSize > episodes.length
                  ? episodes.length
                  : i * chunkSize + chunkSize));
      return chunks;
    }
  }

  static Iterable<String> getChunksLength(List<List<EpisodeEntity>> chunks) {
    if (chunks.length == 1) {
      return chunks.map((ep) => '${ep.length}');
    } else {
      return chunks.mapWithIndex((index, ep) =>
          '${ep.first.episode ?? index + 1}-${ep.last.episode ?? index + 1}');
    }
  }
}
