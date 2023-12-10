import 'package:meiyou/core/utils/from_entity.dart';
import 'package:meiyou/domain/entities/extracted_video_data.dart';

class ExtractedVideoData extends ExtractedVideoDataEntity {
  ExtractedVideoData({required super.link, required super.video});

  factory ExtractedVideoData.fromEntity(ExtractedVideoDataEntity entity) {
    return createFromEntity(
        entity, ExtractedVideoData(link: entity.link, video: entity.video));
  }

  @override
  String toString() {
    return 'ExtractedVideoData(link: $link, video: $video)';
  }
}
