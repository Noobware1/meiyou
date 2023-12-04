import 'package:meiyou/core/plugin/base_plugin_api.dart';
import 'package:meiyou/core/resources/response_state.dart';
import 'package:meiyou/domain/entities/plugin.dart';
import 'package:meiyou/domain/entities/plugin_list.dart';

abstract class PluginRepository {
  Future<ResponseState<List<PluginListEntity>>> getAllPlugins();

  Stream<List<PluginEntity>> getInstalledPlugins();

  Future<PluginEntity> installPlugin(PluginEntity plugin);

  Future<void> uninstallPlugin(PluginEntity plugin);

  PluginEntity? checkForPluginUpdate(
      PluginEntity installedPlugin, List<PluginListEntity> plugins);

  Future<PluginEntity> updatePlugin(PluginEntity plugin);

  Map<PluginEntity, PluginEntity>? getOutDatedPlugins(
      List<PluginEntity> installedPlugins, List<PluginListEntity> pluginList);

  Future<BasePluginApi> loadPlugin(PluginEntity plugin);

  void updateLastUsedPlugin(
      PluginEntity previousPlugin, PluginEntity currentPlugin);

      
  PluginEntity? getLastedUsedPlugin();
}
