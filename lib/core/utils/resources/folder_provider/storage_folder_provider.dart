// ignore_for_file: prefer_interpolation_to_compose_strings

import 'dart:io';

import 'package:meiyou/core/utils/resources/folder_provider/folder_provider.dart';
import 'package:meiyou/core/utils/resources/get_it/get_it.dart';
import 'package:meiyou/core/utils/resources/storage/storage_preferences.dart';

class StorageFolderProvider implements FolderProvider {
  StorageFolderProvider() : _storagePreferences = getIt.get();

  late final StoragePreferences _storagePreferences;

  @override
  Directory directorySync() {
    return Directory(_storagePreferences.baseStorageDirectory().get());
  }

  @override
  String pathSync() => directorySync().absolute.path;

  @override
  Future<Directory> directory() => throw UnsupportedError('Not Supported');

  @override
  Future<String> path() => throw UnsupportedError('Not Supported');
}
