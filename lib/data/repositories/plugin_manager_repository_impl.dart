import 'dart:async';
import 'dart:io';
import 'package:meiyou/core/client.dart';
import 'package:meiyou/core/resources/response_state.dart';
import 'package:meiyou/core/utils/try_catch.dart';
import 'package:meiyou/data/data_source/local/dao/plugin_dao.dart';
import 'package:meiyou/data/models/installed_plugin.dart';
import 'package:meiyou/data/models/plugin_list.dart';
import 'package:meiyou/domain/entities/installed_plugin.dart';
import 'package:meiyou/domain/entities/plugin_list.dart';
import 'package:meiyou/domain/repositories/plugin_manager_repository.dart';
import 'package:meiyou_extenstions/meiyou_extenstions.dart';

class PluginManagerRepositoryImpl implements PluginManagerRepository {
  PluginManagerRepositoryImpl(this._pluginDir);

  late final PluginDao _pluginDao = PluginDao(_pluginDir);
  final String _pluginDir;

  static const _indexUrl =
      'https://raw.githubusercontent.com/Noobware1/meiyou_extensions_repo/builds/index.json';

  @override
  Future<ResponseState<List<PluginList>>> getAllPlugins() {
    return ResponseState.tryWithAsync(() async {
      final cache = await _pluginDao.getAllUninstalledPluginsCache();
      if (cache.isNotEmpty) {
        return cache;
      }

      final pluginList = await tryAsync(() async =>
          (await client.get(_indexUrl)).json(PluginList.parseIndexJson));

      if (pluginList == null) throw Exception('Couldn\'t load plugins list');
      await _pluginDao.addAllUnInstalledPluginsCache(pluginList);
      return pluginList;
    });
  }

  @override
  Stream<List<InstalledPlugin>> getInstalledPlugins() {
    return _pluginDao.getAllInstalledPlugins();
  }

  @override
  Future<InstalledPlugin> installPlugin(OnlinePlugin plugin) async {
    return _pluginDao.installPlugin(plugin);
  }

  @override
  Future<void> uninstallPlugin(InstalledPluginEntity plugin) {
    return _pluginDao.uninstallPlugin(InstalledPlugin.fromEntity(plugin));
  }

  @override
  void deletePluginListsCache() {
    return _pluginDao.deletePluginListsCache();
  }

  @override
  InstalledPlugin? checkForPluginUpdate(
      InstalledPluginEntity installedPlugin, List<PluginListEntity> plugins) {
    for (var i in plugins) {
      for (var plugin in i.plugins) {
        if (installedPlugin.id == plugin.id &&
            plugin.version.replaceAll('.', '').trim().toInt() >
                installedPlugin.version.replaceAll('.', '').trim().toInt()) {
          return InstalledPlugin.fromEntity(installedPlugin);
        }
      }
    }
    return null;
  }

  @override
  Future<InstalledPlugin> updatePlugin(
    OnlinePlugin plugin,
  ) {
    return _pluginDao.updatePlugin(plugin);
  }

  @override
  Map<InstalledPlugin, OnlinePlugin>? getOutDatedPlugins(
      List<InstalledPluginEntity> installedPlugins,
      List<PluginListEntity> pluginList) {
    final List<MapEntry<InstalledPlugin, OnlinePlugin>> outDated = [];
    for (var installedPlugin in installedPlugins) {
      outDated.addIfNotNull(
          _getOutdatedAndLatestPlugin(installedPlugin, pluginList));
    }
    return outDated.isEmpty ? null : Map.fromEntries(outDated);
  }

  MapEntry<InstalledPlugin, OnlinePlugin>? _getOutdatedAndLatestPlugin(
      InstalledPluginEntity installedPlugin,
      List<PluginListEntity> pluginList) {
    for (var i in pluginList) {
      for (var plugin in i.plugins) {
        if (installedPlugin.id == plugin.id &&
            plugin.version.replaceAll('.', '').trim().toInt() >
                installedPlugin.version.replaceAll('.', '').trim().toInt()) {
          return MapEntry(InstalledPlugin.fromEntity(installedPlugin),
              plugin);
        }
      }
    }
    return null;
  }

  @override
  Future<BasePluginApi> loadPlugin(InstalledPluginEntity plugin) async {
    final complied = await File(plugin.sourceCodePath).readAsBytes();
    final runtime = ExtenstionLoader().runtimeEval(complied);
    return runtime.executeLib('package:meiyou/main.dart', 'main')
        as BasePluginApi;
  }

  @override
  InstalledPlugin? getLastedUsedPlugin() {
    return _pluginDao.getLastUsedPlugin();
  }

  @override
  void updateLastUsedPlugin(InstalledPluginEntity previousPlugin,
      InstalledPluginEntity currentPlugin) {
    return _pluginDao.updateLastUsedPlugin(
        InstalledPlugin.fromEntity(previousPlugin),
        InstalledPlugin.fromEntity(currentPlugin));
  }
}

class NoPluginsFound implements Exception {
  final Object? message;
  NoPluginsFound(this.message);

  @override
  String toString() {
    if (message == null) return "NoPluginsFound";
    return "NoPluginsFound: $message";
  }
}
