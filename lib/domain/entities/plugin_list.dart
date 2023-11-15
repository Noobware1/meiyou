import 'package:meiyou/domain/entities/plugin.dart';

class PluginListEntity {
  final String type;
  final List<PluginEntity> plugins;

  PluginListEntity({required this.type, required this.plugins});
}

// class EmbedablePluginEntity extends PluginEntity {
//   EmbedablePluginEntity({
//     required super.name,
//     required super.source,
//     required super.version,
//     required super.lastUsed,
//     super.dependencies,
//     super.icon,
//     super.info,
//   });
// }
