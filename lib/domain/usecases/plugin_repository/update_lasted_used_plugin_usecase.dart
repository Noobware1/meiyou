import 'package:meiyou/core/usecases/usecase.dart';
import 'package:meiyou/domain/entities/plugin.dart';
import 'package:meiyou/domain/repositories/plugin_repository.dart';

class UpdateLastedUsedPluginUseCaseParams {
  final PluginEntity previous;
  final PluginEntity current;

  UpdateLastedUsedPluginUseCaseParams(
      {required this.previous, required this.current});
}

class UpdateLastedUsedPluginUseCase
    implements UseCase<void, UpdateLastedUsedPluginUseCaseParams> {
  final PluginRepository _pluginRepository;
  UpdateLastedUsedPluginUseCase(this._pluginRepository);

  @override
  void call(UpdateLastedUsedPluginUseCaseParams params) {
    return _pluginRepository.updateLastUsedPlugin(
        params.previous, params.current);
  }
}
