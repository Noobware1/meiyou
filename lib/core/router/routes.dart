import 'package:flutter/material.dart';
import 'package:meiyou/core/router/route_params.dart';
import 'package:meiyou/core/utils/extensions/context.dart';
import 'package:meiyou/shared/domain/models/extension_category.dart';
import 'package:meiyou/shared/domain/models/media.dart';
import 'package:meiyou/shared/domain/models/media_content.dart';
import 'package:meiyou/shared/domain/models/source.dart';
import 'package:meiyou_extensions_lib/models.dart';

class Route {
  static const home = Route._('home', '/home');
  static const libary = Route._('libary', '/libary');
  static const history = Route._('history', '/history');
  static const search = Route._('search', '/search');
  static const extensions = Route._('extensions', '/extensions');
  static const media = Route._('media', '/media');
  static const player = Route._('player', '/player');
  static const onboarding = Route._('onboarding', '/onboarding');
  static const more = Route._('more', '/more');
  static const extensionInfo = Route._('extensionInfo', '/extension_info');

  /// settings
  static const settings = Route._('settings', '/settings');
  static const storage = Route._('storage', '/storage');
  static const apperance_settings =
      Route._('apperance_settings', '/apperance_settings');
  static const librarySettings =
      Route._('library_settings', '/library_settings');
  static const editCategories = Route._('edit_categories', '/edit_categories');

  final String name;
  final String path;

  const Route._(this.name, this.path);

  void _go(BuildContext context, {RouteParams? params}) {
    context.router.go(path, extra: params);
  }

  void _push(BuildContext context, {RouteParams? params}) {
    context.router.push(path, extra: params);
  }
}

extension RoutesExtensions on BuildContext {
  void pushToSearchScreen(InstalledSource source) {
    Route.search._push(
      this,
      params: SearchScreenRouteParams(
        sourceId: source.id,
        category: source.category,
      ),
    );
  }

  void pushToMediaScreen(Media media) {
    Route.media._push(
      this,
      params: MediaScreenRouteParams(
        mediaId: media.id,
        category: media.category,
      ),
    );
  }

  void pushToPlayerScreen(Media media, MediaContent content) {
    Route.player._push(
      this,
      params: PlayerScreenRouteParams(
        mediaId: media.id,
        category: media.category,
        contentId: content.id,
      ),
    );
  }

  void goToHomeScreen() {
    Route.home._go(this);
  }
}
