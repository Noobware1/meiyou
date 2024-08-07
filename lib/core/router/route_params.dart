import 'package:meiyou/shared/domain/models/extension_category.dart';

abstract class RouteParams {
  const RouteParams();
}

class MediaScreenRouteParams implements RouteParams {
  final int mediaId;
  final ExtensionCategory category;

  MediaScreenRouteParams({required this.mediaId, required this.category});

  static MediaScreenRouteParams fromExtra(Object? extra) {
    return extra as MediaScreenRouteParams;
  }
}

class SearchScreenRouteParams implements RouteParams {
  final int sourceId;
  final ExtensionCategory category;

  SearchScreenRouteParams({required this.sourceId, required this.category});

  static SearchScreenRouteParams fromExtra(Object? extra) {
    return extra as SearchScreenRouteParams;
  }
}

class PlayerScreenRouteParams implements RouteParams {
  final int mediaId;
  final ExtensionCategory category;
  final int contentId;

  PlayerScreenRouteParams(
      {required this.mediaId, required this.category, required this.contentId});

  static PlayerScreenRouteParams fromExtra(Object? extra) {
    return extra as PlayerScreenRouteParams;
  }
}
