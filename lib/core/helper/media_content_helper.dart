import 'package:collection/collection.dart';
import 'package:meiyou/shared/domain/models/media.dart';
import 'package:meiyou/shared/domain/models/media_content.dart';
import 'package:meiyou_extensions_lib/models.dart';
import 'package:nice_dart/nice_dart.dart';

typedef SeasonGroupedContent = Map<int, Map<String, List<MediaContent>>>;

class MediaContentHelper {
  static SeasonGroupedContent groupBySeasonAndSplit(
    List<MediaContent> contentList,
  ) {
    final groupedContent = contentList.groupListsBy((it) => it.season);

    return groupedContent.map((season, contentList) {
      final values = _splitList(contentList);
      final keys = _getChunksLength(values);

      return MapEntry(season, Map.fromIterables(keys, values));
    });
  }

  static List<List<MediaContent>> _splitList(List<MediaContent> episodes) {
    if (episodes.length <= 24 || episodes.length <= 26) {
      return [episodes];
    } else {
      const int chunkSize = 24;
      final int numChunks = (episodes.length / chunkSize).ceil();
      final List<List<MediaContent>> chunks = List<List<MediaContent>>.generate(
          numChunks,
          (i) => episodes.sublist(
              i * chunkSize,
              i * chunkSize + chunkSize > episodes.length
                  ? episodes.length
                  : i * chunkSize + chunkSize));
      return chunks;
    }
  }

  static Iterable<String> _getChunksLength(List<List<MediaContent>> chunks) {
    if (chunks.length == 1) {
      return chunks.map((ep) => '${ep.length}');
    } else {
      return chunks
          .mapIndexed((index, ep) => '${ep.first.number}-${ep.last.number}');
    }
  }

  static String getDefaultName(
    MediaContent content,
    Media media,
  ) {
    switch (media.format) {
      case MediaFormat.movie:
      case MediaFormat.animeMovie:
      case MediaFormat.documentary:
        return media.title;
      case MediaFormat.tvSeries:
      case MediaFormat.asainDrama:
        return 'Episode ${content.number}'.let((it) {
          if (content.season > 0) {
            return 'S${content.season}: $it';
          }
          return it;
        });
      case MediaFormat.cartoon:
      case MediaFormat.anime:
      case MediaFormat.ova:
      case MediaFormat.ona:
        return 'Episode ${content.number}';
      case MediaFormat.lightNovel:
      case MediaFormat.webNovel:
      case MediaFormat.novel:
      case MediaFormat.manga:
      case MediaFormat.webtoon:
      case MediaFormat.comic:
        return 'Chapter ${content.number}';
      case MediaFormat.others:
        return 'No Title';
    }
  }
}
