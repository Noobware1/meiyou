import 'package:meiyou/shared/domain/models/extension_category.dart';
import 'package:meiyou/shared/domain/models/media_content.dart';
import 'package:meiyou_extensions_lib/models.dart';

class GetContentListByMediaIdParams {
  final int mediaId;
  final ExtensionCategory category;

  GetContentListByMediaIdParams(
      {required this.mediaId, required this.category});
}

class GetContentListByMediaIdAsStreamParams {
  final int mediaId;
  final ExtensionCategory category;

  GetContentListByMediaIdAsStreamParams(
      {required this.mediaId, required this.category});
}

class GetContentByIdParams {
  final int id;
  final ExtensionCategory category;

  GetContentByIdParams({required this.id, required this.category});
}

class InsertContentParams {
  final MediaContent content;

  InsertContentParams({required this.content});
}

class UpdateContentParams {
  final MediaContent content;

  UpdateContentParams({required this.content});
}

class MapContentListParams {
  final List<IMediaContent> contentList;
  final ExtensionCategory category;
  final int mediaId;

  MapContentListParams({
    required this.contentList,
    required this.category,
    required this.mediaId,
  });
}

class InsertAllContentParams {
  final List<MediaContent> content;

  InsertAllContentParams({required this.content});
}
