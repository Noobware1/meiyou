import 'dart:async';
import 'dart:io';

abstract class FolderProvider {
  Future<String> path();

  Future<Directory> directory();
}
