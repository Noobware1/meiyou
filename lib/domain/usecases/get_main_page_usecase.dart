import 'package:meiyou/core/resources/response_state.dart';
import 'package:meiyou/core/usecases/usecase.dart';
import 'package:meiyou/domain/entities/main_page.dart';
import 'package:meiyou/domain/repositories/main_page_repository.dart';

class GetMainPageUseCase
    implements UseCase<Future<ResponseState<MainPageEntity>>, String> {
  final MainPageRepository _repository;

  const GetMainPageUseCase(this._repository);

  @override
  Future<ResponseState<MainPageEntity>> call(String params) {
    return _repository.getMainPage();
  }
}
