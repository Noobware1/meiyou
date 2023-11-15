import 'package:meiyou/core/plugin/base_plugin_api.dart';
import 'package:meiyou/core/usecases/usecase.dart';
import 'package:meiyou/domain/entities/plugin.dart';
import 'package:meiyou/domain/repositories/plugin_repository.dart';

class LoadPluginUseCase implements UseCase<Future<BasePluginApi>, PluginEntity> {
  final PluginRepository _repository;

  LoadPluginUseCase(this._repository);

  @override
  Future<BasePluginApi> call(PluginEntity params) {
    return _repository.loadPlugin(params);
  }
}
