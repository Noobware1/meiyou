import 'package:meiyou/shared/domain/models/media.dart';
import 'package:meiyou/shared/domain/models/media_content.dart';
import 'package:meiyou_extensions_lib/models.dart';
import 'package:nice_dart/nice_dart.dart';

class MediaContentHelper {
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
