import 'dart:io';
import 'dart:typed_data';

import 'package:meiyou/extension/models/entension_type.dart';
import 'package:meiyou/extension/utils/extension_folder_provider.dart';
import 'package:meiyou_extensions_lib/extensions_lib.dart' as extlib;
import 'package:meiyou_extensions_lib/models.dart';
import 'package:nice_dart/nice_dart.dart';

class ExtensionLoader {
  Result<InstalledExtension> loadFromPkgName(
      ExtensionType type, String pkgName) {
    final folder = ExtensionsFolderProvider().getFolderFromType(type);
    final dir = Directory(folder.path + Platform.pathSeparator + pkgName);
    return loadExtension(dir);
  }

  List<InstalledExtension> loadExtensions(Directory dir) {
    return runCatching(() {
      final List<InstalledExtension> extensions = [];
      for (final entry in dir.listSync()) {
        if (entry is Directory) {
          final ext = loadExtension(entry);
          if (ext.isSuccess) {
            extensions.add(ext.getOrThrow());
          }
        }
      }
      return extensions;
    }).getOrDefault([]);
  }

  Result<InstalledExtension> loadExtension(Directory dir) {
    return runCatching(() {
      final dirPath = dir.path;
      final iconPath = File(dirPath + Platform.pathSeparator + "icon.png");
      final metadataPath =
          File(dirPath + Platform.pathSeparator + "metadata.json");
      final codePath = File(dirPath + Platform.pathSeparator + "code.evc");

      assert(metadataPath.existsSync() && codePath.existsSync());

      final metadata = PluginMetaData.decode(metadataPath.readAsStringSync());
      final code = codePath.readAsBytesSync();
      final sources = _loadSources(metadata.pkgName, code);

      final Uint8List? icon;
      if (iconPath.existsSync()) {
        icon = iconPath.readAsBytesSync();
      } else {
        icon = null;
      }

      return InstalledExtension(
        name: metadata.name,
        pkgName: metadata.pkgName,
        versionName: metadata.versionName,
        sources: sources,
        isOnline: metadata.isOnline,
        icon: icon,
        isNsfw: metadata.isNsfw,
        lang: metadata.lang,
      );
    });
  }

  List<Source> _loadSources(String pkgName, Uint8List code) {
    final $instance =
        extlib.ExtensionLoader(code.buffer.asByteData()).getSource(pkgName);

    if ($instance is SourceFactory) {
      return $instance.getSources();
    } else if ($instance is Source) {
      return [$instance];
    } else {
      throw Exception("Corrupted Source File");
    }
  }
}
