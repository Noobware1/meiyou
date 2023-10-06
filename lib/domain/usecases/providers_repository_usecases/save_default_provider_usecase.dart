import 'package:meiyou/core/resources/provider_type.dart';
import 'package:meiyou/core/resources/providers/base_provider.dart';
import 'package:meiyou/core/usecases/usecase.dart';
import 'package:meiyou/domain/repositories/get_providers_list.dart';

class SaveDefaultProviderUseCaseParams {
  final BaseProvider provider;
  final String directoryPath;
  final void Function()? callback;

  SaveDefaultProviderUseCaseParams(this.directoryPath, this.provider,
      [this.callback]);
}

class SaveDefaultProviderUseCase
    extends UseCase<Future<void>, SaveDefaultProviderUseCaseParams> {
  final ProvidersRepository _repository;

  SaveDefaultProviderUseCase(this._repository);

  @override
  Future<void> call(SaveDefaultProviderUseCaseParams params) {
    return _repository.saveDefaultProvider(
        params.provider, params.directoryPath, params.callback);
  }
}
