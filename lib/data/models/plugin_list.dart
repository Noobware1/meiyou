import 'package:isar/isar.dart';
import 'package:meiyou/core/utils/extenstions/iterable.dart';
import 'package:meiyou/data/models/plugin.dart';
import 'package:meiyou/domain/entities/plugin.dart';
import 'package:meiyou/domain/entities/plugin_list.dart';
part 'plugin_list.g.dart';

@collection
class PluginList extends PluginListEntity {
  final Id id;
  @override
  List<EmbedablePlugin> get plugins => super.plugins as List<EmbedablePlugin>;

  PluginList(
      {this.id = Isar.autoIncrement,
      required super.type,
      required List<EmbedablePlugin> plugins})
      : super(plugins: plugins);

  static List<PluginList> parseExtenstionList(dynamic json,
      [List<PluginList>? installedPlugins]) {
    final list = <PluginList>[];
    json as Map;

    for (var entry in json.entries) {
      list.add(PluginList(
          type: entry.key.toString(),
          plugins: (entry.value as List)
              .mapAsList((it) => EmbedablePlugin.fromJson(it))));
    }
    return list;
  }

  @override
  String toString() {
    return '''PluginList(type: $type, plugins: $plugins)''';
  }
}

@embedded
class EmbedablePlugin extends PluginEntity {
  const EmbedablePlugin({
    super.id = -1,
    super.name = '',
    super.source = '',
    super.version = '',
    super.lastUsed = false,
    super.installed = false,
    List<Dependency>? dependencies,
    super.icon,
    super.info,
  }) : super(dependencies: dependencies);

  factory EmbedablePlugin.fromJson(dynamic json) {
    final plugin = Plugin.fromJson(json);
    return EmbedablePlugin(
      id: plugin.id,
      name: plugin.name,
      source: plugin.source,
      version: plugin.version,
      lastUsed: plugin.lastUsed,
      installed: plugin.installed,
      dependencies: plugin.dependencies,
      icon: plugin.icon,
      info: plugin.info,
    );
  }

  Plugin toPlugin() {
    return Plugin.fromEntity(this);
  }

  @override
  List<Dependency>? get dependencies => super.dependencies as List<Dependency>?;
}
