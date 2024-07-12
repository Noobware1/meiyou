import 'package:flutter/foundation.dart';
import 'package:meiyou/shared/domain/models/extension_category.dart';
import 'package:isar/isar.dart';
import 'package:meiyou_extensions_lib/models.dart' as m;

abstract class Source {
  final int id;
  final String name;
  final String language;
  final ExtensionCategory category;

  Source({
    required this.id,
    required this.name,
    required this.category,
    required this.language,
  });
}

class InstalledSource extends Source {
  @enumerated
  final Pin pin;
  final bool isUsedLast;
  final String version;
  final Uint8List? icon;

  InstalledSource({
    required super.id,
    required super.name,
    required super.category,
    required super.language,
    required this.version,
    this.icon,
    this.pin = Pin.unPinned,
    this.isUsedLast = false,
  });


  InstalledSource copyWith({
    int? id,
    String? name,
    ExtensionCategory? category,
    String? language,
    Uint8List? icon,
    String? version,
    bool? isUsedLast,
    Pin? pin,
  }) {
    return InstalledSource(
      id: id ?? this.id,
      name: name ?? this.name,
      category: category ?? this.category,
      language: language ?? this.language,
      icon: icon ?? this.icon,
      isUsedLast: isUsedLast ?? this.isUsedLast,
      version: version ?? this.version,
      pin: pin ?? this.pin,
    );
  }

  bool get isPinned => pin == Pin.pinned;
}

class AvailableSource extends Source {
  final String repoUrl;
  final String iconUrl;
  final String version;
  final bool isInstalled;
  final bool hasUpdate;

  AvailableSource({
    required super.id,
    required super.name,
    required super.category,
    required super.language,
    required this.repoUrl,
    required this.iconUrl,
    required this.version,
    this.isInstalled = false,
    this.hasUpdate = false,
  });

  static List<AvailableSource> fromExtension(
      m.AvailableExtension extension, ExtensionCategory category) {
    return extension.sources
        .map(
          (e) => AvailableSource(
            id: e.id,
            name: e.name,
            category: category,
            language: e.lang,
            repoUrl: extension.repoUrl,
            iconUrl: extension.iconUrl,
            version: extension.versionName,
          ),
        )
        .toList();
  }
}

enum Pin {
  pinned,
  unPinned,
}
