import 'package:meiyou/core/plugin/base_plugin_api.dart';
import 'plugin.dart';

class LoadedPluginEntity {
  final PluginEntity plugin;
  final BasePluginApi api;

  LoadedPluginEntity({required this.plugin, required this.api});
}
