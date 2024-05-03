import 'dart:io';

abstract interface class FolderProvider {
  Future<Directory> directory();

  Directory directorySync();

  Future<String> path();

  String pathSync();
}
