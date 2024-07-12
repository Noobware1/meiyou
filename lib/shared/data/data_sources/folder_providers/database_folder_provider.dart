import 'dart:io';

import 'package:meiyou/shared/data/data_sources/folder_providers/folder_provider.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

class DataBaseFolderProvider implements FolderProvider {
  @override
  Future<Directory> directory() => path().then((path) => Directory(path));

  @override
  Future<String> path() => getApplicationSupportDirectory()
      .then((value) => p.join(value.absolute.path, 'database'));
}
