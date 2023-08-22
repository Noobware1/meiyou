import 'package:meiyou/core/resources/providers/base_provider.dart';
import 'package:meiyou/core/resources/response_state.dart';
import 'package:meiyou/core/usecases/future_use_case.dart';
import 'package:meiyou/core/usecases/no_params.dart';
import 'package:meiyou/domain/entities/search_response.dart';
import 'package:meiyou/domain/repositories/watch_provider_repository.dart';

class ProviderSearchWithMediaUseCase
    implements FutureUseCase<List<SearchResponseEntity>, NoParams> {
  final WatchProviderRepository _repository;
  final BaseProvider _provider;

  const ProviderSearchWithMediaUseCase(
      {required WatchProviderRepository repository,
      required BaseProvider provider})
      : _repository = repository,
        _provider = provider;

  @override
  Future<ResponseState<List<SearchResponseEntity>>> call(NoParams params) {
    return _repository.searchUsingMedia(_provider);
  }
}
