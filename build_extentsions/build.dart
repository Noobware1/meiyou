import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:isolate';
import 'package:meiyou/data/models/loaded_plugin.dart';
import 'package:meiyou/data/repositories/plugin_repository_impl.dart';
import 'package:meiyou/data/repositories/test.dart';
import 'import_all.dart';

void runInIsolate(SendPort sendPort) {
  late final StreamSubscription _subscription;
  _subscription = PluginRepositoryImpl('E:/Projects/meiyou/plugins')
      .getInstalledPlugins()
      .listen((data) {
    sendPort.send(data);
  }, onDone: () {
    _subscription.cancel();
    sendPort.send('close');
  });
}

void main(List<String> args) async {
  // final file = File("E:/Projects/meiyou/build_extentsions/gogo/code.dart");
  // final extractor =
  //     File("E:/Projects/meiyou/build_extentsions/gogo/extractor.dart");

  // final plugin = Plugin(
  //     name: 'GogoAnime',
  //     source: file.path,
  //     version: '0.0.1',
  //     dependencies: [
  //       Dependency(name: 'gogo_cdn', source: extractor.path, version: '0.0.1')
  //     ]);

  final repo = PluginRepositoryImpl('E:/Projects/meiyou/plugins');
  // print(.data?.map((e) => e.api));

  repo.getInstalledPlugins().listen((event) => print(event));

  // // final save = File(
  // //     "E:/Projects/meiyou/lib/data/repositories/anime/gogoanime/gogoanime.plugin");
  // var plugin = Plugin.decode(await save.readAsString());
  // // await TestPlugin(plugin).runFullTest('darling in the franx');
  // plugin = plugin.copyWith(
  //     source: jsonEncode({
  //   'meiyou': {'main.dart': await file.readAsString()}
  // }));

  // final test = TestPlugin(plugin).api;
  // print(await test.loadHomePage(
  //     1,
  //     HomePageRequest(
  //         name: test.homePage.first.name,
  //         data: test.homePage.first.data,
  //         horizontalImages: false)));

  print('done');
}
