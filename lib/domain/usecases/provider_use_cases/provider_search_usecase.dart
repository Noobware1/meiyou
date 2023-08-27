import 'package:meiyou/core/resources/providers/base_provider.dart';
import 'package:meiyou/core/resources/response_state.dart';
import 'package:meiyou/core/usecases/usecase.dart';
import 'package:meiyou/domain/entities/search_response.dart';
import 'package:meiyou/domain/repositories/watch_provider_repository.dart';

class ProviderSearchWithQueryUseCase
    implements UseCase<Future<ResponseState<List<SearchResponseEntity>>>, String> {
  final WatchProviderRepository _repository;
  final BaseProvider _provider;

  const ProviderSearchWithQueryUseCase(
      {required WatchProviderRepository repository,
      required BaseProvider provider})
      : _repository = repository,
        _provider = provider;

  @override
  Future<ResponseState<List<SearchResponseEntity>>> call(String params) {
    return _repository.searchWithQuery(_provider, params);
  }
}
