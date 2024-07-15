import 'dart:io';

import 'package:meiyou/shared/data/data_sources/folder_providers/folder_provider.dart';
import 'package:meiyou/shared/data/data_sources/folder_providers/storage_folder_provider.dart';
import 'package:meiyou/shared/domain/models/extension_category.dart';
import 'package:path/path.dart' as p;

class ExtensionsFolderProvider implements FolderProvider {
  final StorageFolderProvider _storageFolderProvider;

  ExtensionsFolderProvider(this._storageFolderProvider);

  @override
  Future<Directory> directory() async {
    final path = await this.path();
    return Directory(path);
  }

  @override
  Future<String> path() =>
      _storageFolderProvider.path().then((path) => p.join(path, 'extensions'));

  Future<Directory> categoryDirectory(ExtensionCategory category) =>
      path().then((path) => Directory(p.join(path, category.name)));
}
