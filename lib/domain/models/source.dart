import 'dart:typed_data';

import 'package:injecktor/injecktor.dart';
import 'package:meiyou/extension/extension_manager.dart';
import 'package:meiyou/extension/models/entension_type.dart';
import 'package:meiyou_extensions_lib/models.dart' as model;

class Source {
  final int id;
  final String lang;
  final String name;

  Source({required this.id, required this.lang, required this.name});
}

// abstract class AvaliableSource extends Source {
//   abstract final String icon;
//   abstract final String baseUrl;
//   abstract final String plugin;

//   AvaliableSource({
//     required super.id,
//     required super.lang,
//     required super.name,
//   });

//   factory AvaliableSource.make(
//     ExtensionType type,
//     model.AvailableExtension extension,
//     model.AvailableSource source,
//   ) {
//     switch (type) {
//       case ExtensionType.Video:
//         return AvaliableVideoSource(
//           id: source.id,
//           lang: source.lang,
//           name: source.name,
//           icon: extension.iconUrl,
//           plugin: extension.pluginName,
//           baseUrl: source.baseUrl ?? '',
//         );
//       case ExtensionType.Manga:
//         return AvailiableMangaSource(
//           id: source.id,
//           lang: source.lang,
//           name: source.name,
//           icon: extension.iconUrl,
//           plugin: extension.pluginName,
//           baseUrl: source.baseUrl ?? '',
//         );
//       case ExtensionType.Novel:
//         return AvailableNovelSource(
//           id: source.id,
//           lang: source.lang,
//           name: source.name,
//           icon: extension.iconUrl,
//           plugin: extension.pluginName,
//           baseUrl: source.baseUrl ?? '',
//         );
//       default:
//         throw type.invailedTypeError();
//     }
//   }
// }

// class AvaliableVideoSource extends AvaliableSource {
//   AvaliableVideoSource({
//     required super.id,
//     required super.lang,
//     required super.name,
//     required this.icon,
//     required this.plugin,
//     this.baseUrl = '',
//   });

//   @override
//   final String baseUrl;

//   @override
//   final String icon;

//   @override
//   final String plugin;
// }

// class AvailiableMangaSource extends AvaliableSource {
//   AvailiableMangaSource({
//     required super.id,
//     required super.lang,
//     required super.name,
//     required this.icon,
//     required this.plugin,
//     this.baseUrl = '',
//   });
//   @override
//   final String baseUrl;

//   @override
//   final String icon;

//   @override
//   final String plugin;
// }

// class AvailableNovelSource extends AvaliableSource {
//   AvailableNovelSource({
//     required super.id,
//     required super.lang,
//     required super.name,
//     required this.icon,
//     required this.plugin,
//     this.baseUrl = '',
//   });

//   @override
//   final String baseUrl;

//   @override
//   final String icon;

//   @override
//   final String plugin;
// }

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
  Uint8List? get icon => InjectKtor.get<ExtensionManager>()
      .getIconForSource(id, ExtensionType.Video);
}

class InstalledMangaSource extends InstalledSource {
  InstalledMangaSource({
    required super.id,
    required super.lang,
    required super.name,
    super.pin,
  });

  @override
  Uint8List? get icon => InjectKtor.get<ExtensionManager>()
      .getIconForSource(id, ExtensionType.Manga);
}

class InstalledNovelSource extends InstalledSource {
  InstalledNovelSource({
    required super.id,
    required super.lang,
    required super.name,
    super.pin,
  });

  @override
  Uint8List? get icon => InjectKtor.get<ExtensionManager>()
      .getIconForSource(id, ExtensionType.Novel);
}

enum Pins {
  unpinned,
  pinned,
  acutal,
}
