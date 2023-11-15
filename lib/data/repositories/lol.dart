import 'dart:convert';
import 'dart:io';

import 'package:meiyou/data/models/plugin.dart';
import 'package:meiyou/data/repositories/plugin_repository_impl.dart';
import 'package:meiyou/data/repositories/test.dart';

void main(List<String> args) async {
  // final a =
  //     PluginManager('E:/Projects/meiyou-remake/meiyou/lib/data/repositories');
  // final plugins = await a.getAllPlugins();
  // final b = a.installPlugin(plugins.first.type, plugins.first.plugins.first);
  // print(b);
  // final f2 =
  //     File('E:/Projects/meiyou-remake/meiyou/build_extentsions/lol.dart');
  final gogo = File(
      'E:/Projects/meiyou-remake/meiyou/lib/data/repositories/anime/gogoanime/gogoanime.plugin');
  var plugin = Plugin.decode(await gogo.readAsString());
  // plugin = plugin.copyWith(
  //     source: jsonEncode({
  //   'meiyou': {'main.dart': (await f2.readAsString())}
  // }));
  // await gogo.writeAsString(plugin.encode);
  // print('success');
  // final a = PluginManager('');
  // final api = a.loadPlugin(plugin);

  await TestPlugin(plugin).runFullTest('demon slayer');
}
