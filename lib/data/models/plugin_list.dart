// ignore_for_file: unnecessary_overrides, unnecessary_this, use_super_parameters

import 'package:isar/isar.dart';
import 'package:meiyou/domain/entities/plugin_list.dart';
import 'package:meiyou_extensions_lib/extenstions.dart';
import 'package:meiyou_extensions_lib/models.dart';

part 'plugin_list.g.dart';

@collection
class PluginList extends PluginListEntity {
  @override
  Id get id => super.id;

  @override
  List<EmbeddedPlugin> get plugins => super.plugins.mapAsList(
      (it) => it is EmbeddedPlugin ? it : EmbeddedPlugin.fromPlugin(it));

  PluginList({
    Id id = Isar.autoIncrement,
    required String name,
    required List<EmbeddedPlugin> plugins,
  }) : super(id: id, name: name, plugins: plugins);

  factory PluginList.fromMap(MapEntry entry) {
    return PluginList(
        name: entry.key.toString(),
        plugins: (entry.value as List)
            .mapAsList((it) => EmbeddedPlugin.fromJson(it)));
  }

  static parseIndexJson(dynamic json) {
    return (json as Map).entries.mapAsList((it) => PluginList.fromMap(it));
  }

  @override
  String toString() {
    return 'PluginList{name: $name, plugins: $plugins';
  }
}

@embedded
class EmbeddedPlugin extends OnlinePlugin {
  EmbeddedPlugin({
    int id = 0,
    super.name = '',
    super.type = '',
    super.author = '',
    super.description = '',
    super.lang = '',
    super.baseUrl = '',
    super.version = '',
    super.downloadUrl = '',
    super.iconUrl = '',
  }) : super(id: id);

  factory EmbeddedPlugin.fromPlugin(Plugin plugin) {
    return plugin.toEmbeddedPlugin();
  }

  factory EmbeddedPlugin.fromJson(Map<String, dynamic> json) {
    return OnlinePlugin.fromJson(json).toEmbeddedPlugin();
  }

  @override
  String toString() {
    return super.toString().replaceFirst('OnlinePlugin', 'EmbeddedPlugin');
  }
}

extension on Plugin {
  EmbeddedPlugin toEmbeddedPlugin() {
    if (this is OnlinePlugin) {
      return EmbeddedPlugin(
        id: this.id,
        name: this.name,
        type: this.type,
        author: this.author,
        description: this.description,
        lang: this.lang,
        baseUrl: this.baseUrl,
        version: this.version,
        downloadUrl: this.downloadUrl,
        iconUrl: (this as OnlinePlugin).iconUrl,
      );
    }
    return EmbeddedPlugin(
      id: this.id,
      name: this.name,
      type: this.type,
      author: this.author,
      description: this.description,
      lang: this.lang,
      baseUrl: this.baseUrl,
      version: this.version,
      downloadUrl: this.downloadUrl,
      iconUrl: '',
    );
  }
}
