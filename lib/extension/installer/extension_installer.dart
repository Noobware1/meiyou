import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:meiyou/core/utils/extensions/io.dart';
import 'package:meiyou/core/utils/resources/get_it/get_it.dart';
import 'package:meiyou/core/utils/resources/logger.dart';
import 'package:meiyou/core/utils/resources/network.dart';
import 'package:meiyou/extension/models/entension_type.dart';
import 'package:meiyou/extension/utils/extension_folder_provider.dart';
import 'package:meiyou/extension/models/install_step.dart';
import 'package:meiyou/extension/utils/extension_loader.dart' as ext_loader;
import 'package:meiyou_extensions_lib/models.dart';
import 'package:meiyou_extensions_lib/network.dart';
import 'package:nice_dart/nice_dart.dart';
import 'package:path/path.dart' as path;

abstract class ExtensionInstallerListener {
  void onExtensionInstalled(ExtensionType type, InstalledExtension extension);

  void onExtensionUpdated(ExtensionType type, InstalledExtension extension);

  void onExtensionUninstalled(ExtensionType type, String pkgName);
}

class ExtensionInstaller {
  ExtensionInstaller(this._listener);
  final ExtensionInstallerListener _listener;
  final NetworkHelper _networkService = getIt.get();
  final ExtensionsFolderProvider _folderProvider = ExtensionsFolderProvider();

  Stream<InstallStep> downloadAndinstall(
    ExtensionType type,
    String pluginUrl,
  ) async* {
    try {
      yield InstallStep.Downloading;

      final response =
          await _networkService.client.newCall(GET(pluginUrl)).execute();

      final plugin = Plugin.decode(Uint8List.fromList(response.body.bytes));

      yield InstallStep.Installing;

      final dir = _folderProvider.getFolderFromType(type);
      print(dir.path);
      final result = plugin.saveAndGet(dir.path);

      if (result.isFailure) {
        logRat.logcatch(
            LogPriority.error, result.exceptionOrNull()!, StackTrace.current);

        (dir.path + Platform.pathSeparator + plugin.metadata.pkgName)
            .toDirectory()
            .takeIf((it) => it.existsSync())
            ?.let((it) => it.deleteSync(
                  recursive: true,
                ));
      } else {
        _listener.onExtensionInstalled(type, result.getOrNull()!);

        yield InstallStep.Installed;
      }
    } catch (e, s) {
      print(e);
      print(s);
      logRat.logcatch(LogPriority.error, e, StackTrace.current);
      yield InstallStep.Error;
    } finally {
      yield InstallStep.Idle;
    }
  }

  bool uninstallExtension(ExtensionType type, InstalledExtension extension) {
    try {
      // delete the extension folder
      (_folderProvider.getFolderFromType(type).path +
              Platform.pathSeparator +
              extension.pkgName)
          .toDirectory()
          .deleteSync(recursive: true);

      // delete all preferences for all its sources
      for (var source in extension.sources) {
        try {
          // ignore: invalid_use_of_protected_member
          source.preferences.delete();
        } catch (_) {}
      }

      _listener.onExtensionUninstalled(type, extension.pkgName);

      return true;
    } catch (_) {
      return false;
    }
  }
}

extension on Plugin {
  Result<InstalledExtension> saveAndGet(String dirPath) {
    dirPath = path.join(dirPath, metadata.pkgName);
    //create Directory
    final dir = dirPath.toDirectory()..createSync();
    // create code.evc
    (dirPath + Platform.pathSeparator + "code.evc")
        .toFile()
        .writeAsBytesSync(code);

    // create icon.png
    if (icon != null) {
      path.join(dirPath, "icon.png").toFile().writeAsBytesSync(icon!);
    }

    // create metadata.json
    path
        .join(dirPath, "metadata.json")
        .toFile()
        .writeAsStringSync(metadata.encode());

    return ext_loader.ExtensionLoader().loadExtension(dir);
  }
}
