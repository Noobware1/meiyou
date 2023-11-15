import 'package:meiyou/core/resources/response_state.dart';
import 'package:meiyou/core/usecases/usecase.dart';
import 'package:meiyou/core/utils/search_params.dart';
import 'package:meiyou/domain/entities/results.dart';
import 'package:meiyou/domain/repositories/meta_provider_repository.dart';

class GetSearchUseCase
    implements UseCase<Future<ResponseState<MetaResultsEntity>>, SearchParams> {
  final MetaProviderRepository _repository;

  const GetSearchUseCase(MetaProviderRepository repository)
      : _repository = repository;

  @override
  Future<ResponseState<MetaResultsEntity>> call(SearchParams params) {
    return _repository.fetchSearch(params.query,
        page: params.page, isAdult: params.isAdult);
  }
}
