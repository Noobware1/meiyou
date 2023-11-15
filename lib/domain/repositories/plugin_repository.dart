import 'package:meiyou/core/plugin/base_plugin_api.dart';
import 'package:meiyou/core/resources/response_state.dart';
import 'package:meiyou/domain/entities/loaded_plugin.dart';
import 'package:meiyou/domain/entities/plugin.dart';
import 'package:meiyou/domain/entities/plugin_list.dart';

abstract class PluginRepository {
  Future<ResponseState<List<PluginListEntity>>> getAllPlugins();

  // Future<ResponseState<PluginListEntity>> getInstalledPlugin(String type);

  Stream<List<PluginEntity>> getInstalledPlugins();

  Future<PluginEntity> installPlugin(PluginEntity plugin);

  Future<BasePluginApi> loadPlugin(PluginEntity plugin);
}
