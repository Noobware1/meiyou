import 'package:meiyou/core/utils/from_entity.dart';
import 'package:meiyou/domain/entities/extracted_media.dart';

class ExtractedMedia extends ExtractedMediaEntity {
  ExtractedMedia({
    required super.link,
    required super.media,
  });


  factory ExtractedMedia.fromEntity(ExtractedMediaEntity entity) {
    return createFromEntity<ExtractedMediaEntity, ExtractedMedia>(entity, ExtractedMedia(link: entity.link, media: entity.media));
  }
}
