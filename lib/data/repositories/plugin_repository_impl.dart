import 'dart:async';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:meiyou/core/bridge/runtime.dart';
import 'package:meiyou/core/plugin/base_plugin_api.dart';
import 'package:meiyou/core/resources/response_state.dart';
import 'package:meiyou/core/utils/extenstions/list.dart';
import 'package:meiyou/core/utils/try_catch.dart';
import 'package:meiyou/data/data_source/local/dao/plugin_dao.dart';
import 'package:meiyou/data/models/plugin.dart';
import 'package:meiyou/data/models/plugin_list.dart';
import 'package:meiyou/domain/entities/plugin.dart';
import 'package:meiyou/domain/entities/plugin_list.dart';
import 'package:meiyou/domain/repositories/plugin_repository.dart';
import 'package:ok_http_dart/ok_http_dart.dart';
import 'package:meiyou/core/utils/extenstions/string.dart';

class PluginRepositoryImpl implements PluginRepository {
  PluginRepositoryImpl(this._pluginDir);

  late final PluginDao _pluginDao = PluginDao(_pluginDir);

  static const _extenstionsUrl =
      'https://raw.githubusercontent.com/Noobware1/meiyou-extenstions/master/extenstions.json';

  final String _pluginDir;

  @override
  Future<ResponseState<List<PluginList>>> getAllPlugins() {
    return ResponseState.tryWithAsync(() async {
      final cache = await _pluginDao.getAllUnInstalledPluginsCache();
      if (cache.isNotEmpty) {
        return cache;
      }

      final results = await tryAsync(() => compute(
            (url) async => (await OKHttpClient().get(url))
                .json(PluginList.parseExtenstionList),
            _extenstionsUrl,
          ));

      if (results == null) throw Exception('Couldn\'t load plugins list');
      await _pluginDao.addAllUnInstalledPluginsCache(results);
      return results;
    });
  }

  @override
  Stream<List<Plugin>> getInstalledPlugins() {
    return _pluginDao.getAllInstalledPlugins();
  }

  @override
  Future<Plugin> installPlugin(PluginEntity plugin) async {
    return _pluginDao.installPlugin(Plugin.fromEntity(plugin));
  }

  @override
  Future<void> uninstallPlugin(PluginEntity plugin) {
    return _pluginDao.uninstallPlugin(Plugin.fromEntity(plugin));
  }

  @override
  Plugin? checkForPluginUpdate(
      PluginEntity installedPlugin, List<PluginListEntity> plugins) {
    for (var i in plugins) {
      for (var plugin in i.plugins) {
        if (installedPlugin.id == plugin.id &&
            plugin.version.replaceAll('.', '').trim().toInt() >
                installedPlugin.version.replaceAll('.', '').trim().toInt()) {
          return Plugin.fromEntity(installedPlugin);
        }
      }
    }
    return null;
  }

  @override
  Future<Plugin> updatePlugin(
    PluginEntity plugin,
  ) {
    return _pluginDao.updatePlugin(Plugin.fromEntity(plugin));
  }

  @override
  Map<Plugin, Plugin>? getOutDatedPlugins(
      List<PluginEntity> installedPlugins, List<PluginListEntity> pluginList) {
    final List<MapEntry<Plugin, Plugin>> outDated = [];
    for (var installedPlugin in installedPlugins) {
      outDated.addIfNotNull(
          _getOutdatedAndLatestPlugin(installedPlugin, pluginList));
    }
    return outDated.isEmpty ? null : Map.fromEntries(outDated);
  }

  MapEntry<Plugin, Plugin>? _getOutdatedAndLatestPlugin(
      PluginEntity installedPlugin, List<PluginListEntity> pluginList) {
    for (var i in pluginList) {
      for (var plugin in i.plugins) {
        if (installedPlugin.id == plugin.id &&
            plugin.version.replaceAll('.', '').trim().toInt() >
                installedPlugin.version.replaceAll('.', '').trim().toInt()) {
          return MapEntry(
              Plugin.fromEntity(installedPlugin), Plugin.fromEntity(plugin));
        }
      }
    }
    return null;
  }

  @override
  Future<BasePluginApi> loadPlugin(PluginEntity plugin) async {
    final complied = await File(plugin.source).readAsBytes();
    final runtime = runtimeEval(complied);
    return runtime.executeLib('package:meiyou/main.dart', 'main')
        as BasePluginApi;
  }

  @override
  Plugin? getLastedUsedPlugin() {
    return _pluginDao.getLastUsedPlugin();
  }

@override
  
  void updateLastUsedPlugin(
      PluginEntity previousPlugin, PluginEntity currentPlugin) {
    return _pluginDao.updateLastUsedPlugin(
        Plugin.fromEntity(previousPlugin), Plugin.fromEntity(currentPlugin));
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
