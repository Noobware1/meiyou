import 'package:meiyou/core/usecases/usecase.dart';
import 'package:meiyou/domain/entities/installed_plugin.dart';
import 'package:meiyou/domain/repositories/plugin_manager_repository.dart';
import 'package:meiyou_extensions_lib/models.dart';

class InstallPluginUseCase
    implements UseCase<Future<InstalledPluginEntity>, OnlinePlugin> {
  final PluginManagerRepository _repository;

  InstallPluginUseCase(this._repository);
  @override
  Future<InstalledPluginEntity> call(OnlinePlugin params) {
    return _repository.installPlugin(params);
  }
}
