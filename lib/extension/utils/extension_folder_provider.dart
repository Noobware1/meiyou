import 'dart:io';

import 'package:meiyou/core/utils/resources/folder_provider/folder_provider.dart';
import 'package:meiyou/core/utils/resources/folder_provider/storage_folder_provider.dart';
import 'package:meiyou/extension/models/entension_type.dart';

class ExtensionsFolderProvider implements FolderProvider {
  @override
  Future<Directory> directory() => throw UnsupportedError("Not supported");

  @override
  Future<String> path() => throw UnsupportedError("Not supported");

  @override
  Directory directorySync() => Directory(pathSync())..createSync();

  @override
  String pathSync() =>
      StorageFolderProvider().pathSync() +
      Platform.pathSeparator +
      "extensions";

  String getPathFromType(ExtensionType type) {
    switch (type) {
      case ExtensionType.Video:
        return videoPath();
      case ExtensionType.Manga:
        return mangaPath();
      case ExtensionType.Novel:
        return novelPath();
      default:
        throw ArgumentError.value(type, "type", "Invalid Extension Type");
    }
  }

  Directory getFolderFromType(ExtensionType type) =>
      Directory(getPathFromType(type))..createSync(recursive: true);

  String videoPath() => pathSync() + Platform.pathSeparator + 'video';

  Directory video() => Directory(videoPath())..createSync(recursive: true);

  String mangaPath() => pathSync() + Platform.pathSeparator + 'manga';

  Directory manga() => Directory(mangaPath())..createSync(recursive: true);

  String novelPath() => pathSync() + Platform.pathSeparator + 'novel';

  Directory novel() => Directory(novelPath())..createSync(recursive: true);
}
