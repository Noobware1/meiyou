import 'package:meiyou/core/usecases/usecase.dart';
import 'package:meiyou/core/usecases_container/usecase_container.dart';
import 'package:meiyou/domain/repositories/get_providers_list.dart';
import 'package:meiyou/domain/usecases/provider_use_cases/load_providers_use_case.dart';
import 'package:meiyou/domain/usecases/providers_repository_usecases/get_default_provider_usecase.dart';
import 'package:meiyou/domain/usecases/providers_repository_usecases/save_default_provider_usecase.dart';

class ProvidersRepositoryContainer
    extends UseCaseContainer<ProvidersRepositoryContainer> {
  final ProvidersRepository _repository;

  ProvidersRepositoryContainer(this._repository);

  @override
  Set<UseCase> get usecases => {
        LoadProvidersUseCase(_repository),
        GetDefaultProviderUseCase(_repository),
        SaveDefaultProviderUseCase(_repository),
      };
}
