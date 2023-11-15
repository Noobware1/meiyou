import 'package:meiyou/core/resources/response_state.dart';
import 'package:meiyou/core/usecases/usecase.dart';
import 'package:meiyou/domain/entities/loaded_plugin.dart';
import 'package:meiyou/domain/entities/plugin.dart';
import 'package:meiyou/domain/entities/plugin_list.dart';
import 'package:meiyou/domain/repositories/plugin_repository.dart';

// class GetInstalledPluginsUseCaseParams {
//   final PluginEntity? loadFirst;
//   final void Function(PluginEntity plugin)? onFailed;

//   GetInstalledPluginsUseCaseParams(this.loadFirst, this.onFailed);
// }

class GetInstalledPluginsUseCase
    implements UseCase<Stream<List<PluginEntity>>, void> {
  final PluginRepository _repository;

  GetInstalledPluginsUseCase(this._repository);

  @override
  Stream<List<PluginEntity>> call(void params) {
    return _repository.getInstalledPlugins();
  }
}
