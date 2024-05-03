// ignore_for_file: invalid_use_of_protected_member, invalid_use_of_visible_for_testing_member

import 'dart:async';
import 'dart:typed_data';

import 'package:meiyou/core/utils/extensions/iterable.dart';

import 'package:meiyou/core/utils/resources/logger.dart';
import 'package:meiyou/core/utils/resources/flow.dart';
import 'package:meiyou/extension/models/entension_type.dart';
import 'package:meiyou/extension/api/extension_api.dart';
import 'package:meiyou/extension/utils/extension_folder_provider.dart';
import 'package:meiyou/extension/installer/extension_installer.dart';
import 'package:meiyou/extension/utils/extension_loader.dart'
    as extension_loader;
import 'package:meiyou/extension/models/install_step.dart';
import 'package:meiyou_extensions_lib/models.dart';
import 'package:nice_dart/nice_dart.dart';

class ExtensionManager {
  final _api = ExtensionApi();
  final _extensionLoader = extension_loader.ExtensionLoader();
  final _folderProvider = ExtensionsFolderProvider();
  late final _extensionInstaller = ExtensionInstaller(_Listener(this));

  bool isInitialized = false;

  ExtensionManager() {
    init();
  }

  getExtensions() {}

  ExtensionsFlow<AvailableExtension> getAvailableExtensionsFlow(
      ExtensionType type) {
    switch (type) {
      case ExtensionType.Video:
        return _availableVideoExtFlow;
      case ExtensionType.Manga:
        return _availableMangaExtFlow;
      case ExtensionType.Novel:
        return _availableNovelExtFlow;
      default:
        throw type.invailedTypeError();
    }
  }

  ExtensionsFlow<InstalledExtension> getInstalledExtensionsFlow(
      ExtensionType type) {
    switch (type) {
      case ExtensionType.Video:
        return _installedVideoExtFlow;
      case ExtensionType.Manga:
        return _installedMangaExtFlow;
      case ExtensionType.Novel:
        return _installedNovelExtFlow;
      default:
        throw type.invailedTypeError();
    }
  }

  Uint8List? getIconForSource(int id, ExtensionType type) {
    final extension = getInstalledExtensionsFlow(type)
        .state
        .find((ext) => ext.sources.any((it) => it.id == id));

    return extension?.icon;
  }

  AvailableExtension getAvailableExtensionForSource(
      int id, ExtensionType type) {
    return getAvailableExtensionsFlow(type).state.firstWhere(
        (ext) => ext.sources.any((it) => it.id == id),
        orElse: () => throw 'Extension not found');
  }

  Future<void> init() async {
    try {
      _installedVideoExtFlow
          .addAll(_extensionLoader.loadExtensions(_folderProvider.video()));
      _installedMangaExtFlow
          .addAll(_extensionLoader.loadExtensions(_folderProvider.manga()));
      _installedNovelExtFlow
          .addAll(_extensionLoader.loadExtensions(_folderProvider.novel()));
      if (!isInitialized) {
        await _findAllAvailableExtensions();
      }
      isInitialized = true;
    } catch (_, s) {
      print(_);
      print(s);
      isInitialized = false;
      logRat.log(LogPriority.error, 'Failed to initialize extension manager');
    }
  }

  Future<void> _findAllAvailableExtensions() async {
    try {
      await Future.wait([
        findAvailableExtensions(ExtensionType.Video),
        findAvailableExtensions(ExtensionType.Manga),
        findAvailableExtensions(ExtensionType.Novel),
      ]);
    } catch (_) {
      logRat.log(LogPriority.error, 'Failed to get extensions list');
    }
  }

  Future<void> findAvailableExtensions(ExtensionType extensionType) async {
    final extensions = await _api.findExtensions(extensionType);
    getAvailableExtensionsFlow(extensionType).addAll(extensions);
  }

  Stream<InstallStep> installExtension(
      ExtensionType type, AvailableExtension extension) {
    return _extensionInstaller.downloadAndinstall(
        type, _api.getPluginUrl(extension));
  }

  bool uninstallExtension(ExtensionType type, InstalledExtension extension) {
    return _extensionInstaller.uninstallExtension(type, extension);
  }

  void _registerExtension(ExtensionType type, InstalledExtension extension) {
    getInstalledExtensionsFlow(type).addExtension(extension);
  }

  void _unregisterExtension(ExtensionType type, String pkgName) {
    final extensionListNotifier = getInstalledExtensionsFlow(type);

    final extensionList = extensionListNotifier.state;

    runCatching(() => extensionList.firstWhere((e) => e.pkgName == pkgName))
        .getOrNull()
        ?.let(extensionListNotifier.removeExtension);
  }

  late final _installedVideoExtFlow = ExtensionsFlow<InstalledExtension>();

  late final _installedMangaExtFlow = ExtensionsFlow<InstalledExtension>();

  late final _installedNovelExtFlow = ExtensionsFlow<InstalledExtension>();

  late final _availableVideoExtFlow = ExtensionsFlow<AvailableExtension>();

  late final _availableMangaExtFlow = ExtensionsFlow<AvailableExtension>();

  late final _availableNovelExtFlow = ExtensionsFlow<AvailableExtension>();
}

class _Listener implements ExtensionInstallerListener {
  final ExtensionManager manager;

  _Listener(this.manager);

  @override
  void onExtensionInstalled(ExtensionType type, InstalledExtension extension) {
    return manager._registerExtension(type, extension);
  }

  @override
  void onExtensionUninstalled(ExtensionType type, String pkgName) {
    manager._unregisterExtension(type, pkgName);
  }

  @override
  void onExtensionUpdated(ExtensionType type, InstalledExtension extension) {}
}

class ExtensionsFlow<T extends Extension> extends StateFlow<List<T>> {
  ExtensionsFlow() : super([]);

  void addAll(Iterable<T> extensions) {
    return update(state..addAll(extensions));
  }

  void addExtension(T extension) {
    update(state..add(extension));
  }

  void removeExtension(T extension) {
    update(state..remove(extension));
  }
}

extension ForceEmit on ExtensionsFlow<AvailableExtension> {
  void reload() {
    return update(state);
  }
}

extension UpdateExtensions on ExtensionsFlow<InstalledExtension> {
  void updateExtension(InstalledExtension extension) {
    final index = state.indexWhere((e) => e.pkgName == extension.pkgName);
    state[index] = extension;
    update(state);
  }
}
