// ignore_for_file: unnecessary_overrides, use_super_parameters

import 'dart:convert';

import 'package:isar/isar.dart';
import 'package:meiyou/core/utils/from_entity.dart';
import 'package:meiyou/domain/entities/installed_plugin.dart';

part 'installed_plugin.g.dart';

@collection
class InstalledPlugin extends InstalledPluginEntity {
  const InstalledPlugin({
    required Id id,
    required super.name,
    required super.type,
    required super.author,
    required super.description,
    required super.lang,
    required super.baseUrl,
    required super.version,
    required super.updateurl,
    required super.savedPath,
    required super.sourceCodePath,
    required super.iconPath,
    super.lastUsed = false,
  }) : super(id: id);

  @override
  Id get id => super.id;

  factory InstalledPlugin.decode(String json) =>
      InstalledPlugin.fromJson(jsonDecode(json));

  String get encode => jsonEncode(toJson());

  factory InstalledPlugin.fromJson(Map<String, dynamic> json) {
    return InstalledPlugin(
      id: json['id'],
      name: json['name'],
      type: json['type'],
      author: json['author'],
      description: json['description'],
      lang: json['lang'],
      baseUrl: json['baseUrl'],
      version: json['version'],
      updateurl: json['updateurl'],
      savedPath: json['savedPath'],
      sourceCodePath: json['sourceCodePath'],
      iconPath: json['iconPath'],
      lastUsed: json['lastUsed'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'type': type,
      'author': author,
      'description': description,
      'lang': lang,
      'baseUrl': baseUrl,
      'version': version,
      'updateurl': updateurl,
      'savedPath': savedPath,
      'sourceCodePath': sourceCodePath,
      'iconPath': iconPath,
      'lastUsed': lastUsed,
    };
  }

  InstalledPlugin copyWith({
    Id? id,
    String? name,
    String? type,
    String? author,
    String? description,
    String? lang,
    String? baseUrl,
    String? version,
    String? updateurl,
    String? savedPath,
    String? sourceCodePath,
    String? iconPath,
    bool? lastUsed,
  }) {
    return InstalledPlugin(
      id: id ?? this.id,
      name: name ?? this.name,
      type: type ?? this.type,
      author: author ?? this.author,
      description: description ?? this.description,
      lang: lang ?? this.lang,
      baseUrl: baseUrl ?? this.baseUrl,
      version: version ?? this.version,
      updateurl: updateurl ?? this.updateurl,
      savedPath: savedPath ?? this.savedPath,
      sourceCodePath: sourceCodePath ?? this.sourceCodePath,
      iconPath: iconPath ?? this.iconPath,
      lastUsed: lastUsed ?? this.lastUsed,
    );
  }

  factory InstalledPlugin.fromEntity(InstalledPluginEntity entity) {
    return createFromEntity<InstalledPluginEntity, InstalledPlugin>(
        entity,
        InstalledPlugin(
          id: entity.id,
          name: entity.name,
          type: entity.type,
          author: entity.author,
          description: entity.description,
          lang: entity.lang,
          baseUrl: entity.baseUrl,
          version: entity.version,
          updateurl: entity.updateurl,
          savedPath: entity.savedPath,
          sourceCodePath: entity.sourceCodePath,
          iconPath: entity.iconPath,
          lastUsed: entity.lastUsed,
        ));
  }
}
