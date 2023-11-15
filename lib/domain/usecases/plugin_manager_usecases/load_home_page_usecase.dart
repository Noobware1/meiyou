import 'package:meiyou/core/resources/response_state.dart';
import 'package:meiyou/core/usecases/usecase.dart';
import 'package:meiyou/domain/entities/homepage.dart';
import 'package:meiyou/domain/repositories/plugin_manager_repository.dart';

final class LoadHomePageUseCaseParams {
  final int page;
  final HomePageDataEntity data;

  LoadHomePageUseCaseParams({required this.page, required this.data});
}

class LoadHomePageUseCase
    implements
        UseCase<Future<ResponseState<HomePageEntity>>,
            LoadHomePageUseCaseParams> {
  final PluginManagerRepository _repository;

  LoadHomePageUseCase(this._repository);

  @override
  Future<ResponseState<HomePageEntity>> call(LoadHomePageUseCaseParams params) {
    return _repository.loadHomePage(params.page, params.data);
  }
}
