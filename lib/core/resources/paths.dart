import 'package:path_provider/path_provider.dart';
import 'dart:io' show Directory;

// final Future<Directory> tempDir = getTemporaryDirectory();//

class AppDirectories {
  final Directory appCacheDirectory;
  final Directory appDocumentDirectory;
  final Directory settingsDirectory;
  // final Directory cacheResponsesDirectory;
  final Directory savedSelectedResponseDirectory;

  AppDirectories({
    required this.appCacheDirectory,
    required this.appDocumentDirectory,
    required this.settingsDirectory,
    required this.savedSelectedResponseDirectory,
    // required this.cacheResponsesDirectory,
    // required this.responsesCacheDirectory
  });

  static Future<AppDirectories> getInstance() async {
    final dirs = await Future.wait([
      getApplicationCacheDirectory(),
      getApplicationDocumentsDirectory(),
    ]);

    final appDocDir = Directory('${dirs[1].path}/meiyou');
    if (!appDocDir.existsSync()) {
      appDocDir.createSync();
    }
    final subDirectories = [
      'settings',
      'saved_selected_res',
      'cache_responses'
    ];

    for (final subDirName in subDirectories) {
      final subDir = Directory('${appDocDir.path}/$subDirName');
      if (!subDir.existsSync()) {
        subDir.createSync();
      }
    }

    return AppDirectories(
      appCacheDirectory: dirs[0],
      appDocumentDirectory: appDocDir,
      settingsDirectory: Directory('${appDocDir.path}/${subDirectories[0]}'),
      savedSelectedResponseDirectory:
          Directory('${appDocDir.path}/${subDirectories[1]}'),
    );
  }
}
