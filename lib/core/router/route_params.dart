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
