import 'package:meiyou/core/resources/provider_type.dart';
import 'package:meiyou/core/resources/providers/base_provider.dart';
import 'package:meiyou/core/usecases/usecase.dart';
import 'package:meiyou/domain/repositories/get_providers_list.dart';

class GetDefaultProviderUseCaseParams {
  final String directoryPath;
  final ProviderType providerType;

  GetDefaultProviderUseCaseParams(
    this.directoryPath,
    this.providerType,
  );
}

class GetDefaultProviderUseCase
    extends UseCase<Future<BaseProvider?>, GetDefaultProviderUseCaseParams> {
  final ProvidersRepository _repository;

  GetDefaultProviderUseCase(this._repository);

  @override
  Future<BaseProvider?> call(GetDefaultProviderUseCaseParams params) {
    return _repository.getDefaultProvider(
        params.providerType, params.directoryPath);
  }
}
