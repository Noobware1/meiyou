import 'package:meiyou/core/resources/response_state.dart';
import 'package:meiyou/core/usecases/usecase.dart';
import 'package:meiyou/domain/repositories/plugin_repository.dart';
import 'package:meiyou_extenstions/meiyou_extenstions.dart';

final class LoadHomePageUseCaseParams {
  final int page;
  final HomePageData data;

  LoadHomePageUseCaseParams({required this.page, required this.data});
}

class LoadHomePageUseCase
    implements
        UseCase<Future<ResponseState<HomePage>>, LoadHomePageUseCaseParams> {
  final PluginRepository _repository;

  LoadHomePageUseCase(this._repository);

  @override
  Future<ResponseState<HomePage>> call(LoadHomePageUseCaseParams params) {
    return _repository.loadHomePage(params.page, params.data);
  }
}
