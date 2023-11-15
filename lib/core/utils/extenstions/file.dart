import 'dart:io';

extension FileUtils on File {
  Future<FileSystemEntity?> deleteIfExist({bool recursive = false}) async {
    if (await exists()) {
      return delete(recursive: recursive);
    }
    return null;
  }

  void deleteIfExistSync({bool recursive = false}) {
    if (existsSync()) {
      deleteSync(recursive: recursive);
    }
    return;
  }
}
