import 'dart:io';

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
}
