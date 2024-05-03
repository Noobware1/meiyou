import 'dart:io';

import 'package:meiyou/core/utils/resources/folder_provider/folder_provider.dart';
import 'package:meiyou/core/utils/resources/folder_provider/storage_folder_provider.dart';

class ExtensionsFolderProvider implements FolderProvider {
  ExtensionsFolderProvider();

  @override
  Directory directorySync() {
    return Directory(pathSync())..createSync();
  }

  @override
  String pathSync() =>
      StorageFolderProvider().pathSync() +
      Platform.pathSeparator +
      'extensions';

  @override
  Future<Directory> directory() => throw UnsupportedError('Not Supported');

  @override
  Future<String> path() => throw UnsupportedError('Not Supported');
}
