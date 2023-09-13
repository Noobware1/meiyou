import 'package:meiyou/core/usecases/usecase.dart';
import 'package:meiyou/core/usecases_container/usecase_container.dart';
import 'package:meiyou/domain/repositories/get_providers_list.dart';
import 'package:meiyou/domain/usecases/provider_use_cases/load_providers_use_case.dart';

class LoadProviderListRepositoryContainer
    extends UseCaseContainer<LoadProviderListRepositoryContainer> {
  final ProviderListRepository _repository;

  LoadProviderListRepositoryContainer(this._repository);

  @override
  Set<UseCase> get usecases => {
        LoadProvidersUseCase(_repository),
      };
}
