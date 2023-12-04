import 'package:meiyou/core/usecases/usecase.dart';
import 'package:meiyou/domain/entities/plugin.dart';
import 'package:meiyou/domain/repositories/plugin_repository.dart';

class UninstallPluginUseCase
    implements UseCase<Future<void>, PluginEntity> {
  final PluginRepository _repository;

  UninstallPluginUseCase(this._repository);
  @override
  Future<void> call(PluginEntity params) {
    return _repository.uninstallPlugin(params);
  }
}
