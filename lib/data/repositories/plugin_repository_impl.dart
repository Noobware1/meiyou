import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:isolate';
import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import 'package:meiyou/core/bridge/compile.dart' as c;
import 'package:meiyou/core/bridge/runtime.dart';
import 'package:meiyou/core/client.dart';
import 'package:meiyou/core/plugin/base_plugin_api.dart';
import 'package:meiyou/core/resources/isar.dart';
// import 'package:meiyou/core/resources/logger.dart';
import 'package:meiyou/core/resources/response_state.dart';
import 'package:meiyou/core/utils/extenstions/file.dart';
import 'package:meiyou/core/utils/try_catch.dart';
import 'package:meiyou/data/data_source/local/dao/plugin_dao.dart';
import 'package:meiyou/data/models/loaded_plugin.dart';
import 'package:meiyou/data/models/plugin.dart';
import 'package:meiyou/data/models/plugin_list.dart';
import 'package:meiyou/domain/entities/plugin.dart';
import 'package:meiyou/domain/repositories/plugin_repository.dart';
import 'package:ok_http_dart/ok_http_dart.dart';
import 'package:meiyou/core/utils/extenstions/string.dart';

class PluginRepositoryImpl implements PluginRepository {
  PluginRepositoryImpl(this._pluginDir);

  late final PluginDao _pluginDao = PluginDao(_pluginDir);

  static const _extenstionsUrl =
      'https://raw.githubusercontent.com/Noobware1/meiyou-extenstions/master/utils/extenstions.json';

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
    // void runInIsolate(SendPort sendPort) {
    //   late final StreamSubscription subscription;
    //   subscription = _getInstalledPlugins().listen((data) {
    //     sendPort.send(data);
    //   }, onDone: () {
    //     subscription.cancel();
    //     sendPort.send('close');
    //   });
    // }

    // final ReceivePort receivePort = ReceivePort();

    // final isolate = await Isolate.spawn(
    //   runInIsolate,
    //   receivePort.sendPort,
    //   onError: receivePort.sendPort,
    //   onExit: receivePort.sendPort,
    //   errorsAreFatal: true,
    // );

    // await for (var event in receivePort) {
    //   try {
    //     if (event == 'close') {
    //       isolate.kill(priority: 0);
    //       receivePort.close();
    //     } else {
    //       yield event as Plugin;
    //     }
    //   } catch (e) {
    //     // onFailed()
    //     continue;
    //   }
    // }
  }

  Stream<Plugin> _getInstalledPlugins() async* {
    final list = Directory(_pluginDir).listSync().whereType<Directory>();

    if (list.isEmpty) {
      throw NoPluginsFound('No Plugin Found!');
    }
    for (Directory pluginDir in list) {
      try {
        final file = File('${pluginDir.path}/plugin.json');
        final plugin = Plugin.decode(await file.readAsString());

        yield plugin;
      } catch (e, s) {
        yield* Stream.error(e, s);
        continue;
      }
    }
  }

  @override
  Future<Plugin> installPlugin(PluginEntity plugin) async {
    return _pluginDao.installPlugin(Plugin.fromEntity(plugin));
  }

  @override
  Future<BasePluginApi> loadPlugin(PluginEntity plugin) async {
    final complied = await File(plugin.source).readAsBytes();
    final runtime = runtimeEval(complied);
    return runtime.executeLib('package:meiyou/main.dart', 'main')
        as BasePluginApi;
  }
}

class NoPluginsFound implements Exception {
  final String message;
  NoPluginsFound(this.message);
}
