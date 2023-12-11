import 'package:flutter/material.dart';
import 'package:meiyou/core/utils/extenstions/context.dart';
import 'package:meiyou/core/utils/extenstions/directory.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path_helper;
import 'dart:io' show Directory;

// final Future<Directory> tempDir = getTemporaryDirectory();//

class AppDirectories {
  final Directory pluginDirectory;
  final Directory databaseDirectory;

  AppDirectories({
    required this.databaseDirectory,
    required this.pluginDirectory,
  });

  static Future<AppDirectories> getInstance() async {
    final dirs = await Future.wait([
      getApplicationDocumentsDirectory(),
    ]);
    final appDocDir = Directory(path_helper.join(dirs[0].path, 'meiyou'));
    await appDocDir.createIfDontExist();

    final subDirectories = ['plugins', 'database'];

    final appDirs = <Directory>[];
    for (final subDir in subDirectories) {
      appDirs.add(Directory(path_helper.join(appDocDir.path, subDir))
        ..createIfDontExistSync());
    }

    return AppDirectories(
      pluginDirectory: appDirs[0],
      databaseDirectory: appDirs[1],
    );
  }

  factory AppDirectories.of(BuildContext context) {
    return context.repository<AppDirectories>();
  }
}
