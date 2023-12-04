import 'package:meiyou/core/usecases/usecase.dart';
import 'package:meiyou/domain/entities/plugin.dart';
import 'package:meiyou/domain/repositories/plugin_repository.dart';

class InstallPluginUseCase
    implements UseCase<Future<PluginEntity>, PluginEntity> {
  final PluginRepository _repository;

  InstallPluginUseCase(this._repository);
  @override
  Future<PluginEntity> call(PluginEntity params) {
    return _repository.installPlugin(params);
  }
}
