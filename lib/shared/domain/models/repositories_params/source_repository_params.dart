import 'package:meiyou/shared/domain/models/extension_category.dart';
import 'package:meiyou/shared/domain/models/media_content.dart';
import 'package:meiyou_extensions_lib/models.dart';

class GetEnabledSourcesUseCaseParams {
  final ExtensionCategory category;

  GetEnabledSourcesUseCaseParams({
    required this.category,
  });
}

class _SourceIdAndCategory {
  final int sourceId;
  final ExtensionCategory category;

  _SourceIdAndCategory({
    required this.sourceId,
    required this.category,
  });
}

class GetFullHomePageParams extends _SourceIdAndCategory {
  GetFullHomePageParams({
    required super.sourceId,
    required super.category,
  });
}

class GetHomePageParams extends _SourceIdAndCategory {
  final int page;
  final HomePageRequest request;

  GetHomePageParams({
    required super.sourceId,
    required super.category,
    required this.page,
    required this.request,
  });
}

class GetSearchPageParams extends _SourceIdAndCategory {
  final int page;
  final String query;
  final FilterList filters;

  GetSearchPageParams({
    required super.sourceId,
    required super.category,
    required this.page,
    required this.query,
    required this.filters,
  });
}

class GetMediaDetailsParams extends _SourceIdAndCategory {
  final IMedia media;

  GetMediaDetailsParams({
    required super.sourceId,
    required super.category,
    required this.media,
  });
}

class GetMediaContentListParams extends _SourceIdAndCategory {
  final IMedia media;

  GetMediaContentListParams({
    required super.sourceId,
    required super.category,
    required this.media,
  });
}

class GetMediaLinkListParams extends _SourceIdAndCategory {
  final IMediaContent content;

  GetMediaLinkListParams({
    required super.sourceId,
    required super.category,
    required this.content,
  });
}

class GetMediaAssetsParams extends _SourceIdAndCategory {
  final MediaLink link;

  GetMediaAssetsParams({
    required super.sourceId,
    required super.category,
    required this.link,
  });
}
