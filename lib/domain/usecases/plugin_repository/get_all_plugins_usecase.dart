import 'package:meiyou/core/resources/response_state.dart';
import 'package:meiyou/core/usecases/usecase.dart';
import 'package:meiyou/domain/entities/plugin_list.dart';
import 'package:meiyou/domain/repositories/plugin_repository.dart';

class GetAllPluginsUseCase
    implements UseCase<Future<ResponseState<List<PluginListEntity>>>, void> {
  final PluginRepository _repository;

  GetAllPluginsUseCase(this._repository);
  @override
  Future<ResponseState<List<PluginListEntity>>> call(void params) {
    return _repository.getAllPlugins();
  }
}
