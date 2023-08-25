import 'package:meiyou/core/resources/response_state.dart';
import 'package:meiyou/core/usecases/no_params.dart';
import 'package:meiyou/core/usecases/usecase.dart';
import 'package:meiyou/domain/entities/main_page.dart';
import 'package:meiyou/domain/repositories/meta_provider_repository.dart';

class GetMainPageUseCase
    implements UseCase<Future<ResponseState<MainPageEntity>>, NoParams> {
  final MetaProviderRepository _repository;

  const GetMainPageUseCase(MetaProviderRepository repository)
      : _repository = repository;

  @override
  Future<ResponseState<MainPageEntity>> call(NoParams params) {
    return _repository.fetchMainPage();
  }
}
