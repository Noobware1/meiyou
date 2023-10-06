import 'dart:io';

extension DirectoryUtils on Directory {
  Future<void> deleteAllEntries([void Function()? callback]) async {
    try {
      if (existsSync()) {
        await for (var entity in list()) {
          if (entity is File) {
            await entity.delete();
          }
        }
        callback?.call();
      }
    } catch (e) {
      print(e);
    }
  }
}
