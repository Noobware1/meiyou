import 'package:meiyou/core/usecases/usecase.dart';
import 'package:meiyou/domain/entities/plugin.dart';
import 'package:meiyou/domain/repositories/plugin_repository.dart';



class GetInstalledPluginsUseCase
    implements UseCase<Stream<List<PluginEntity>>, void> {
  final PluginRepository _repository;

  GetInstalledPluginsUseCase(this._repository);

  @override
  Stream<List<PluginEntity>> call(void params) {
    return _repository.getInstalledPlugins();
  }
}
