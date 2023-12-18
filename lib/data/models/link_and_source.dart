import 'package:meiyou/core/utils/from_entity.dart';
import 'package:meiyou/data/models/extracted_media.dart';
import 'package:meiyou/domain/entities/link_and_source.dart';
import 'package:meiyou_extensions_lib/extenstions.dart';
import 'package:meiyou_extensions_lib/meiyou_extensions_lib.dart';

class LinkAndSource extends LinkAndSourceEntity {
  LinkAndSource({required super.link, required super.source});

  static List<LinkAndSource> fromExtractedVideoData(
      ExtractedMedia extractedVideoData) {
    return (extractedVideoData.media as Video).videoSources.mapAsList(
        (source) =>
            LinkAndSource(link: extractedVideoData.link, source: source));
  }

  factory LinkAndSource.fromEntity(LinkAndSourceEntity entity) {
    return createFromEntity<LinkAndSourceEntity, LinkAndSource>(
        entity, LinkAndSource(link: entity.link, source: entity.source));
  }

  @override
  String toString() {
    final String text;
    if (source.quality == VideoQuality.hlsMaster) {
      text = '${link.name} - Multi';
    } else if (source.quality != VideoQuality.unknown &&
        source.quality != null) {
      text = '${link.name} - ${source.quality!.height}p';
    } else {
      text = link.name;
    }

    return source.isBackup ? '$text (Backup)' : text;
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is LinkAndSourceEntity || other is LinkAndSource) &&
          link == (other as LinkAndSourceEntity).link &&
          source == other.source;

  @override
  int get hashCode => link.hashCode ^ source.hashCode;
}
