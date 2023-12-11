import 'package:meiyou/core/usecases/usecase.dart';
import 'package:meiyou/domain/entities/installed_plugin.dart';
import 'package:meiyou/domain/repositories/plugin_manager_repository.dart';

class GetInstalledPluginsUseCase
    implements UseCase<Stream<List<InstalledPluginEntity>>, void> {
  final PluginManagerRepository _repository;

  GetInstalledPluginsUseCase(this._repository);

  @override
  Stream<List<InstalledPluginEntity>> call(void params) {
    return _repository.getInstalledPlugins();
  }
}
