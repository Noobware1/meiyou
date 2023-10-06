import 'package:meiyou/core/resources/providers/base_provider.dart';
import 'package:meiyou/core/usecases/usecase.dart';
import 'package:meiyou/domain/repositories/get_providers_list.dart';

class LoadProvidersUseCase
    implements UseCase<Map<String, BaseProvider>, String> {
  final ProvidersRepository _repository;

  const LoadProvidersUseCase(this._repository);

  @override
  Map<String, BaseProvider> call(String params) {
    return _repository.getProviderList(params);
  }
}
