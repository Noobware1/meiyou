import 'package:meiyou/core/resources/provider_type.dart';
import 'package:meiyou/core/usecases/usecase.dart';
import 'package:meiyou/domain/entities/search_response.dart';
import 'package:meiyou/domain/repositories/watch_provider_repository.dart';

class FindBestSearchResponseParams {
  final List<SearchResponseEntity> responses;
  final ProviderType type;

  const FindBestSearchResponseParams(
      {required this.responses, required this.type});
}

class FindBestSearchResponseUseCase
    implements UseCase<SearchResponseEntity, FindBestSearchResponseParams> {
  final WatchProviderRepository _repository;

  FindBestSearchResponseUseCase(WatchProviderRepository repository)
      : _repository = repository;

  @override
  SearchResponseEntity call(FindBestSearchResponseParams params) {
    return _repository.findBestSearchResponse(params.responses, params.type);
  }
}
