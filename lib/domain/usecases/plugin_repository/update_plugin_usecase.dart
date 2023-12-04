import 'package:meiyou/core/usecases/usecase.dart';
import 'package:meiyou/domain/entities/plugin.dart';
import 'package:meiyou/domain/repositories/plugin_repository.dart';

class UpdatePluginUseCase implements UseCase<Future<PluginEntity>, PluginEntity> {
  final PluginRepository _pluginRepository;
  UpdatePluginUseCase(this._pluginRepository);

  @override
  Future<PluginEntity> call(PluginEntity params) {
    return _pluginRepository.updatePlugin(params);
  }
}
