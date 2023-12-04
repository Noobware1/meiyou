import 'package:meiyou/core/usecases/usecase.dart';
import 'package:meiyou/domain/entities/plugin.dart';
import 'package:meiyou/domain/entities/plugin_list.dart';
import 'package:meiyou/domain/repositories/plugin_repository.dart';

class GetOutDatedPluginsUseCaseParams {
  final List<PluginEntity> installedPlugins;
  final List<PluginListEntity> pluginList;

  GetOutDatedPluginsUseCaseParams(
      {required this.installedPlugins, required this.pluginList});
}

class GetOutDatedPluginsUseCase
    implements
        UseCase<Map<PluginEntity, PluginEntity>?, GetOutDatedPluginsUseCaseParams> {
  final PluginRepository _repository;

  GetOutDatedPluginsUseCase(this._repository);

  @override
  Map<PluginEntity, PluginEntity>? call(GetOutDatedPluginsUseCaseParams params) {
    return _repository.getOutDatedPlugins(
        params.installedPlugins, params.pluginList);
  }
}
