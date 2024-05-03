import 'dart:io';

import 'package:nice_dart/nice_dart.dart';

extension StringIOExtensions on String {
  Directory toDirectory() {
    return Directory(this);
  }

  File toFile() {
    return File(this);
  }
}

extension FileSystemEntityExtensions on FileSystemEntity {
  String get name => uri.pathSegments.where((e) => e.isNotEmpty).last;
}

extension DirectoryExtensions on Directory {
  String get name => uri.pathSegments.where((e) => e.isNotEmpty).last;

  File? findFile(String name) {
    return runCatching(
        () => listSync().firstWhere((e) => e.name == name) as File).getOrNull();
  }
}
