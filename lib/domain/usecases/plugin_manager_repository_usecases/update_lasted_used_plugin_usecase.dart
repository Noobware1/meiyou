import 'package:meiyou/core/usecases/usecase.dart';
import 'package:meiyou/domain/entities/installed_plugin.dart';
import 'package:meiyou/domain/repositories/plugin_manager_repository.dart';
import 'package:meiyou/domain/repositories/plugin_repository.dart';

class UpdateLastedUsedPluginUseCaseParams {
  final InstalledPluginEntity previous;
  final InstalledPluginEntity current;

  UpdateLastedUsedPluginUseCaseParams(
      {required this.previous, required this.current});
}

class UpdateLastedUsedPluginUseCase
    implements UseCase<void, UpdateLastedUsedPluginUseCaseParams> {
  final PluginManagerRepository _pluginRepository;
  UpdateLastedUsedPluginUseCase(this._pluginRepository);

  @override
  void call(UpdateLastedUsedPluginUseCaseParams params) {
    return _pluginRepository.updateLastUsedPlugin(
        params.previous, params.current);
  }
}
