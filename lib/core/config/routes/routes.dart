import 'package:flutter/material.dart';
import 'package:meiyou/core/utils/extensions/context.dart';
import 'package:meiyou/extension/models/entension_type.dart';
import 'package:meiyou_extensions_lib/models.dart';

class Route {
  static const home = Route._('home', '/home');
  static const libary = Route._('libary', '/libary');
  static const history = Route._('history', '/history');
  static const search = Route._('search', '/search');
  static const extensions = Route._('extensions', '/extensions');
  static const info = Route._('info', '/info');
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

  void _go(BuildContext context, {Object? extra}) {
    context.router.go(path, extra: extra);
  }

  void _push(BuildContext context, {Object? extra}) {
    context.router.push(path, extra: extra);
  }
}

extension RoutesExtensions on BuildContext {
  void goToInfoScreen(ContentItem item) {
    Route.info._push(this, extra: item);
  }

  void goToSearchScreen() {
    Route.search._push(this);
  }

  void goToPlayerScreen() {
    Route.player._push(this);
  }

  void goToHomeScreen() {
    Route.home._go(this);
  }

  void goOnBoardingScreen() {
    Route.onboarding._push(this);
  }

  void goToSettingsScreen() {
    Route.settings._push(this);
  }

  void goToApperanceSettings() {
    Route.apperance_settings._push(this);
  }

  void goToStorageScreen() {
    Route.storage._push(this);
  }

  void goToExtensionsScreen() {
    Route.extensions._push(this);
  }

  void goToExtensionInfoScreen(
      InstalledExtension extension, ExtensionType type) {
    Route.extensionInfo._push(this, extra: (extension, type));
  }

  void goToLibrarySettings() {
    Route.librarySettings._push(this);
  }

  void goToEditCategories([int? index]) {
    Route.editCategories._push(this, extra: index ?? 0);
  }
}
