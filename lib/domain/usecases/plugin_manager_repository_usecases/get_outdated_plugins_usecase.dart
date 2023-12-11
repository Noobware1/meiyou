import 'package:meiyou/core/usecases/usecase.dart';
import 'package:meiyou/domain/entities/installed_plugin.dart';
import 'package:meiyou/domain/entities/plugin_list.dart';
import 'package:meiyou/domain/repositories/plugin_manager_repository.dart';
import 'package:meiyou_extenstions/models.dart';

class GetOutDatedPluginsUseCaseParams {
  final List<InstalledPluginEntity> installedPlugins;
  final List<PluginListEntity> pluginList;

  GetOutDatedPluginsUseCaseParams(
      {required this.installedPlugins, required this.pluginList});
}

class GetOutDatedPluginsUseCase
    implements
        UseCase<Map<InstalledPluginEntity, OnlinePlugin>?,
            GetOutDatedPluginsUseCaseParams> {
  final PluginManagerRepository _repository;

  GetOutDatedPluginsUseCase(this._repository);

  @override
  Map<InstalledPluginEntity, OnlinePlugin>? call(
      GetOutDatedPluginsUseCaseParams params) {
    return _repository.getOutDatedPlugins(
        params.installedPlugins, params.pluginList);
  }
}
