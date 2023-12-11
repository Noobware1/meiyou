import 'package:meiyou/core/usecases/usecase.dart';
import 'package:meiyou/domain/entities/installed_plugin.dart';
import 'package:meiyou/domain/repositories/plugin_manager_repository.dart';

class UninstallPluginUseCase
    implements UseCase<Future<void>, InstalledPluginEntity> {
  final PluginManagerRepository _repository;

  UninstallPluginUseCase(this._repository);
  @override
  Future<void> call(InstalledPluginEntity params) {
    return _repository.uninstallPlugin(params);
  }
}
