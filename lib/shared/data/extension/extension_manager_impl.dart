// ignore_for_file: invalid_use_of_protected_member, invalid_use_of_visible_for_testing_member

import 'dart:async';
import 'dart:io';
import 'dart:math';
import 'package:async/async.dart' hide Result;
import 'package:collection/collection.dart';
import 'package:meiyou/core/utils/extensions/result.dart';
import 'package:meiyou/core/utils/log/logger.dart';
import 'package:meiyou/shared/data/data_sources/folder_providers/extensions_folder_provider.dart';
import 'package:meiyou/shared/data/data_sources/folder_providers/storage_folder_provider.dart';
import 'package:meiyou/shared/data/data_sources/preferences/source_preferences.dart';
import 'package:meiyou/shared/data/extension/api/extension_api.dart';
import 'package:meiyou/shared/data/extension/installer/extension_installer.dart';
import 'package:meiyou/shared/data/extension/utils/extension_loader.dart';
import 'package:meiyou/shared/domain/models/extension_category.dart';
import 'package:meiyou/shared/domain/models/extension_list.dart';
import 'package:meiyou/shared/domain/models/install_step.dart';
import 'package:meiyou/shared/domain/extension_manager/extension_manger.dart';
import 'package:meiyou/core/utils/comparator/case_insensitive_comparator.dart';
import 'package:meiyou/core/utils/stream_utils/comnine_stream.dart';
import 'package:meiyou/core/utils/stream_utils/state_stream.dart';
import 'package:meiyou_extensions_lib/models.dart';
import 'package:meiyou_extensions_lib/network.dart';
import 'package:nice_dart/nice_dart.dart';

class ExtensionManagerImpl implements ExtensionManager {
  final SourcePreferences _sourcePreferences;
  final NetworkHelper _network;

  ExtensionManagerImpl(
      {required SourcePreferences sourcePreferences,
      required NetworkHelper network})
      : _sourcePreferences = sourcePreferences,
        _network = network;
  @override
  StateStream<ExtensionList> getExtensionList(ExtensionCategory category) {
    final enabledLanguages = _sourcePreferences.enabledLanguages();
    final installedExtensions = getInstalledExtensionsStream(category);
    final availableExtensions = getAvailableExtensionsStream(category);

    ExtensionList mapper(
      List<String> enabledLanguages,
      List<InstalledExtension> installedExts,
      List<AvailableExtension> availableExts,
      bool isInitialized,
    ) {
      final (updates, installed) = (installedExts
            ..sort((a, b) => CaseInsensitiveComparator.compare(a.name, b.name)))
          .parition((e) => e.hasUpdate);

      final available = availableExts
          .where((ext) => !installedExts.any((it) => it.pkgName == ext.pkgName))
          .map((ext) {
            if (ext.sources.isEmpty && !enabledLanguages.contains(ext.lang)) {
              return null;
            }

            final sources = ext.sources
                .where((source) => enabledLanguages.contains(source.lang))
                .toList();

            return ext.copyWith(sources: sources);
          })
          .nonNulls
          .sorted((a, b) => CaseInsensitiveComparator.compare(a.name, b.name));

      return ExtensionList(
        installed: installed,
        available: available,
        updates: updates,
        isInitialized: isInitialized,
      );
    }

    final stream = CombineStream.combine3(
      enabledLanguages.changes(),
      installedExtensions,
      availableExtensions,
      (enabledLanguages, installedExts, availableExts) => mapper(
        enabledLanguages,
        installedExts,
        availableExts,
        installedExtensions.isInitialized || availableExtensions.isInitialized,
      ),
      initalDataA: enabledLanguages.get(),
      initalDataB: installedExtensions.state,
      initalDataC: availableExtensions.state,
    );

    return StateStream.fromStream(stream,
        initialData: mapper(
          enabledLanguages.get(),
          installedExtensions.state,
          availableExtensions.state,
          installedExtensions.isInitialized ||
              availableExtensions.isInitialized,
        ));
  }

  @override
  ExtensionStream<AvailableExtension> getAvailableExtensionsStream(
          ExtensionCategory category) =>
      _getAvailableExtensionsStream(category);

  @override
  ExtensionStream<InstalledExtension> getInstalledExtensionsStream(
          ExtensionCategory category) =>
      _getInstalledExtensionsStream(category);

  @override
  Stream<InstallStep> installExtension(
      ExtensionCategory category, AvailableExtension extension) {
    return _extensionInstaller.installExtension(category, extension.pluginUrl);
  }

  @override
  void cancelDownload(ExtensionCategory category, Extension extension) {
    final availableExtension = extension is AvailableExtension
        ? extension
        : getAvailableExtensionsStream(category)
            .state
            .firstWhere((ext) => ext.pkgName == extension.pkgName);

    return _extensionInstaller.cancelDownload(availableExtension);
  }

  @override
  Stream<InstallStep> updateExtension(
      ExtensionCategory category, InstalledExtension extension) {
    final availableExtension = getAvailableExtensionsStream(category)
        .state
        .firstWhere((ext) => ext.pkgName == extension.pkgName);

    return _extensionInstaller.updateExtension(
        category, _api.getPluginUrl(availableExtension));
  }

  @override
  Future<bool> uninstallExtension(
      ExtensionCategory category, InstalledExtension extension) {
    return _extensionInstaller.uninstallExtension(category, extension);
  }

  @override
  InstalledExtension? getInstalledExtension(
      int id, ExtensionCategory category) {
    final extension = getInstalledExtensionsStream(category)
        .state
        .firstWhere((ext) => ext.sources.any((it) => it.id == id));

    return extension;
  }

  @override
  AvailableExtension? getAvailableExtensionForSource(
      int id, ExtensionCategory category) {
    try {
      return getAvailableExtensionsStream(category).state.firstWhere(
          (ext) => ext.sources.any((it) => it.id == id),
          orElse: () => throw 'Extension not found');
    } catch (_) {
      logger.warning('Extension not found', _);
      return null;
    }
  }

  @override
  Future<void> findAvailableExtensions(ExtensionCategory extensionCategory) =>
      _findExtensions(_getAvailableExtensionsStream(extensionCategory),
          () async {
        final result = await _api.findExtensions(extensionCategory);
        if (result.isSuccess) {
          _updatedInstalledExtensionsStatuses(
              extensionCategory, result.getOrThrow());
        }
        return result;
      });

  late final ExtensionApi _api = ExtensionApi(
    logger: logger,
    sourcePreferences: _sourcePreferences,
    network: _network,
  );
  final ExtensionsFolderProvider _folderProvider =
      ExtensionsFolderProvider(StorageFolderProvider());

  late final ExtensionLoader _extensionLoader =
      ExtensionLoader(folderProvider: _folderProvider);

  late final _extensionInstaller = ExtensionInstaller(
      listener: _Listener(this),
      networkService: _network,
      folderProvider: _folderProvider,
      extensionLoader: _extensionLoader,
      logger: logger);

  bool _isInitialized = false;

  @override
  bool get isInitialized => _isInitialized;

  final _installedVideoExtStream = _ExtensionsStream<InstalledExtension>();

  final _installedMangaExtStream = _ExtensionsStream<InstalledExtension>();

  final _installedNovelExtStream = _ExtensionsStream<InstalledExtension>();

  final _availableVideoExtStream = _ExtensionsStream<AvailableExtension>();

  final _availableMangaExtStream = _ExtensionsStream<AvailableExtension>();

  final _availableNovelExtStream = _ExtensionsStream<AvailableExtension>();

  _ExtensionsStream<AvailableExtension> _getAvailableExtensionsStream(
          ExtensionCategory category) =>
      category.when(
        video: () => _availableVideoExtStream,
        manga: () => _availableMangaExtStream,
        novel: () => _availableNovelExtStream,
      );

  _ExtensionsStream<InstalledExtension> _getInstalledExtensionsStream(
          ExtensionCategory category) =>
      category.when(
        video: () => _installedVideoExtStream,
        manga: () => _installedMangaExtStream,
        novel: () => _installedNovelExtStream,
      );

  Future<void> init() async {
    try {
      await _findAllInstalledExtensions();
      _findAllAvailableExtensions();
      _isInitialized = true;
    } catch (_, s) {
      _isInitialized = false;
      logger.severe('Failed to initialize extension manager', _, s);
    }
  }

  Future<void> _findAllInstalledExtensions() async {
    try {
      await Future.wait([
        _findInstalledExtensions(ExtensionCategory.video),
        _findInstalledExtensions(ExtensionCategory.manga),
        _findInstalledExtensions(ExtensionCategory.novel),
      ]);
    } catch (e, s) {
      logger.severe('Failed to load installed extension list', e, s);
    }
  }

  Future<void> _findAllAvailableExtensions() async {
    try {
      await Future.wait([
        findAvailableExtensions(ExtensionCategory.video),
        findAvailableExtensions(ExtensionCategory.manga),
        findAvailableExtensions(ExtensionCategory.novel),
      ]);
    } catch (e) {
      logger.severe('Failed to load installed extension list', e);
    }
  }

  Future<void> _findInstalledExtensions(ExtensionCategory extensionCategory) =>
      _findExtensions(
          _getInstalledExtensionsStream(extensionCategory),
          () async => await _extensionLoader.loadExtensions(
              await _folderProvider.categoryDirectory(extensionCategory)));

  Future<void> _findExtensions<T extends Extension>(_ExtensionsStream<T> stream,
      Future<Result<List<T>>> Function() load) async {
    final result = await load();
    result.when(
      success: (exts) => stream.addAll(exts),
      failure: (e) => logger.severe(e),
    );
    stream.isInitialized = true;
  }

  void _updatedInstalledExtensionsStatuses(
    ExtensionCategory category,
    List<AvailableExtension> availableExtensions,
  ) {
    if (availableExtensions.isEmpty) {
      _sourcePreferences.extensionUpdatesCountByCategory(category).set(0);
      return;
    }

    final stateStream = getInstalledExtensionsStream(category);
    final installedExtensions = stateStream.state;

    var changed = false;
    for (var i = 0; i < installedExtensions.length; i++) {
      final installedExt = installedExtensions[i];
      final availableExt = availableExtensions.firstWhereOrNull(
        (it) => it.pkgName == installedExt.pkgName,
      );

      if (availableExt == null && !installedExt.isObsolote) {
        installedExt.changeIsObselote(true);
        changed = true;
      } else if (availableExt != null) {
        final hasUpdate = installedExt.updateExists(availableExt);

        if (installedExt.hasUpdate != hasUpdate) {
          installedExt.copyWith(
            hasUpdate: hasUpdate,
            repoUrl: availableExt.repoUrl,
          );
          changed = true;
        } else {
          installedExtensions[i] = installedExt.copyWith(
            repoUrl: availableExt.repoUrl,
          );
          changed = true;
        }
      }
    }

    if (changed) {
      stateStream.update(installedExtensions);
    }

    _updatePendingUpdatesCount(category);
  }

  void _registerExtension(
      ExtensionCategory category, InstalledExtension extension) {
    _getInstalledExtensionsStream(category).addExtension(extension);
  }

  void _unregisterExtension(ExtensionCategory category, String pkgName) {
    final extensionListNotifier = _getInstalledExtensionsStream(category);

    final extensionList = extensionListNotifier.state;

    runCatching(() => extensionList.firstWhere((e) => e.pkgName == pkgName))
        .getOrNull()
        ?.let((it) {
      extensionListNotifier.removeExtension(it);
    });
  }

  void _registerUpdatedExtension(
      ExtensionCategory category, InstalledExtension extension) {
    _getInstalledExtensionsStream(category).updateExtension(extension);
  }

  void _updatePendingUpdatesCount(ExtensionCategory category) {
    final pendingUpdateCount = getInstalledExtensionsStream(category)
        .state
        .fold(0, (count, ext) => ext.hasUpdate ? count + 1 : count);
    _sourcePreferences
        .extensionUpdatesCountByCategory(category)
        .set(pendingUpdateCount);
  }
}

extension<E> on List<E> {
  (List<E>, List<E>) parition(bool Function(E) test) {
    final a = <E>[];
    final b = <E>[];

    for (final e in this) {
      if (test(e)) {
        a.add(e);
      } else {
        b.add(e);
      }
    }

    return (a, b);
  }
}

class Version {
  final int major;
  final int minor;
  final int patch;

  Version({required this.major, required this.minor, required this.patch});

  factory Version.parse(String version) {
    final parts =
        version.split('.').map((e) => int.parse(e.substring(0, 1))).toList();

    return Version(major: parts[0], minor: parts[1], patch: parts[2]);
  }

  @override
  String toString() => '$major.$minor.$patch';

  bool operator >(Version other) {
    if (major > other.major) return true;
    if (major < other.major) return false;

    if (minor > other.minor) return true;
    if (minor < other.minor) return false;

    return patch > other.patch;
  }

  bool operator <(Version other) {
    if (major < other.major) return true;
    if (major > other.major) return false;

    if (minor < other.minor) return true;
    if (minor > other.minor) return false;

    return patch < other.patch;
  }
}

extension on Extension {
  Version get version => Version.parse(versionName);
}

extension on InstalledExtension {
  InstalledExtension changeIsObselote(bool isObsolote) {
    return InstalledExtension(
      name: name,
      pkgName: pkgName,
      versionName: versionName,
      sources: sources,
      isOnline: isOnline,
      repoUrl: repoUrl,
      hasUpdate: hasUpdate,
      icon: icon,
      isNsfw: isNsfw,
      isObsolote: isObsolote,
      lang: lang,
    );
  }

  InstalledExtension withUpdateCheck(AvailableExtension extension) {
    return updateExists(extension) ? copyWith(hasUpdate: true) : this;
  }

  bool updateExists(AvailableExtension extension) {
    return extension.version > version;
  }
}

class _Listener implements ExtensionInstallerListener {
  final ExtensionManagerImpl manager;

  _Listener(this.manager);

  @override
  void onExtensionInstalled(
      ExtensionCategory category, InstalledExtension extension) {
    manager._registerExtension(category, extension);
    manager._updatePendingUpdatesCount(category);
  }

  @override
  void onExtensionUninstalled(ExtensionCategory category, String pkgName) {
    manager._unregisterExtension(category, pkgName);
    manager._updatePendingUpdatesCount(category);
  }

  @override
  void onExtensionUpdated(
      ExtensionCategory category, InstalledExtension extension) {
    manager._registerUpdatedExtension(category, extension);
    manager._updatePendingUpdatesCount(category);
  }
}

class _ExtensionsStream<T extends Extension> extends ExtensionStream<T> {
  _ExtensionsStream() : super(initialData: []);

  bool _isInitialized = false;

  @override
  bool get isInitialized => _isInitialized;

  @override
  set isInitialized(bool isInitialized) {
    _isInitialized = isInitialized;
  }

  void addAll(Iterable<T> extensions) {
    update(state..addAll(extensions));
  }

  void addExtension(T extension) {
    update(state..add(extension));
  }

  void removeExtension(T extension) {
    update(state..remove(extension));
  }

  void reload() {
    update(state);
  }
}

extension on _ExtensionsStream<InstalledExtension> {
  void updateExtension(InstalledExtension extension) {
    final index = state.indexWhere((e) => e.pkgName == extension.pkgName);
    state[index] = extension;
    update(state);
  }
}

extension on AvailableExtension {
  AvailableExtension copyWith({List<AvailableSource>? sources}) {
    return AvailableExtension(
      isNsfw: isNsfw,
      lang: lang,
      pluginName: pluginName,
      repoUrl: repoUrl,
      versionName: versionName,
      name: name,
      pkgName: pkgName,
      sources: sources ?? this.sources,
    );
  }
}
