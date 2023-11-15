import 'package:meiyou/core/resources/response_state.dart';
import 'package:meiyou/core/usecases/usecase.dart';
import 'package:meiyou/domain/entities/media_details.dart';
import 'package:meiyou/domain/entities/search_response.dart';
import 'package:meiyou/domain/repositories/plugin_manager_repository.dart';

class LoadMediaDetailsUseCase
    implements
        UseCase<Future<ResponseState<MediaDetailsEntity>>,
            SearchResponseEntity> {
  final PluginManagerRepository _repository;

  LoadMediaDetailsUseCase(this._repository);

  @override
  Future<ResponseState<MediaDetailsEntity>> call(SearchResponseEntity params) {
    return _repository.loadMediaDetails(params);
  }
}
