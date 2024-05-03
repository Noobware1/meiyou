import 'dart:io';

import 'package:nice_dart/nice_dart.dart';
import 'package:path_provider/path_provider.dart';

import 'folder_provider.dart';

class DataBaseFolderProvider implements FolderProvider {
  DataBaseFolderProvider();

  @override
  Future<Directory> directory() {
    return getApplicationDocumentsDirectory().then((directory) {
      final path = buildString((it) {
        it.write(directory.absolute.path);
        it.write(Platform.pathSeparator);
        it.write('.meiyou');
        it.write(Platform.pathSeparator);
        it.write('database');
      });
      return Directory(path)..createSync(recursive: true);
    });
  }

  @override
  Future<String> path() => directory().then((value) => value.absolute.path);

  @override
  Directory directorySync() => throw UnsupportedError(
      'Cannot call directorySync on DataBaseFolderProvider');

  @override
  String pathSync() =>
      throw UnsupportedError('Cannot call pathSync on DataBaseFolderProvider');
}
