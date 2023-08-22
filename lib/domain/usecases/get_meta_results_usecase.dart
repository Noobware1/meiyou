import 'package:meiyou/core/resources/response_state.dart';
import 'package:meiyou/core/usecases/usecase.dart';
import 'package:meiyou/core/utils/search_params.dart';
import 'package:meiyou/domain/entities/results.dart';
import 'package:meiyou/domain/repositories/meta_results_repository.dart';

class GetMainPageUseCase
    implements UseCase<Future<ResponseState<MetaResultsEntity>>, SearchParams> {
  final MetaResultsRepository _repository;

  const GetMainPageUseCase(this._repository);

  @override
  Future<ResponseState<MetaResultsEntity>> call(SearchParams params) {
    return _repository.getSearch(params.query,
        page: params.page, isAdult: params.isAdult);
  }
}
