import 'dart:typed_data';

import 'package:meiyou/core/utils/resources/get_it/get_it.dart';
import 'package:meiyou/extension/extension_manager.dart';
import 'package:meiyou/extension/models/entension_type.dart';
import 'package:meiyou_extensions_lib/models.dart' as model;

class Source {
  final int id;
  final String lang;
  final String name;

  Source({required this.id, required this.lang, required this.name});
}

abstract class InstalledSource extends Source {
  final Pins pin;

  InstalledSource({
    required super.id,
    required super.lang,
    required super.name,
    this.pin = Pins.unpinned,
  });

  factory InstalledSource.fromSource(ExtensionType type, model.Source source) {
    switch (type) {
      case ExtensionType.Video:
        return InstalledVideoSource(
          id: source.id,
          lang: source.lang,
          name: source.name,
        );
      case ExtensionType.Manga:
        return InstalledMangaSource(
          id: source.id,
          lang: source.lang,
          name: source.name,
        );
      case ExtensionType.Novel:
        return InstalledNovelSource(
          id: source.id,
          lang: source.lang,
          name: source.name,
        );
      default:
        throw type.invailedTypeError();
    }
  }

  Uint8List? get icon;
}

class InstalledVideoSource extends InstalledSource {
  InstalledVideoSource({
    required super.id,
    required super.lang,
    required super.name,
    super.pin,
  });

  @override
  Uint8List? get icon =>
      getIt.get<ExtensionManager>().getIconForSource(id, ExtensionType.Video);
}

class InstalledMangaSource extends InstalledSource {
  InstalledMangaSource({
    required super.id,
    required super.lang,
    required super.name,
    super.pin,
  });

  @override
  Uint8List? get icon =>
      getIt.get<ExtensionManager>().getIconForSource(id, ExtensionType.Manga);
}

class InstalledNovelSource extends InstalledSource {
  InstalledNovelSource({
    required super.id,
    required super.lang,
    required super.name,
    super.pin,
  });

  @override
  Uint8List? get icon =>
      getIt.get<ExtensionManager>().getIconForSource(id, ExtensionType.Novel);
}

enum Pins {
  unpinned,
  pinned,
  acutal,
}
