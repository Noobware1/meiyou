import 'package:path_provider/path_provider.dart';
import 'dart:io' show Directory;

// final Future<Directory> tempDir = getTemporaryDirectory();//

class AppDirectories {
  final Directory appCacheDirectory;
  // final Directory responsesCacheDirectory;

  AppDirectories(
      {required this.appCacheDirectory, 
      // required this.responsesCacheDirectory
      });

  static Future<AppDirectories> getInstance() {
    return Future.wait([getApplicationCacheDirectory()]).then((value) =>
        AppDirectories(
            appCacheDirectory: value[0],
            // responsesCacheDirectory:
            //     Directory('${value[0].path}\\responses_folder')
                )
                );
  }

  
}


