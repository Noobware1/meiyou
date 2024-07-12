import 'dart:async';
import 'dart:io';

import 'package:meiyou/core/injection/injection.dart';
import 'package:meiyou/shared/data/data_sources/folder_providers/folder_provider.dart';
import 'package:meiyou/shared/data/data_sources/preferences/storage_preferences.dart';
import 'package:meiyou_extensions_lib/preference.dart';

class StorageFolderProvider implements FolderProvider {
  final StoragePreferences _preferences;

  StorageFolderProvider() : _preferences = getIt.get<StoragePreferences>();

  @override
  Future<Directory> directory() => path().then((path) => Directory(path));

  @override
  Future<String> path() =>
      Future.value(_preferences.baseStorageDirectory().get());
}
