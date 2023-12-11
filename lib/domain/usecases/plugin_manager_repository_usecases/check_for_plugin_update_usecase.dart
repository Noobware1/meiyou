import 'package:meiyou/core/usecases/usecase.dart';
import 'package:meiyou/domain/entities/installed_plugin.dart';
import 'package:meiyou/domain/entities/plugin_list.dart';
import 'package:meiyou/domain/repositories/plugin_manager_repository.dart';

class CheckForPluginUpdateUseCaseParams {
  final InstalledPluginEntity installedPlugin;
  final List<PluginListEntity> plugins;

  CheckForPluginUpdateUseCaseParams(
      {required this.installedPlugin, required this.plugins});
}

class CheckForPluginUpdateUseCase
    implements
        UseCase<InstalledPluginEntity?, CheckForPluginUpdateUseCaseParams> {
  final PluginManagerRepository _repository;

  CheckForPluginUpdateUseCase(this._repository);

  @override
  InstalledPluginEntity? call(CheckForPluginUpdateUseCaseParams params) {
    return _repository.checkForPluginUpdate(
        params.installedPlugin, params.plugins);
  }
}
