
import 'package:meiyou/core/usecases/usecase.dart';
import 'package:meiyou/domain/entities/installed_plugin.dart';
import 'package:meiyou/domain/repositories/plugin_manager_repository.dart';
import 'package:meiyou_extenstions/models.dart';

class UpdatePluginUseCase implements UseCase<Future<InstalledPluginEntity>, OnlinePlugin> {
  final PluginManagerRepository _pluginRepository;
  UpdatePluginUseCase(this._pluginRepository);

  @override
  Future<InstalledPluginEntity> call(OnlinePlugin params) {
    return _pluginRepository.updatePlugin(params);
  }
}
