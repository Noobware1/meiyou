import 'package:meiyou/core/usecases/usecase.dart';
import 'package:meiyou/domain/entities/plugin.dart';
import 'package:meiyou/domain/repositories/plugin_repository.dart';

class GetLastedUsedPluginUseCase implements UseCase<PluginEntity?, void> {
  final PluginRepository _pluginRepository;
  GetLastedUsedPluginUseCase(this._pluginRepository);

  @override
  PluginEntity? call(void params) {
    return _pluginRepository.getLastedUsedPlugin();
  }
}
