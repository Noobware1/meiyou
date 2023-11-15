import 'dart:io';
import 'package:meiyou/core/bridge/runtime.dart';
import 'package:meiyou/data/models/plugin.dart';
import 'package:meiyou/domain/entities/loaded_plugin.dart';

class LoadedPlugin extends LoadedPluginEntity {
  @override
  Plugin get plugin => super.plugin as Plugin;

  LoadedPlugin({required super.plugin, required super.api});

  static Future<LoadedPlugin> load(Plugin plugin) async {
    final file = File(plugin.source);
    return LoadedPlugin(
        plugin: plugin,
        api: executeRuntime(runtimeEval((await file.readAsBytes()))));
  }

  static LoadedPlugin loadSync(Plugin plugin) {
    final file = File(plugin.source);
    return LoadedPlugin(
        plugin: plugin,
        api: executeRuntime(runtimeEval(file.readAsBytesSync())));
  }

  @override
  String toString() {
    return 'LoadedPlugin(plugin: $plugin, api: $api)';
  }
}
