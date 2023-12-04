import 'dart:convert';
import 'package:meiyou/core/utils/extenstions/iterable.dart';
import 'package:meiyou/core/utils/from_entity.dart';
import 'package:meiyou/domain/entities/plugin.dart';
import 'package:isar/isar.dart';
part 'plugin.g.dart';

@collection
class Plugin extends PluginEntity {
  @override
  Id get id => super.id;

  @override
  List<Dependency>? get dependencies =>
      super.dependencies?.mapAsList<Dependency>(
          (it) => it is Dependency ? it : Dependency.fromEntity(it));

  const Plugin({
    required Id id,
    required super.name,
    required super.source,
    required super.version,
    // required this.entityHash,
    super.lastUsed = false,
    super.installed = false,
    super.icon,
    super.info,
    List<Dependency>? dependencies,
  }) : super(dependencies: dependencies, id: id);

  factory Plugin.fromEntity(PluginEntity entity) {
    return createFromEntity<PluginEntity, Plugin>(
        entity,
        Plugin(
          id: entity.id,
          // entityHash: entity.hashCode,
          installed: entity.installed,
          lastUsed: entity.lastUsed,
          name: entity.name,
          source: entity.source,
          version: entity.version,
          icon: entity.icon,
          info: entity.info,
          dependencies: entity.dependencies?.mapAsList<Dependency>(
              (it) => it is Dependency ? it : Dependency.fromEntity(it)),
        ));
  }

  factory Plugin.decode(String jsonString) =>
      Plugin.fromJson(jsonDecode(jsonString));

  factory Plugin.fromJson(dynamic json) {
    return Plugin(
      id: json['id'],
      installed: json['installed'] ?? false,
      lastUsed: json['lastUsed'] ?? false,
      name: json['name'],
      source: json['source'],
      version: json['version'],
      icon: json['icon'],
      info: json['info'],
      dependencies: (json['dependencies'] as List?)
          ?.mapAsList((it) => Dependency.fromJson(it)),
    );
  }

  String get encode => jsonEncode(toJson());

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "name": name,
      "source": source,
      "version": version,
      "icon": icon,
      "info": info,
      "dependencies": dependencies?.mapAsList((e) => e.toJson()),
      "lastUsed": lastUsed,
      "installed": installed,
    };
  }

  Plugin copyWith({
    int? id,
    String? name,
    String? source,
    String? version,
    String? icon,
    String? info,
    List<Dependency>? dependencies,
    bool? lastUsed,
    bool? installed,
  }) {
    return Plugin(
      id: id ?? this.id,
      name: name ?? this.name,
      source: source ?? this.source,
      version: version ?? this.version,
      icon: icon ?? this.icon,
      info: info ?? this.info,
      dependencies: dependencies ?? this.dependencies,
      lastUsed: lastUsed ?? this.lastUsed,
      installed: installed ?? this.installed,
    );
  }

  @override
  String toString() {
    return '''Plugin(id: $id, name: $name, source: $source, version: $version, icon: $icon, info: $info, dependencies: $dependencies, lasUsed: $lastUsed, installed: $installed)''';
  }
}

@embedded
class Dependency extends DependencyEntity {
  const Dependency({
    super.name = '',
    super.source = '',
    super.version = '',
  });

  factory Dependency.fromEntity(DependencyEntity entity) {
    return Dependency(
      name: entity.name,
      source: entity.source,
      version: entity.version,
    );
  }

  factory Dependency.decode(String jsonString) =>
      Dependency.fromJson(jsonDecode(jsonString));

  factory Dependency.fromJson(dynamic json) {
    return Dependency(
      name: json['name'],
      source: json['source'],
      version: json['version'],
    );
  }

  String get encode => jsonEncode(toJson());
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'source': source,
      'version': version,
    };
  }

  @override
  String toString() {
    return '''Dependency(name: $name, source: $source, version: $version)''';
  }
}
