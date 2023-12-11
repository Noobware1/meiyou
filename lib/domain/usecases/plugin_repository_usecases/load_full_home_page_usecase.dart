import 'package:meiyou/core/resources/response_state.dart';
import 'package:meiyou/core/usecases/usecase.dart';
import 'package:meiyou/domain/repositories/plugin_repository.dart';
import 'package:meiyou_extenstions/models.dart';

class LoadFullHomePageUseCase
    implements UseCase<Future<ResponseState<List<HomePage>>>, void> {
  final PluginRepository _repository;

  LoadFullHomePageUseCase(this._repository);

  @override
  Future<ResponseState<List<HomePage>>> call(void params) {
    return _repository.loadFullHomePage();
  }
}
