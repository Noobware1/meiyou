import 'package:meiyou/core/resources/response_state.dart';
import 'package:meiyou/domain/entities/installed_plugin.dart';
import 'package:meiyou/domain/entities/plugin_list.dart';
import 'package:meiyou_extensions_lib/models.dart';

abstract interface class PluginManagerRepository {
  Future<ResponseState<List<PluginListEntity>>> getAllPlugins();

  Stream<List<InstalledPluginEntity>> getInstalledPlugins(String type);

  Future<InstalledPluginEntity> installPlugin(OnlinePlugin plugin);

  Future<void> uninstallPlugin(InstalledPluginEntity plugin);

  InstalledPluginEntity? checkForPluginUpdate(
      InstalledPluginEntity installedPlugin, List<PluginListEntity> plugins);

  Future<InstalledPluginEntity> updatePlugin(OnlinePlugin plugin);

  Map<InstalledPluginEntity, OnlinePlugin>? getOutDatedPlugins(
      List<InstalledPluginEntity> installedPlugins,
      List<PluginListEntity> pluginList);

  Future<BasePluginApi> loadPlugin(InstalledPluginEntity plugin);

  void updateLastUsedPlugin(InstalledPluginEntity previousPlugin,
      InstalledPluginEntity currentPlugin);

  InstalledPluginEntity? getLastedUsedPlugin();

  void deletePluginListsCache();
}
