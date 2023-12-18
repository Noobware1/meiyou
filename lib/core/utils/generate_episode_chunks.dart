import 'package:meiyou_extensions_lib/extenstions.dart';
import 'package:meiyou_extensions_lib/models.dart';

class GenerateEpisodesChunks {
  static Map<String, List<Episode>> buildEpisodesResponse(
      List<Episode> episodes) {
    final values = splitList(episodes);
    final keys = getChunksLength(values);

    return Map.fromIterables(keys, values);
  }

  static List<List<Episode>> splitList(List<Episode> episodes) {
    if (episodes.length <= 24 || episodes.length <= 26) {
      return [episodes];
    } else {
      const int chunkSize = 24;
      final int numChunks = (episodes.length / chunkSize).ceil();
      final List<List<Episode>> chunks = List<List<Episode>>.generate(
          numChunks,
          (i) => episodes.sublist(
              i * chunkSize,
              i * chunkSize + chunkSize > episodes.length
                  ? episodes.length
                  : i * chunkSize + chunkSize));
      return chunks;
    }
  }

  static Iterable<String> getChunksLength(List<List<Episode>> chunks) {
    if (chunks.length == 1) {
      return chunks.map((ep) => '${ep.length}');
    } else {
      return chunks.mapWithIndex((index, ep) =>
          '${ep.first.episode ?? index + 1}-${ep.last.episode ?? index + 1}');
    }
  }
}
