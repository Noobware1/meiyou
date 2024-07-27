import 'package:meiyou/shared/domain/models/extension_category.dart';
import 'package:meiyou/shared/domain/models/media.dart';

class NetworkMediaToLocalParams {
  final Media media;

  NetworkMediaToLocalParams({
    required this.media,
  });
}

class GetMediaByIdParams {
  final ExtensionCategory category;
  final int id;

  GetMediaByIdParams({
    required this.category,
    required this.id,
  });
}

class GetMediaByIdAsStreamParams {
  final ExtensionCategory category;
  final int id;

  GetMediaByIdAsStreamParams({
    required this.category,
    required this.id,
  });
}

class GetMediaByUrlAndSourceIdParams {
  final ExtensionCategory category;
  final int sourceId;
  final String url;

  GetMediaByUrlAndSourceIdParams({
    required this.category,
    required this.sourceId,
    required this.url,
  });
}

class InsertMediaParams {
  final Media media;

  InsertMediaParams({
    required this.media,
  });
}

class UpdateMediaParams {
  final Media media;

  UpdateMediaParams({
    required this.media,
  });
}
