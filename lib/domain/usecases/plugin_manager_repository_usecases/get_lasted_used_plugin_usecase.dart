import 'package:meiyou/core/usecases/usecase.dart';
import 'package:meiyou/domain/entities/installed_plugin.dart';
import 'package:meiyou/domain/repositories/plugin_manager_repository.dart';

class GetLastedUsedPluginUseCase
    implements UseCase<InstalledPluginEntity?, void> {
  final PluginManagerRepository _pluginRepository;
  GetLastedUsedPluginUseCase(this._pluginRepository);

  @override
  InstalledPluginEntity? call(void params) {
    return _pluginRepository.getLastedUsedPlugin();
  }
}
