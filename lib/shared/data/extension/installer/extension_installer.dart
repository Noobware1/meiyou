import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:async/async.dart' hide Result;
import 'package:logging/logging.dart';
import 'package:meiyou/core/utils/extensions/io.dart';
import 'package:meiyou/core/utils/extensions/result.dart';
import 'package:meiyou/shared/data/data_sources/folder_providers/extensions_folder_provider.dart';
import 'package:meiyou/shared/data/extension/utils/extension_loader.dart';
import 'package:meiyou/shared/domain/models/extension_category.dart';
import 'package:meiyou/shared/domain/models/install_step.dart';
import 'package:meiyou_extensions_lib/models.dart';
import 'package:meiyou_extensions_lib/network.dart';
import 'package:nice_dart/nice_dart.dart';
import 'package:path/path.dart' as p;

abstract class ExtensionInstallerListener {
  void onExtensionInstalled(
      ExtensionCategory category, InstalledExtension extension);

  void onExtensionUpdated(
      ExtensionCategory category, InstalledExtension extension);

  void onExtensionUninstalled(ExtensionCategory category, String pkgName);
}

class CancelException implements Exception {
  CancelException();
}

class ExtensionInstaller {
  ExtensionInstaller({
    required ExtensionInstallerListener listener,
    required NetworkHelper networkService,
    required ExtensionsFolderProvider folderProvider,
    required ExtensionLoader extensionLoader,
    required Logger logger,
  })  : _listener = listener,
        _networkService = networkService,
        _folderProvider = folderProvider,
        _extensionLoader = extensionLoader,
        _logger = logger;

  final ExtensionInstallerListener _listener;
  final NetworkHelper _networkService;
  final ExtensionsFolderProvider _folderProvider;
  final ExtensionLoader _extensionLoader;
  final Logger _logger;

  Stream<InstallStep> installExtension(
    ExtensionCategory category,
    String pluginUrl,
  ) {
    return _downloadAndinstall(
      category,
      pluginUrl,
      _listener.onExtensionInstalled,
    );
  }

  Stream<InstallStep> updateExtension(
    ExtensionCategory category,
    String pluginUrl,
  ) {
    return _downloadAndinstall(
      category,
      pluginUrl,
      _listener.onExtensionUpdated,
    );
  }

  final _downloads = <int, _DownloadEntry>{};

  Stream<InstallStep> _downloadAndinstall(
    ExtensionCategory category,
    String pluginUrl,
    void Function(ExtensionCategory, InstalledExtension) onInstalled,
  ) async* {
    final entry = _DownloadEntry();
    final key = pluginUrl.hashCode;
    _downloads[key] = entry;

    try {
      yield InstallStep.downloading;

      final cancelableOperation = CancelableOperation.fromFuture(
          _networkService.client.newCall(GET(pluginUrl)).execute());

      _downloads[key] = entry
        ..onCancel = () {
          cancelableOperation.cancel();
        };

      final response = await cancelableOperation.valueOrCancellation();
      if (response == null) {
        yield InstallStep.idle;
        return;
      }

      final plugin = Plugin.decode(Uint8List.fromList(response.body.bytes));

      yield InstallStep.installing;

      final dir = await _folderProvider.categoryDirectory(category);

      String dirPath = dir.path;

      dirPath = p.join(dirPath, plugin.metadata.pkgName);
     
      //create Directory
      final extDir = dirPath.toDirectory()..createSync(recursive: true);

      Future<InstallStep> saveAndGet() async {
        // create code.evc
        p.join(dirPath, "code.evc").toFile().writeAsBytesSync(plugin.code);

        // create icon.png
        if (plugin.icon != null) {
          p.join(dirPath, "icon.png").toFile().writeAsBytesSync(plugin.icon!);
        }

        // create metadata.json
        p
            .join(dirPath, "metadata.json")
            .toFile()
            .writeAsStringSync(plugin.metadata.encode());

        final result = await _extensionLoader.loadExtension(extDir);

        if (result.isFailure) {
          _logger.severe(result.exceptionOrNull()!, StackTrace.current);

          p
              .join(dir.path, plugin.metadata.pkgName)
              .toDirectory()
              .takeIf((it) => it.existsSync())
              ?.deleteSync(recursive: true);
          return InstallStep.error;
        } else {
          onInstalled(category, result.getOrNull()!);
        }

        return InstallStep.installed;
      }

      final lastOperation = CancelableOperation.fromFuture(saveAndGet());

      _downloads[key] = entry
        ..onDone = (() => _downloads.remove(key))
        ..onCancel = () {
          extDir.deleteSync(recursive: true);
          lastOperation.cancel();
        };

      yield (await lastOperation.valueOrCancellation(InstallStep.idle))!;
    } catch (e, s) {
      _logger.severe(e, s);
      yield InstallStep.error;
    } finally {
      yield InstallStep.idle;
      entry.complete();
    }
  }

  Future<bool> uninstallExtension(
      ExtensionCategory type, InstalledExtension extension) async {
    try {
      // delete the extension folder
      final categoryDir = await _folderProvider.categoryDirectory(type);
      p
          .join(categoryDir.path, extension.pkgName)
          .toDirectory()
          .deleteSync(recursive: true);

      // delete all preferences for all its sources
      for (var source in extension.sources) {
        try {
          // ignore: invalid_use_of_protected_member
          source.preferences.delete();
        } catch (e) {
          _logger.warning(
              'Failed to delete preferences for source ${source.name}', e);
        }
      }

      _listener.onExtensionUninstalled(type, extension.pkgName);

      return true;
    } catch (e) {
      _logger.severe('Failed to uninstall extension', e);
      return false;
    }
  }

  void cancelDownload(AvailableExtension extension) {
    final key = extension.pluginUrl.hashCode;
    final download = _downloads[key];
    if (download != null) {
      download.cancel();
    }
    _downloads.remove(key);
  }
}

class _DownloadEntry {
  void Function()? onCancel;
  void Function()? onDone;

  void cancel() {
    onCancel?.call();
  }

  void complete() {
    onDone?.call();
  }
}
