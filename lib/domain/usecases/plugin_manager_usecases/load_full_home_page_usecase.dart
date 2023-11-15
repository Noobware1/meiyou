import 'package:meiyou/core/resources/response_state.dart';
import 'package:meiyou/core/usecases/usecase.dart';
import 'package:meiyou/domain/entities/homepage.dart';
import 'package:meiyou/domain/repositories/plugin_manager_repository.dart';

class LoadFullHomePageUseCase
    implements UseCase<Future<ResponseState<List<HomePageEntity>>>, void> {
  final PluginManagerRepository _repository;

  LoadFullHomePageUseCase(this._repository);

  @override
  Future<ResponseState<List<HomePageEntity>>> call(void params) {
    return _repository.loadFullHomePage();
  }
}
