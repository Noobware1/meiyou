import 'dart:io';
import 'package:meiyou_extenstions/extenstions.dart';

extension DirectoryUtils on Directory {
  void deleteAllEntries([void Function()? callback]) {
    try {
      if (existsSync()) {
        listSync().forEach((e) {
          e.deleteSync(recursive: true);
        });
        callback?.call();
      }
    } catch (e, s) {
      print(e);
      print(s);
    }
  }

  void deleteIfExistSync([bool recursive = false]) {
    if (!existsSync()) return;
    return deleteSync(recursive: recursive);
  }

  Future<FileSystemEntity?> deleteIfExist([bool recursive = false]) async {
    if (!existsSync()) return null;
    return delete(recursive: recursive);
  }

  void createIfDontExistSync({bool recursive = false}) {
    if (!existsSync()) {
      return createSync(recursive: recursive);
    }
  }

  Future<Directory?> createIfDontExist({bool recursive = false}) async {
    if (await exists()) {
      return null;
    }
    return create(recursive: recursive);
  }

  String get name => path.substringAfterLast('\\');
}
