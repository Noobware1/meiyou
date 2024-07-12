import 'dart:io';
import 'dart:typed_data';

import 'package:meiyou/core/utils/extensions/result.dart';
import 'package:meiyou/shared/data/data_sources/folder_providers/extensions_folder_provider.dart';
import 'package:meiyou/shared/domain/models/extension_category.dart';
import 'package:meiyou_extensions_lib/extensions_lib.dart' as extlib;
import 'package:meiyou_extensions_lib/models.dart';
import 'package:nice_dart/nice_dart.dart';
import 'package:path/path.dart' as p;

class ExtensionLoader {
  final ExtensionsFolderProvider _folderProvider;

  ExtensionLoader({required ExtensionsFolderProvider folderProvider})
      : _folderProvider = folderProvider;

  Future<Result<InstalledExtension>> loadFromPkgName(
      ExtensionCategory category, String pkgName) async {
    final folder = await _folderProvider.categoryDirectory(category);
    final dir = Directory(p.join(folder.path, pkgName));
    return loadExtension(dir);
  }

  Future<Result<List<InstalledExtension>>> loadExtensions(Directory dir) {
    return runAsyncCatching(() async {
      final List<InstalledExtension> extensions = [];
      for (final entry in dir.listSync()) {
        if (entry is Directory) {
          final result = await loadExtension(entry);
          if (result.isSuccess) {
            extensions.add(result.getOrThrow());
          }
        }
      }
      return extensions;
    });
  }

  File _getIconFile(String dirPath) {
    return File(p.join(dirPath, "icon.png"));
  }

  File _getMetadataFile(String dirPath) {
    return File(p.join(dirPath, "metadata.json"));
  }

  File _getCodeFile(String dirPath) {
    return File(p.join(dirPath, "code.evc"));
  }

  Future<Result<InstalledExtension>> loadExtension(Directory dir) async {
    return runAsyncCatching(() async {
      final dirPath = dir.path;
      final iconFile = _getIconFile(dirPath);
      final metadataFile = _getMetadataFile(dirPath);
      final codeFile = _getCodeFile(dirPath);

      assert(metadataFile.existsSync() && codeFile.existsSync());

      final metadata = PluginMetaData.decode(await metadataFile.readAsString());
      final code = await codeFile.readAsBytes();
      final sources = _loadSources(metadata.pkgName, code);

      final Uint8List? icon;
      if (iconFile.existsSync()) {
        icon = iconFile.readAsBytesSync();
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
        repoUrl: '',
        hasUpdate: false,
        isObsolote: false,
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
