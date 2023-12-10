import 'package:meiyou/core/usecases/usecase.dart';
import 'package:meiyou/domain/entities/installed_plugin.dart';
import 'package:meiyou/domain/repositories/plugin_manager_repository.dart';
import 'package:meiyou/domain/repositories/plugin_repository.dart';
import 'package:meiyou_extenstions/models.dart';

class LoadPluginUseCase
    implements UseCase<Future<BasePluginApi>, InstalledPluginEntity> {
  final PluginManagerRepository _repository;

  LoadPluginUseCase(this._repository);

  @override
  Future<BasePluginApi> call(InstalledPluginEntity params) {
    return _repository.loadPlugin(params);
  }
}
