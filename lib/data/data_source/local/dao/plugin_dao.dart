import 'dart:io';
import 'package:meiyou/core/client.dart';
import 'package:meiyou/core/resources/isar.dart';
import 'package:meiyou/core/utils/extenstions/directory.dart';
import 'package:meiyou/core/utils/extenstions/file.dart';
import 'package:meiyou/core/utils/extenstions/string.dart';
import 'package:meiyou/data/models/plugin_list.dart';
import 'package:path/path.dart' as path_helper;
import 'package:meiyou/core/utils/try_catch.dart';
import 'package:meiyou/data/models/plugin.dart';
import 'package:meiyou/core/bridge/compile.dart' as c;
import 'package:isar/isar.dart';

class PluginDao {
  late final String _pluginSavePath;
  PluginDao(this._pluginSavePath);

  Future<Plugin> installPlugin(Plugin plugin) async {
    final installedPlugin = await tryAsync(
        () => PluginInstaller(
              plugin: plugin,
              path: _pluginSavePath,
            ).install(),
        log: true);
    if (installedPlugin == null) {
      throw Exception('Failed to Install Plugin');
    }
    await _addPlugin(installedPlugin);
    return installedPlugin;
  }

  Future<void> _addPlugin(Plugin plugin) async {
    await isar.writeTxn(() async => await isar.plugins.put(plugin));
  }

  Future<void> uninstallPlugin(Plugin plugin) async {
    await Directory(
            path_helper.join(_pluginSavePath, plugin.name.toLowerCase()))
        .delete(recursive: true);
    await isar.writeTxn(() async => await isar.plugins.delete(plugin.id));
  }

  Future<Plugin> updatePlugin(Plugin plugin) {
    return installPlugin(plugin);
  }

  Stream<List<Plugin>> getAllInstalledPlugins() {
    return isar.plugins
        .filter()
        .sourceIsNotEmpty()
        .nameIsNotEmpty()
        .watch(fireImmediately: true);
  }

  Future<List<PluginList>> getAllUnInstalledPluginsCache() {
    return isar.pluginLists.filter().pluginsIsNotEmpty().findAll();
  }

  Future<void> addAllUnInstalledPluginsCache(List<PluginList> list) async {
    await isar.writeTxn(() async {
      await isar.pluginLists.clear();
      await isar.pluginLists.putAll(list);
    });
  }

  void updateLastUsedPlugin(Plugin previousPlugin, Plugin currentPlugin) {
    isar.writeTxnSync(() {
      //Checks if it exists first
      final prev =
          isar.plugins.getSync(previousPlugin.id)?.copyWith(lastUsed: false);

      final current =
          isar.plugins.getSync(currentPlugin.id)?.copyWith(lastUsed: true);

      if (current != null) isar.plugins.putSync(current);
      if (prev != null) isar.plugins.putSync(prev);
    });
  }

  Plugin? getLastUsedPlugin() {
    return isar.plugins.filter().lastUsedEqualTo(true).findFirstSync();
  }
}

class FailedToInstalledPlugin implements Exception {
  final String message = 'Failed to install plugin';
  final Object? debugMessage;
  final StackTrace? stackTrace;
  FailedToInstalledPlugin({this.debugMessage, this.stackTrace});
}

class _Paths {
  final String codePath;
  // final String pluginPath;
  late String? iconPath;

  _Paths({required String savepath, String? icon})
      : codePath = path_helper.join(savepath, 'code.evc'),
        // pluginPath = '$savepath/plugin.json',
        iconPath = icon != null
            ? path_helper.join(savepath, 'icon.${icon.substringAfterLast(".")}')
            : null;
}

class PluginInstaller {
  late String savePath;

  late final _paths = _Paths(savepath: savePath, icon: plugin.icon);
  final Plugin plugin;

  PluginInstaller({required this.plugin, required String path})
      : savePath = path_helper.join(path, plugin.name.toLowerCase());

  Future<bool> _downloadIcon() async {
    if (plugin.icon != null && plugin.icon!.startsWith('http')) {
      File(_paths.iconPath!).deleteIfExistSync();
      await tryAsync(() => client.download(
          savePath: _paths.iconPath!,
          deleteOnError: true,
          url: plugin.icon,
          timeout: const Duration(minutes: 5)));
      return true;
    }

    return false;
  }

  Future<void> _downloadPlugin() async {
    final source = plugin.source.startsWith('http')
        ? (await client.get(plugin.source)).text
        : (await File(plugin.source).readAsString());
    final files = {
      'main.dart': source,
    };
    await _getAllDependencies(files);

    await mabyeCompile(files);
  }

  Future<void> _getAllDependencies(Map<String, String> files) async {
    if (plugin.dependencies != null) {
      for (Dependency dependency in plugin.dependencies!) {
        files['${dependency.name}.dart'] = dependency.source.startsWith('http')
            ? (await client.get(dependency.source)).text
            : (await File(dependency.source).readAsString());
      }
    }
    return;
  }

  Future<void> mabyeCompile(Map<String, String> files) async {
    final file = File(_paths.codePath)..createIfNotExistSync();

    try {
      final bytecode = c.compilerEval({'meiyou': files});

      file.writeAsBytes(bytecode);
    } catch (e, s) {
      print('$e\n$s');
      file.deleteIfExistSync();
      rethrow;
    }
  }

  Future<Plugin> install() async {
    final dir = Directory(savePath)..createIfDontExistSync(recursive: true);

    try {
      final icon = await _downloadIcon();
      await _downloadPlugin();

      final installedPlugin = Plugin(
          id: plugin.id,
          source: _paths.codePath,
          name: plugin.name,
          icon: icon == true ? _paths.iconPath : null,
          version: plugin.version,
          info: plugin.info,
          dependencies: null,
          installed: true);

      // final jsonFile = File(_paths.pluginPath)..createSync();

      // await jsonFile.writeAsString(installedPlugin.encode);
      print('Successfully installed plugin at $savePath');
      // return installedPlugin;

      return installedPlugin;
    } catch (e, s) {
      print('$e\n$s');
      dir.deleteSync(recursive: true);
      throw Exception('Failed to install plugin!');
    }
  }
}
