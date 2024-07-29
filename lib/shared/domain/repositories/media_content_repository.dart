import 'package:meiyou/shared/domain/models/media_content.dart';
import 'package:meiyou/shared/domain/models/repositories_params/media_content_repository_params.dart';

abstract class MediaContentRepository {
  List<MediaContent> mapContentList(MapContentListParams params);

  List<MediaContent> getContentListByMediaId(
      GetContentListByMediaIdParams params);

  Stream<List<MediaContent>> getContentListByMediaIdAsStream(
      GetContentListByMediaIdAsStreamParams params);

  MediaContent? getContentById(GetContentByIdParams params);

  Future<int> insertContent(InsertContentParams params);

  Future<int> updateContent(UpdateContentParams params);

  Future<List<MediaContent>> insertAllContent(InsertAllContentParams params);
}
