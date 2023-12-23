import 'dart:io';
import 'package:archive/archive.dart';
import 'package:meiyou/core/client.dart';
import 'package:meiyou/core/resources/isar.dart';
import 'package:meiyou/core/utils/extenstions/directory.dart';
import 'package:meiyou/data/models/installed_plugin.dart';
import 'package:meiyou/data/models/plugin_list.dart';
import 'package:meiyou_extensions_lib/models.dart';
import 'package:path/path.dart' as path_helper;
import 'package:isar/isar.dart';

class PluginDao {
  late final String _pluginSavePath;
  PluginDao(this._pluginSavePath);

  Future<InstalledPlugin> installPlugin(OnlinePlugin plugin) async {
    try {
      final installedPlugin = await PluginInstaller(
        plugin: plugin,
        path: _pluginSavePath,
      ).install();
      await _addPlugin(installedPlugin);
      return installedPlugin;
    } catch (e, s) {
      throw FailedToInstalledPlugin(
        debugMessage: e,
        stackTrace: s,
      );
    }
  }

  Future<void> _addPlugin(InstalledPlugin plugin) async {
    await isar.writeTxn(() async => await isar.installedPlugins.put(plugin));
  }

  Future<void> uninstallPlugin(InstalledPlugin plugin) async {
    await Directory(
            path_helper.join(_pluginSavePath, plugin.name.toLowerCase()))
        .delete(recursive: true);
    await isar
        .writeTxn(() async => await isar.installedPlugins.delete(plugin.id));
  }

  Future<InstalledPlugin> updatePlugin(OnlinePlugin plugin) {
    return installPlugin(plugin);
  }

  Stream<List<InstalledPlugin>> getAllInstalledPlugins(String type) {
    return isar.installedPlugins
        .filter()
        .savedPathIsNotEmpty()
        .nameIsNotEmpty()
        .typeEqualTo(type, caseSensitive: false)
        .watch(fireImmediately: true)
        .asBroadcastStream();
  }

  Future<List<PluginList>> getAllUninstalledPluginsCache() {
    return isar.pluginLists.filter().nameIsNotEmpty().findAll();
  }

  void deletePluginListsCache() {
    isar.writeTxnSync(() {
      isar.pluginLists.clearSync();
    });
  }

  Future<void> addAllUnInstalledPluginsCache(List<PluginList> list) async {
    await isar.writeTxn(() async {
      await isar.pluginLists.clear();
      await isar.pluginLists.putAll(list);
    });
  }

  void updateLastUsedPlugin(
      InstalledPlugin previousPlugin, InstalledPlugin currentPlugin) {
    isar.writeTxnSync(() {
      //Checks if it exists first
      final prev = isar.installedPlugins
          .getSync(previousPlugin.id)
          ?.copyWith(lastUsed: false);

      final current = isar.installedPlugins
          .getSync(currentPlugin.id)
          ?.copyWith(lastUsed: true);

      if (current != null) isar.installedPlugins.putSync(current);
      if (prev != null) isar.installedPlugins.putSync(prev);
    });
  }

  InstalledPlugin? getLastUsedPlugin() {
    return isar.installedPlugins.filter().lastUsedEqualTo(true).findFirstSync();
  }
}

class FailedToInstalledPlugin implements Exception {
  final String message = 'Failed to install plugin';
  final Object? debugMessage;
  final StackTrace? stackTrace;
  FailedToInstalledPlugin({this.debugMessage, this.stackTrace});

  @override
  String toString() {
    return 'FailedToInstalledPlugin(message: $message, debugMessage: $debugMessage, stackTrace: $stackTrace)';
  }
}

class _Paths {
  final String pluginFolder;

  late final String codePath = path_helper.join(pluginFolder, 'code.evc');

  late final String iconPath = path_helper.join(pluginFolder, 'icon.png');

  _Paths({required this.pluginFolder});
}

class PluginInstaller {
  final _Paths _paths;
  final OnlinePlugin _plugin;

  PluginInstaller({required OnlinePlugin plugin, required String path})
      : _plugin = plugin,
        _paths = _Paths(
            pluginFolder: path_helper.join(path, plugin.name.toLowerCase()));

  Future<InstalledPlugin> install() async {
    //get and decode zip file

    final zip = ZipDecoder()
        .decodeBytes((await client.get(_plugin.downloadUrl)).bodyBytes);

    //create the directory
    final folder = Directory(_paths.pluginFolder)
      ..createIfDontExistSync(recursive: true);
    try {
      for (var file in zip.files) {
        if (file.name.endsWith('.evc')) {
          final codeFile = File(_paths.codePath);

          codeFile.writeAsBytesSync(file.content);
        } else if (file.name.endsWith('.png')) {
          final iconFile = File(_paths.iconPath);
          iconFile.writeAsBytesSync(file.content);
        }
      }

      return InstalledPlugin(
        id: _plugin.id,
        name: _plugin.name,
        type: _plugin.type,
        author: _plugin.author,
        description: _plugin.description,
        lang: _plugin.lang,
        baseUrl: _plugin.baseUrl,
        version: _plugin.version,
        updateurl: _plugin.downloadUrl,
        savedPath: _paths.pluginFolder,
        sourceCodePath: _paths.codePath,
        iconPath: _paths.iconPath,
      );
    } catch (e) {
      folder.deleteIfExistSync();
      rethrow;
    }
  }
}
