import 'package:path_provider/path_provider.dart';
import 'dart:io' show Directory;

// final Future<Directory> tempDir = getTemporaryDirectory();//

class AppDirectories {
  final Directory appCacheDirectory;

  AppDirectories(this.appCacheDirectory);

  static Future<AppDirectories> getInstance() {
    return Future.wait([getApplicationCacheDirectory()])
        .then((value) => AppDirectories(value[0]));
  }

  // AppDirectories() {
  //   appCacheDirectory;

  // }
}
