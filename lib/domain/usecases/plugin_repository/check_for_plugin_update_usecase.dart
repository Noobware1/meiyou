import 'package:meiyou/core/usecases/usecase.dart';
import 'package:meiyou/domain/entities/plugin.dart';
import 'package:meiyou/domain/entities/plugin_list.dart';
import 'package:meiyou/domain/repositories/plugin_repository.dart';

class CheckForPluginUpdateUseCaseParams {
  PluginEntity installedPlugin;
  List<PluginListEntity> plugins;

  CheckForPluginUpdateUseCaseParams(
      {required this.installedPlugin, required this.plugins});
}

class CheckForPluginUpdateUseCase
    implements UseCase<PluginEntity?, CheckForPluginUpdateUseCaseParams> {
  final PluginRepository _repository;

  CheckForPluginUpdateUseCase(this._repository);

  @override
  PluginEntity? call(CheckForPluginUpdateUseCaseParams params) {
    return _repository.checkForPluginUpdate(params.installedPlugin, params.plugins);
  }
}
